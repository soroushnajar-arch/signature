# Signature - one-time setup for Windows.
# Downloads the four library files the splitter needs into .\lib
# Run once, from PowerShell in this folder:
#     powershell -ExecutionPolicy Bypass -File setup.ps1

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

$base   = "https://cdnjs.cloudflare.com/ajax/libs"
$pdfjs  = "3.11.174"
$jszip  = "3.10.1"
$pdflib = "1.17.1"

$files = @(
  @{ Url = "$base/pdf.js/$pdfjs/pdf.min.js";        Name = "pdf.min.js" },
  @{ Url = "$base/pdf.js/$pdfjs/pdf.worker.min.js"; Name = "pdf.worker.min.js" },
  @{ Url = "$base/jszip/$jszip/jszip.min.js";       Name = "jszip.min.js" },
  @{ Url = "$base/pdf-lib/$pdflib/pdf-lib.min.js";  Name = "pdf-lib.min.js" }
)

New-Item -ItemType Directory -Force -Path "lib" | Out-Null
Write-Host "Fetching libraries into .\lib"

foreach ($f in $files) {
  $out = Join-Path "lib" $f.Name
  if ((Test-Path $out) -and ((Get-Item $out).Length -gt 0)) {
    Write-Host "  already have  $($f.Name)"
    continue
  }
  Write-Host "  downloading   $($f.Name)"
  Invoke-WebRequest -Uri $f.Url -OutFile $out -UseBasicParsing
}

Write-Host ""
Write-Host "Checking sizes:"
$fail = $false
foreach ($f in $files) {
  $out = Join-Path "lib" $f.Name
  if (-not (Test-Path $out)) {
    Write-Host "  MISSING  $($f.Name)"; $fail = $true; continue
  }
  $bytes = (Get-Item $out).Length
  if ($bytes -lt 20000) {
    Write-Host "  TOO SMALL  $($f.Name)  ($bytes bytes - probably an error page, delete it and retry)"
    $fail = $true
  } else {
    Write-Host "  ok  $($f.Name)  ($bytes bytes)"
  }
}

if ($fail) {
  Write-Host ""
  Write-Host "Setup did not complete. Fix the files listed above and run this again."
  exit 1
}

Write-Host ""
Write-Host "Done. Now start a local server from this folder:"
Write-Host "    python -m http.server 8000"
Write-Host "and open  http://localhost:8000"
