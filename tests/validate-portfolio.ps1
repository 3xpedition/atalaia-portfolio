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
    'docs/examples/index.html',
    'docs/assets/favicon.svg',
    'docs/assets/styles.css',
    'docs/assets/examples-1d3a47a.css',
    'docs/assets/portfolio-team-725b14c.css',
    'docs/assets/logo-esa.svg',
    'docs/assets/team/joao-victor.jpg',
    'docs/assets/team/alexandre-ferreira.jpg',
    'docs/assets/team/natanael-cirino.jpg',
    'docs/assets/team/diego-fernandes.jpg',
    'docs/assets/team/abner.jpg',
    'docs/assets/gaviao/visao-geral.gif',
    'docs/assets/gaviao/apresentacao.mp4',
    'docs/assets/gaviao/hero-modo-navegacao.jpg',
    'docs/assets/gaviao/apresentacao-poster.jpg',
    'docs/assets/gaviao/login-gaviao.jpg',
    'docs/assets/gaviao/login-atalaia.jpg',
    'docs/assets/mobile/app-login.jpg',
    'docs/assets/mobile/app-consulta-fo.jpg',
    'docs/assets/main.js',
    'docs/assets/atividade.js',
    'docs/assets/atividade-mapa.js',
    'tools/gerar-atividade.ps1',
    'docs/arquitetura/README.md',
    'docs/diagramas/componentes.md',
    'docs/mobile/README.md',
    'docs/screenshots/README.md',
    'examples/README.md',
    'examples/controllers/PainelDesempenhoController.php',
    'examples/services/FaixaDesempenhoService.php',
    'examples/services/EscolhaQmsService.php',
    'examples/views/painel-faixas.blade.php',
    'examples/sql/efetivo_evasao_ciclo.sql',
    'examples/js/quebras-naturais.js',
    'examples/android/EnvioFoWorker.kt'
)

foreach ($relativePath in $requiredPaths) {
    $fullPath = Join-Path $repositoryRoot $relativePath
    Assert-Portfolio -Condition (Test-Path -LiteralPath $fullPath) -Message "Arquivo obrigatório ausente: $relativePath"
}

$readme = Get-Content -Raw -LiteralPath (Join-Path $repositoryRoot 'README.md')
$site = Get-Content -Raw -LiteralPath (Join-Path $repositoryRoot 'docs/index.html')
$examplesSite = Get-Content -Raw -LiteralPath (Join-Path $repositoryRoot 'docs/examples/index.html')
$requiredTerms = @(
    'Laravel', 'PHP', 'MySQL', 'Docker', 'Bootstrap', 'Nginx', 'Git', 'D3.js',
    'Kotlin', 'Jetpack Compose', 'WorkManager', 'SQLCipher',
    'Ciclo de Formação', 'Avaliação &amp; Desempenho', 'Inteligência Educacional',
    'Jornada Disciplinar', 'Escolha de QMS', 'Operação Móvel Offline'
)

foreach ($term in $requiredTerms) {
    $readmeTerm = $term.Replace('&amp;', '&')
    Assert-Portfolio -Condition ($readme.Contains($readmeTerm) -and $site.Contains($term)) -Message "Termo obrigatório ausente no README ou no site: $readmeTerm"
}

$historyTerms = @('Histórico e evolução', '2020', '2021', '2022', '2023–2024', '2025', '2026', 'Mapa de atividade')
foreach ($term in $historyTerms) {
    Assert-Portfolio -Condition ($readme.Contains($term)) -Message "Marco histórico ausente no README: $term"
}

