<#
.SYNOPSIS
    Gera docs/assets/atividade.js com os commits por semana do repositório privado.

.DESCRIPTION
    Lê o histórico (sem merges) do repositório informado e agrega os commits por
    semana, separando a equipe atual dos demais contribuidores. O arquivo gerado
    contém apenas datas e contagens: nenhum nome, e-mail, mensagem ou hash.

    A semana começa na segunda-feira e é cortada na virada do ano, para que o
    total de cada faixa bata com o ano civil.

.EXAMPLE
    .\tools\gerar-atividade.ps1 -Repositorio 'C:\laragon\www\atalaia' -Equipe 'natanael','alexandre','jo.o'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $Repositorio,

    # Regex aplicadas em "Nome <email>" (sem diferenciar maiúsculas).
    [Parameter(Mandatory)]
    [string[]] $Equipe,

    # Autores que não entram na contagem (bots).
    [string[]] $Ignorar = @('\[bot\]'),

    [string] $Desde = '2020-01-01',

    # O corte "antes/depois do COP" é a primeira segunda-feira a partir desta data.
    [string] $InicioCop = '2026-03-01',

    # Padrão: docs/assets/atividade.js do portfólio.
    [string] $Saida
)

$ErrorActionPreference = 'Stop'
if (-not $Saida) { $Saida = Join-Path (Split-Path -Parent $PSScriptRoot) 'docs/assets/atividade.js' }
$cultura = [System.Globalization.CultureInfo]::InvariantCulture
# Com -File o PowerShell entrega 'a','b' como uma string só; aceita os padrões separados por vírgula.
$Equipe = $Equipe -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
$Ignorar = $Ignorar -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }

function Get-InicioSemana {
    param([datetime] $Data)

    $segunda = $Data.AddDays(-(([int] $Data.DayOfWeek + 6) % 7))
    $inicioAno = [datetime]::new($Data.Year, 1, 1)
    if ($segunda -lt $inicioAno) { return $inicioAno }
    return $segunda
}

$codificacaoAnterior = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
try {
    $linhas = & git -C $Repositorio log --all --no-merges "--since=$Desde" '--date=short' '--format=%ad%x09%an <%ae>'
    if ($LASTEXITCODE -ne 0) { throw "git log falhou em $Repositorio" }
}
finally {
    [Console]::OutputEncoding = $codificacaoAnterior
}

$semanas = @{}
$autores = @{}
$inicio = [datetime]::ParseExact($Desde, 'yyyy-MM-dd', $cultura)

foreach ($linha in $linhas) {
    $data, $autor = $linha -split "`t", 2
    if ($Ignorar | Where-Object { $autor -match $_ }) { $grupo = 'ignorado' }
    elseif ($Equipe | Where-Object { $autor -match $_ }) { $grupo = 'equipe' }
    else { $grupo = 'demais' }

    if (-not $autores.ContainsKey($autor)) { $autores[$autor] = [pscustomobject] @{ Autor = $autor; Grupo = $grupo; Commits = 0 } }
    $autores[$autor].Commits++
    if ($grupo -eq 'ignorado') { continue }

    $dia = [datetime]::ParseExact($data, 'yyyy-MM-dd', $cultura)
    if ($dia -lt $inicio) { continue }
    $chave = (Get-InicioSemana $dia).ToString('yyyy-MM-dd', $cultura)
    if (-not $semanas.ContainsKey($chave)) { $semanas[$chave] = @(0, 0) }
    $semanas[$chave][[int] ($grupo -eq 'demais')]++
}

$autores.Values | Sort-Object Grupo, @{ Expression = 'Commits'; Descending = $true } |
    Format-Table Grupo, Commits, Autor -AutoSize | Out-String | Write-Host

$cop = [datetime]::ParseExact($InicioCop, 'yyyy-MM-dd', $cultura)
while ($cop.DayOfWeek -ne [DayOfWeek]::Monday) { $cop = $cop.AddDays(1) }

$entradas = $semanas.Keys | Sort-Object | ForEach-Object { "    `"$_`": [$($semanas[$_][0]), $($semanas[$_][1])]" }
$conteudo = @(
    '// Gerado por tools/gerar-atividade.ps1. Só contagens de commits por semana: [equipe atual, demais].'
    'window.ATALAIA_ATIVIDADE = {'
    "  `"geradoEm`": `"$((Get-Date).ToString('yyyy-MM-dd', $cultura))`","
    "  `"inicio`": `"$($inicio.ToString('yyyy-MM-dd', $cultura))`","
    "  `"inicioCop`": `"$($cop.ToString('yyyy-MM-dd', $cultura))`","
    '  "semanas": {'
    ($entradas -join ",`n")
    '  }'
    '};'
    ''
) -join "`n"

[System.IO.File]::WriteAllText($Saida, $conteudo, [System.Text.UTF8Encoding]::new($false))

$totais = $semanas.Values | ForEach-Object { $_[0] + $_[1] } | Measure-Object -Sum
Write-Host "Gerado $Saida com $($semanas.Count) semanas e $($totais.Sum) commits (corte do COP em $($cop.ToString('yyyy-MM-dd', $cultura)))."
