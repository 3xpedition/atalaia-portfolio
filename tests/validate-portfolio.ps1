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

function Get-RelativeLuminance {
    param([Parameter(Mandatory)] [string] $HexColor)

    $hex = $HexColor.TrimStart('#')
    $channels = @(0, 2, 4 | ForEach-Object { [Convert]::ToInt32($hex.Substring($_, 2), 16) / 255 })
    $linear = $channels | ForEach-Object {
        if ($_ -le 0.03928) { $_ / 12.92 } else { [Math]::Pow(($_ + 0.055) / 1.055, 2.4) }
    }

    return 0.2126 * $linear[0] + 0.7152 * $linear[1] + 0.0722 * $linear[2]
}

function Get-ContrastRatio {
    param(
        [Parameter(Mandatory)] [string] $Foreground,
        [Parameter(Mandatory)] [string] $Background
    )

    $foregroundLuminance = Get-RelativeLuminance $Foreground
    $backgroundLuminance = Get-RelativeLuminance $Background
    return ([Math]::Max($foregroundLuminance, $backgroundLuminance) + 0.05) / `
        ([Math]::Min($foregroundLuminance, $backgroundLuminance) + 0.05)
}

$requiredPaths = @(
    'README.md',
    'PRODUCT.md',
    'LICENSE',
    'RIGHTS.md',
    'docs/index.html',
    'docs/examples/index.html',
    'docs/ACESSIBILIDADE.md',
    'docs/assets/favicon.svg',
    'docs/assets/styles.css',
    'docs/assets/main.js',
    'docs/assets/media/README.md',
    'docs/assets/media/hero-rede-distribuida.png',
    'docs/assets/media/operacao-regioes-remotas.png',
    'docs/assets/media/painel-jornada-integrada.png',
    'docs/assets/media/mobile-login-demonstrativo.png',
    'docs/assets/media/mobile-consulta-demonstrativa.png',
    'docs/assets/media/jornada-entrada-distribuida.png',
    'docs/assets/media/jornada-cobertura-nacional.png',
    'docs/assets/media/jornada-decisao-verificavel.png',
    'docs/assets/media/produto-nucleo-gestao.png',
    'docs/assets/media/produto-nucleo-decisao.png',
    'docs/assets/media/equipe-joao-victor-profissional.png',
    'docs/assets/media/equipe-alexandre-ferreira-profissional.png',
    'docs/assets/media/equipe-natanael-cirino-profissional.png',
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
$license = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repositoryRoot 'LICENSE')
$rights = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repositoryRoot 'RIGHTS.md')
$site = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repositoryRoot 'docs/index.html')
$examplesSite = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repositoryRoot 'docs/examples/index.html')
$styles = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repositoryRoot 'docs/assets/styles.css')
$mainScript = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repositoryRoot 'docs/assets/main.js')

$requiredTerms = @(
    'Atalaia', 'Gavi', 'offline-first', 'Laravel', 'MySQL', 'Kotlin',
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
Assert-Portfolio -Condition ($license.Contains('docs/assets/media/')) -Message 'Escopo da Licenca MIT nao foi delimitado.'
Assert-Portfolio -Condition ($license.Contains('Consulte RIGHTS.md')) -Message 'LICENSE nao referencia as regras de midia e imagem.'
Assert-Portfolio -Condition ($rights.Contains('treinar modelos')) -Message 'Protecao dos retratos ausente em RIGHTS.md.'
Assert-Portfolio -Condition ($rights.Contains('Nenhum direito adicional')) -Message 'Separacao entre codigo e ilustracoes ausente.'
Assert-Portfolio -Condition ($readme.Contains('RIGHTS.md')) -Message 'README nao informa a excecao de midias.'
Assert-Portfolio -Condition ([regex]::IsMatch($site, 'O c.digo demonstrativo possui licen.a pr.pria')) -Message 'Aviso publico de direitos de midia ausente.'
Assert-Portfolio -Condition ($site.Contains('id="conformidade"')) -Message 'Secao publica de conformidade ausente.'
Assert-Portfolio -Condition ([regex]::IsMatch($site, 'Independente e n.o oficial')) -Message 'Declaracao de independencia ausente na conformidade.'
Assert-Portfolio -Condition ($site.Contains('LGPD')) -Message 'Referencia publica a privacidade e LGPD ausente.'
Assert-Portfolio -Condition ([regex]::IsMatch($site, 'normas aplic.veis de seguran.a cibern.tica')) -Message 'Compromisso de seguranca cibernetica ausente.'
Assert-Portfolio -Condition ([regex]::IsMatch($site, 'autorais, sint.ticas ou expressamente autorizadas')) -Message 'Procedencia publica de imagens ausente.'
Assert-Portfolio -Condition ([regex]::IsMatch($site, 'n.o utiliza intelig.ncia artificial nativa')) -Message 'Limite de uso de IA ausente.'

$allowedRasterAssets = @(
    'docs/assets/media/hero-rede-distribuida.png',
    'docs/assets/media/operacao-regioes-remotas.png',
    'docs/assets/media/painel-jornada-integrada.png',
    'docs/assets/media/mobile-login-demonstrativo.png',
    'docs/assets/media/mobile-consulta-demonstrativa.png',
    'docs/assets/media/jornada-entrada-distribuida.png',
    'docs/assets/media/jornada-cobertura-nacional.png',
    'docs/assets/media/jornada-decisao-verificavel.png',
    'docs/assets/media/produto-nucleo-gestao.png',
    'docs/assets/media/produto-nucleo-decisao.png',
    'docs/assets/media/equipe-joao-victor-profissional.png',
    'docs/assets/media/equipe-alexandre-ferreira-profissional.png',
    'docs/assets/media/equipe-natanael-cirino-profissional.png'
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

$privatePngChunks = @('eXIf', 'tEXt', 'zTXt', 'iTXt', 'tIME')
foreach ($relativeAsset in ($allowedRasterAssets | Where-Object { $_.EndsWith('.png') })) {
    $assetPath = Join-Path $repositoryRoot $relativeAsset
    $bytes = [System.IO.File]::ReadAllBytes($assetPath)
    $offset = 8
    $chunks = [System.Collections.Generic.List[string]]::new()

    while ($offset + 12 -le $bytes.Length) {
        $length = [System.Net.IPAddress]::NetworkToHostOrder([BitConverter]::ToInt32($bytes, $offset))
        $chunk = [Text.Encoding]::ASCII.GetString($bytes, $offset + 4, 4)
        $chunks.Add($chunk)
        $offset += 12 + $length

        if ($chunk -eq 'IEND') {
            break
        }
    }

    $privateChunks = @($chunks | Where-Object { $privatePngChunks -contains $_ })
    Assert-Portfolio -Condition ($privateChunks.Count -eq 0) `
        -Message "Midia publica contem metadados privados ou textuais: $relativeAsset ($($privateChunks -join ', '))"
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

$forbiddenTechnicalPatterns = @(
    '(?i)\b(?:PHP|Laravel|MySQL|Kotlin|Android|SQLCipher|Nginx|Apache)\s+v?\d+(?:\.\d+){0,2}\b',
    '(?i)\b(?:Bearer|PBKDF2|AES-SIV|X\.509|PHP-FPM|Nginx)\b',
    '(?i)(?:^|["''])/api/(?:v\d+/)?',
    '(?i)\b(?:perfil|permiss.o)\s*[:#=\-]?\s*9\d{3}\b',
    '(?i)\b(?:token|sess.o).{0,30}\b\d+\s*(?:minutos?|horas?|dias?|h)\b'
)

$allowedPublicHosts = @('3xpedition.github.io', 'github.com', 'www.w3.org')

foreach ($file in $publicFiles) {
    $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
    foreach ($pattern in $forbiddenInstitutionalPatterns) {
        Assert-Portfolio -Condition (-not [regex]::IsMatch($content, $pattern)) -Message "Referencia institucional proibida em $($file.FullName): $pattern"
    }
    foreach ($pattern in $secretPatterns) {
        Assert-Portfolio -Condition (-not [regex]::IsMatch($content, $pattern)) -Message "Possivel segredo ou endereco privado em $($file.FullName)"
    }
    foreach ($pattern in $forbiddenTechnicalPatterns) {
        Assert-Portfolio -Condition (-not [regex]::IsMatch($content, $pattern)) -Message "Detalhe tecnico operacional proibido em $($file.FullName): $pattern"
    }

    $publicUrls = [regex]::Matches($content, 'https?://[^\s"''<>)]+')
    foreach ($publicUrl in $publicUrls) {
        $hostName = ([Uri] $publicUrl.Value).Host
        Assert-Portfolio -Condition ($allowedPublicHosts -contains $hostName) -Message "Host publico nao autorizado em $($file.FullName): $hostName"
    }
}

$forbiddenArtifactExtensions = @('.pem', '.key', '.pfx', '.p12', '.crt', '.cer', '.dump', '.bak')
$repositoryFiles = Get-ChildItem -LiteralPath $repositoryRoot -Recurse -File -Force |
    Where-Object { $_.FullName -notlike '*\.git\*' }
foreach ($repositoryFile in $repositoryFiles) {
    $relativeRepositoryFile = $repositoryFile.FullName.Substring($repositoryRoot.Length + 1).Replace('\', '/')
    Assert-Portfolio -Condition (-not $relativeRepositoryFile.StartsWith('.env')) -Message "Arquivo de ambiente proibido: $relativeRepositoryFile"
    Assert-Portfolio -Condition (-not ($forbiddenArtifactExtensions -contains $repositoryFile.Extension.ToLowerInvariant())) `
        -Message "Certificado, chave ou artefato de infraestrutura proibido: $relativeRepositoryFile"
    if ($repositoryFile.Extension -eq '.sql') {
        Assert-Portfolio -Condition ($relativeRepositoryFile.StartsWith('examples/sql/')) `
            -Message "SQL fora do laboratorio demonstrativo: $relativeRepositoryFile"
    }
}

$htmlFiles = Get-ChildItem -LiteralPath (Join-Path $repositoryRoot 'docs') -Recurse -File -Filter '*.html'
foreach ($htmlFile in $htmlFiles) {
    $html = Get-Content -Raw -Encoding UTF8 -LiteralPath $htmlFile.FullName
    Assert-Portfolio -Condition ([regex]::IsMatch($html, '<html\s+lang="pt-BR"')) -Message "Idioma principal ausente em $($htmlFile.FullName)"
    Assert-Portfolio -Condition ([regex]::IsMatch($html, '<main\b[^>]*id="conteudo"')) -Message "Regiao principal ou alvo do salto ausente em $($htmlFile.FullName)"
    Assert-Portfolio -Condition ($html.Contains('class="skip-link"')) -Message "Link para saltar ao conteudo ausente em $($htmlFile.FullName)"
    Assert-Portfolio -Condition (-not [regex]::IsMatch($html, 'user-scalable\s*=\s*no|maximum-scale\s*=\s*1')) -Message "Zoom do navegador restringido em $($htmlFile.FullName)"

    $headings = [regex]::Matches($html, '<h([1-6])\b', 'IgnoreCase')
    Assert-Portfolio -Condition ((@($headings | Where-Object { $_.Groups[1].Value -eq '1' })).Count -eq 1) `
        -Message "Cada pagina deve possuir exatamente um h1: $($htmlFile.FullName)"
    for ($headingIndex = 1; $headingIndex -lt $headings.Count; $headingIndex++) {
        $previousLevel = [int] $headings[$headingIndex - 1].Groups[1].Value
        $currentLevel = [int] $headings[$headingIndex].Groups[1].Value
        Assert-Portfolio -Condition ($currentLevel -le $previousLevel + 1) `
            -Message "Salto na hierarquia de titulos em $($htmlFile.FullName): h$previousLevel para h$currentLevel"
    }

    $images = [regex]::Matches($html, '<img\b[^>]*>', 'IgnoreCase')
    foreach ($image in $images) {
        Assert-Portfolio -Condition ([regex]::IsMatch($image.Value, '\balt="[^"]*"', 'IgnoreCase')) `
            -Message "Imagem sem atributo alt em $($htmlFile.FullName)"
    }

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

Assert-Portfolio -Condition ($styles.Contains(':focus-visible')) -Message 'Indicador de foco visivel ausente.'
Assert-Portfolio -Condition ($styles.Contains('box-shadow: 0 0 0 6px #005fcc')) -Message 'Foco de alto contraste ausente.'
Assert-Portfolio -Condition ($styles.Contains('@media (prefers-reduced-motion: reduce)')) -Message 'Preferencia de movimento reduzido ausente.'
Assert-Portfolio -Condition ($mainScript.Contains("event.key === 'Escape'")) -Message 'Menu movel nao fecha por Escape.'
Assert-Portfolio -Condition ($mainScript.Contains("'Home', 'End'")) -Message 'Abas nao oferecem navegacao Home/End.'
Assert-Portfolio -Condition ($mainScript.Contains("setAttribute('tabindex'")) -Message 'Abas nao gerenciam foco por tabindex.'

$smallFontDeclarations = [regex]::Matches($styles + $examplesSite, 'font-size:\s*(\.[0-9]+)rem') |
    Where-Object { [double]::Parse(('0' + $_.Groups[1].Value), [Globalization.CultureInfo]::InvariantCulture) -lt 0.75 }
Assert-Portfolio -Condition ($smallFontDeclarations.Count -eq 0) -Message 'Foi encontrada fonte declarada abaixo de 0.75rem.'

$palette = @{}
[regex]::Matches($styles, '--([a-z0-9-]+):\s*(#[0-9a-f]{6})', 'IgnoreCase') | ForEach-Object {
    $palette[$_.Groups[1].Value] = $_.Groups[2].Value
}
Assert-Portfolio -Condition ((Get-ContrastRatio $palette['muted'] $palette['paper']) -ge 4.5) `
    -Message 'Contraste insuficiente entre texto secundario e fundo claro.'
Assert-Portfolio -Condition ((Get-ContrastRatio $palette['mint-dark'] $palette['paper']) -ge 4.5) `
    -Message 'Contraste insuficiente entre destaque verde e fundo claro.'

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
