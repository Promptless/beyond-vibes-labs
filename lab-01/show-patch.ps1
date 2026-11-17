# Runs show-patch.sh through Git Bash, for Windows users working in PowerShell.
# Takes the same arguments as show-patch.sh; see show-patch.sh --help.
# All the logic lives in show-patch.sh.

$ErrorActionPreference = 'Stop'

$git = Get-Command git -ErrorAction SilentlyContinue
if (-not $git) {
    Write-Error 'Git is required. Install Git for Windows from https://git-scm.com/download/win, then try again.'
    exit 1
}

# Git for Windows ships bash.exe in <install>\bin. Find the install from git.exe
# or from git --exec-path (<install>\mingw64\libexec\git-core).
$roots = @(
    (Split-Path (Split-Path $git.Source -Parent) -Parent),
    (Resolve-Path (Join-Path (& git --exec-path) '..\..\..') -ErrorAction SilentlyContinue)
)
$bash = $null
foreach ($root in $roots) {
    if (-not $root) { continue }
    foreach ($candidate in @('bin\bash.exe', 'usr\bin\bash.exe')) {
        $path = Join-Path $root $candidate
        if (Test-Path $path) { $bash = $path; break }
    }
    if ($bash) { break }
}
if (-not $bash) {
    Write-Error "Couldn't find Git Bash next to $($git.Source). Open Git Bash and run lab-01/show-patch.sh instead."
    exit 1
}

$script = (Join-Path $PSScriptRoot 'show-patch.sh') -replace '\\', '/'
& $bash $script @args
exit $LASTEXITCODE
