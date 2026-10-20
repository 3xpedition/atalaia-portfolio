[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$failures = [System.Collections.Generic.List[string]]::new()

function Assert-Portfolio {
    param(
        [Parameter(Mandatory)] [bool] $Condition,
        [Parameter(Mandatory)] [string] $Message
    )

    if (-not $Condition) {
        $script:failures.Add($Message)
    }
}

$requiredPaths = @(
    'README.md',
    'PRODUCT.md',
    'LICENSE',
    'docs/index.html',
    'docs/examples/index.html',
    'docs/assets/favicon.svg',
    'docs/assets/styles.css',
    'docs/assets/main.js',
    'docs/assets/media/README.md',
    'docs/assets/media/hero-rede-distribuida.png',
    'docs/assets/media/jornada-dados.png',
    'docs/assets/media/operacao-regioes-remotas.png',
    'docs/arquitetura/README.md',
    'docs/diagramas/componentes.md',
    'docs/mobile/README.md',
    'docs/screenshots/README.md',
    'examples/README.md',
    'examples/controllers/PainelDesempenhoController.php',
    'examples/services/FaixaDesempenhoService.php',
    'examples/services/DistribuicaoVagasService.php',
    'examples/views/painel-faixas.blade.php',
    'examples/sql/efetivo_evasao_ciclo.sql',
    'examples/js/quebras-naturais.js',
    'examples/android/EnvioRegistroWorker.kt'
)

foreach ($relativePath in $requiredPaths) {
    $fullPath = Join-Path $repositoryRoot $relativePath
    Assert-Portfolio -Condition (Test-Path -LiteralPath $fullPath) -Message "Arquivo obrigatorio ausente: $relativePath"
}

$readme = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repositoryRoot 'README.md')
$site = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repositoryRoot 'docs/index.html')
$examplesSite = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repositoryRoot 'docs/examples/index.html')

$requiredTerms = @(
    'Nexo', 'offline-first', 'Laravel', 'MySQL', 'Kotlin',
    'WorkManager', 'SQLCipher', 'dados fict',
    'estudo de caso independente'
)

foreach ($term in $requiredTerms) {
    Assert-Portfolio -Condition ($site.Contains($term) -or $readme.Contains($term)) -Message "Termo essencial ausente: $term"
}

Assert-Portfolio -Condition ([regex]::IsMatch($site, 'Este portf.lio n.o . um canal oficial')) -Message 'Aviso de independencia ausente.'
Assert-Portfolio -Condition ($site.Contains('representa, endossa ou reproduz qualquer')) -Message 'Limite de representacao ausente.'
Assert-Portfolio -Condition ($examplesSite.Contains('Nenhum arquivo foi copiado')) -Message 'Aviso do laboratorio ausente.'
Assert-Portfolio -Condition (-not $site.Contains('<video')) -Message 'A pagina principal nao deve usar videos reais.'
Assert-Portfolio -Condition (-not $site.Contains('borrad')) -Message 'A pagina principal nao deve depender de conteudo borrado.'

$allowedRasterAssets = @(
    'docs/assets/media/hero-rede-distribuida.png',
    'docs/assets/media/jornada-dados.png',
    'docs/assets/media/operacao-regioes-remotas.png'
)
$controlledAssetExtensions = @('.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.mp4', '.mov', '.avi', '.pdf', '.xlsx', '.xls')
$controlledAssets = Get-ChildItem -LiteralPath (Join-Path $repositoryRoot 'docs') -Recurse -File |
    Where-Object { $controlledAssetExtensions -contains $_.Extension.ToLowerInvariant() }
foreach ($asset in $controlledAssets) {
    $relativeAsset = $asset.FullName.Substring($repositoryRoot.Length + 1).Replace('\', '/')
    Assert-Portfolio -Condition ($allowedRasterAssets -contains $relativeAsset) -Message "Midia publica sem autorizacao no manifesto: $relativeAsset"
}

$mediaManifest = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repositoryRoot 'docs/assets/media/README.md')
foreach ($relativeAsset in $allowedRasterAssets) {
    $assetName = Split-Path -Leaf $relativeAsset
    Assert-Portfolio -Condition ($mediaManifest.Contains($assetName)) -Message "Midia sem registro de procedencia: $assetName"
}