foreach ($script in @('assets/atividade.js', 'assets/atividade-mapa.js')) {
    Assert-Portfolio -Condition ($site.Contains("<script src=`"$script`" defer></script>")) -Message "Script do mapa de atividade ausente no site: $script"
}
Assert-Portfolio -Condition ($site.Contains('id="evolucao"') -and $site.Contains('data-activity-map')) -Message 'Seção do mapa de atividade ausente no site.'

# O mapa promete publicar só contagens por semana: nada de nomes, e-mails, mensagens ou hashes.
$activity = Get-Content -Raw -LiteralPath (Join-Path $repositoryRoot 'docs/assets/atividade.js')
$activityPattern = '^// [^\r\n]*\r?\nwindow\.ATALAIA_ATIVIDADE = \{\r?\n  "geradoEm": "\d{4}-\d{2}-\d{2}",\r?\n  "inicio": "\d{4}-\d{2}-\d{2}",\r?\n  "inicioCop": "\d{4}-\d{2}-\d{2}",\r?\n  "semanas": \{\r?\n(    "\d{4}-\d{2}-\d{2}": \[\d+, \d+\],?\r?\n)+  \}\r?\n\};\r?\n?$'
Assert-Portfolio -Condition ([regex]::IsMatch($activity, $activityPattern)) -Message 'docs/assets/atividade.js tem conteúdo além das contagens por semana.'

Assert-Portfolio -Condition (-not $site.Contains('href="../examples/"')) -Message 'O link antigo dos exemplos ainda aponta para fora do projeto do GitHub Pages.'
Assert-Portfolio -Condition ($examplesSite.Contains('Todos os exemplos são autorais e sanitizados, escritos a partir das regras reais do sistema.')) -Message 'Aviso de sanitização ausente na página de exemplos.'
Assert-Portfolio -Condition ($examplesSite.Contains('Exemplos técnicos, sem ruído.')) -Message 'Título principal da página de exemplos ausente.'
Assert-Portfolio -Condition ($site.Contains('Uma equipe multidisciplinar por trás da evolução.')) -Message 'Seção pública da equipe ausente.'

$legacyModuleHeadings = @(
    'Calendário de Avaliações',
    'Índice de Dificuldades',
    'Relatórios',
    'TFM',
    'Lança Local',
    'Conteúdos Atitudinais'
)

foreach ($heading in $legacyModuleHeadings) {
    Assert-Portfolio -Condition (-not $site.Contains("<h3>$heading</h3>")) -Message "Card de módulo legado ainda presente: $heading"
}

$textExtensions = @('.md', '.html', '.css', '.js', '.php', '.sql', '.txt', '.kt')
# Pastas locais de ferramentas de agentes (ignoradas no .gitignore): não são publicadas.
$localToolFolders = @('.agent', '.agents', '.claude', '.codex', '.gemini') |
    ForEach-Object { Join-Path $repositoryRoot $_ }
$publicFiles = Get-ChildItem -LiteralPath $repositoryRoot -Recurse -File |
    Where-Object {
        $file = $_
        $file.FullName -notlike "*\.git\*" -and
        $file.FullName -notlike "*\tests\*" -and
        -not ($localToolFolders | Where-Object { $file.FullName.StartsWith("$_\") }) -and
        $textExtensions -contains $file.Extension
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

$htmlFiles = Get-ChildItem -LiteralPath (Join-Path $repositoryRoot 'docs') -Recurse -File -Filter '*.html'
foreach ($htmlFile in $htmlFiles) {
    $html = Get-Content -Raw -LiteralPath $htmlFile.FullName
    $hrefMatches = [regex]::Matches($html, 'href="([^"]+)"')
    foreach ($match in $hrefMatches) {
        $href = $match.Groups[1].Value
        if ($href.StartsWith('#') -or $href.StartsWith('http://') -or $href.StartsWith('https://') -or $href.StartsWith('mailto:')) {
            continue
        }

        $withoutFragment = $href.Split('#')[0]
        $withoutQuery = $withoutFragment.Split('?')[0]
        $target = [System.IO.Path]::GetFullPath((Join-Path $htmlFile.DirectoryName $withoutQuery))
        Assert-Portfolio -Condition (Test-Path -LiteralPath $target) -Message "Link local inválido em $($htmlFile.FullName): $href"
    }
}

$nestedRepositories = Get-ChildItem -LiteralPath $repositoryRoot -Recurse -Directory -Force -Filter '.git' |
    Where-Object { $_.FullName -ne (Join-Path $repositoryRoot '.git') }
Assert-Portfolio -Condition ($nestedRepositories.Count -eq 0) -Message 'Foi encontrado um histórico Git aninhado.'

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Validação concluída: $($requiredPaths.Count) arquivos, $($requiredTerms.Count) termos e $($publicFiles.Count) arquivos públicos verificados."
