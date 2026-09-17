[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$failures = [System.Collections.Generic.List[string]]::new()

function Assert-Portfolio {
    param(
        [Parameter(Mandatory)]
        [bool] $Condition,

        [Parameter(Mandatory)]
        [string] $Message
    )

    if (-not $Condition) {
        $script:failures.Add($Message)
    }
}

$requiredPaths = @(
    'README.md',
    'LICENSE',
    '.gitignore',
    'docs/index.html',
    'docs/assets/favicon.svg',
    'docs/assets/styles.css',
    'docs/assets/main.js',
    'docs/arquitetura/README.md',
    'docs/diagramas/componentes.md',
    'docs/screenshots/README.md',
    'examples/controllers/IndicadorController.php',
    'examples/models/IndicadorAcademico.php',
    'examples/services/ConsolidaIndicadoresService.php',
    'examples/sql/resumo_avaliacoes.sql',
    'examples/views/painel-indicadores.blade.php'
)

foreach ($relativePath in $requiredPaths) {
    $fullPath = Join-Path $repositoryRoot $relativePath
    Assert-Portfolio -Condition (Test-Path -LiteralPath $fullPath) -Message "Arquivo obrigatório ausente: $relativePath"
}

$readme = Get-Content -Raw -LiteralPath (Join-Path $repositoryRoot 'README.md')
$site = Get-Content -Raw -LiteralPath (Join-Path $repositoryRoot 'docs/index.html')
$requiredTerms = @(
    'Laravel', 'PHP', 'MySQL', 'Redis', 'Bootstrap', 'Nginx', 'Git', 'MicroStrategy',
    'Calendário de Avaliações', 'Índice de Dificuldades', 'Relatórios', 'TFM',
    'Lança Local', 'Conteúdos Atitudinais'
)

foreach ($term in $requiredTerms) {
    Assert-Portfolio -Condition ($readme.Contains($term) -and $site.Contains($term)) -Message "Termo obrigatório ausente no README ou no site: $term"
}

$textExtensions = @('.md', '.html', '.css', '.js', '.php', '.sql', '.txt')
$publicFiles = Get-ChildItem -LiteralPath $repositoryRoot -Recurse -File |
    Where-Object {
        $_.FullName -notlike "*\.git\*" -and
        $_.FullName -notlike "*\tests\*" -and
        $textExtensions -contains $_.Extension
    }

$forbiddenPatterns = @(
    '(?i)(password|passwd|senha|token|secret|api[_-]?key)\s*[:=]\s*["''][^"'']+["'']',
    '(?<!\d)(10\.\d{1,3}\.\d{1,3}\.\d{1,3}|192\.168\.\d{1,3}\.\d{1,3}|172\.(1[6-9]|2\d|3[01])\.\d{1,3}\.\d{1,3})(?!\d)',
    '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
)

foreach ($file in $publicFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName
    foreach ($pattern in $forbiddenPatterns) {
        Assert-Portfolio -Condition (-not [regex]::IsMatch($content, $pattern)) -Message "Possível segredo ou endereço privado em $($file.FullName)"
    }
}

$hrefMatches = [regex]::Matches($site, 'href="([^"]+)"')
foreach ($match in $hrefMatches) {
    $href = $match.Groups[1].Value
    if ($href.StartsWith('#') -or $href.StartsWith('http://') -or $href.StartsWith('https://') -or $href.StartsWith('mailto:')) {
        continue
    }

    $withoutFragment = $href.Split('#')[0]
    $target = [System.IO.Path]::GetFullPath((Join-Path (Join-Path $repositoryRoot 'docs') $withoutFragment))
    Assert-Portfolio -Condition (Test-Path -LiteralPath $target) -Message "Link local inválido em docs/index.html: $href"
}

$nestedRepositories = Get-ChildItem -LiteralPath $repositoryRoot -Recurse -Directory -Force -Filter '.git' |
    Where-Object { $_.FullName -ne (Join-Path $repositoryRoot '.git') }
Assert-Portfolio -Condition ($nestedRepositories.Count -eq 0) -Message 'Foi encontrado um histórico Git aninhado.'

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Validação concluída: $($requiredPaths.Count) arquivos, $($requiredTerms.Count) termos e $($publicFiles.Count) arquivos públicos verificados."