$textExtensions = @('.md', '.html', '.css', '.js', '.php', '.sql', '.txt', '.kt', '.svg', '.ps1')
$publicFiles = Get-ChildItem -LiteralPath $repositoryRoot -Recurse -File |
    Where-Object {
        $_.FullName -notlike '*\.git\*' -and
        $_.FullName -notlike '*\tests\*' -and
        $textExtensions -contains $_.Extension.ToLowerInvariant()
    }

$forbiddenInstitutionalPatterns = @(
    '(?i)Ex.rcito\s+Brasileiro',
    '(?i)Escola\s+de\s+Sargentos',
    '(?i)\bUETEs?\b',
    '(?i)\bCOP\s+Educa..o\b',
    '(?i)\bQMS\b',
    '(?i)\bFATD\b',
    '(?i)\bFRAD\b',
    '(?i)\bSSAA\b',
    '(?i)Painel\s+Oficial'
)

$secretPatterns = @(
    '(?i)(password|passwd|senha|token|secret|api[_-]?key)\s*[:=]\s*["''][^"'']+["'']',
    '(?<!\d)(10\.\d{1,3}\.\d{1,3}\.\d{1,3}|192\.168\.\d{1,3}\.\d{1,3}|172\.(1[6-9]|2\d|3[01])\.\d{1,3}\.\d{1,3})(?!\d)',
    '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
)

foreach ($file in $publicFiles) {
    $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
    foreach ($pattern in $forbiddenInstitutionalPatterns) {
        Assert-Portfolio -Condition (-not [regex]::IsMatch($content, $pattern)) -Message "Referencia institucional proibida em $($file.FullName): $pattern"
    }
    foreach ($pattern in $secretPatterns) {
        Assert-Portfolio -Condition (-not [regex]::IsMatch($content, $pattern)) -Message "Possivel segredo ou endereco privado em $($file.FullName)"
    }
}

$htmlFiles = Get-ChildItem -LiteralPath (Join-Path $repositoryRoot 'docs') -Recurse -File -Filter '*.html'
foreach ($htmlFile in $htmlFiles) {
    $html = Get-Content -Raw -Encoding UTF8 -LiteralPath $htmlFile.FullName
    foreach ($attribute in @('href', 'src')) {
        $matches = [regex]::Matches($html, "$attribute=`"([^`"]+)`"")
        foreach ($match in $matches) {
            $reference = $match.Groups[1].Value
            if ($reference.StartsWith('#') -or $reference.StartsWith('http://') -or $reference.StartsWith('https://') -or $reference.StartsWith('mailto:')) {
                continue
            }
            $withoutFragment = $reference.Split('#')[0].Split('?')[0]
            $target = [System.IO.Path]::GetFullPath((Join-Path $htmlFile.DirectoryName $withoutFragment))
            Assert-Portfolio -Condition (Test-Path -LiteralPath $target) -Message "Referencia local invalida em $($htmlFile.FullName): $reference"
        }
    }
}

$oldFolders = @('docs/assets/gaviao', 'docs/assets/mobile', 'docs/assets/team')
foreach ($folder in $oldFolders) {
    Assert-Portfolio -Condition (-not (Test-Path -LiteralPath (Join-Path $repositoryRoot $folder))) -Message "Pasta de ativos reais ainda presente: $folder"
}

$nestedRepositories = Get-ChildItem -LiteralPath $repositoryRoot -Recurse -Directory -Force -Filter '.git' |
    Where-Object { $_.FullName -ne (Join-Path $repositoryRoot '.git') }
Assert-Portfolio -Condition ($nestedRepositories.Count -eq 0) -Message 'Foi encontrado um histórico Git aninhado.'

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Validacao concluida: $($requiredPaths.Count) arquivos essenciais e $($publicFiles.Count) arquivos publicos verificados."
