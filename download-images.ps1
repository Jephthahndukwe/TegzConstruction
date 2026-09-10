<#
  download-images.ps1
  ------------------------------------------------------------------
  Downloads every remote image referenced by the Tegz website into
  the local .\images\ folder, giving each a descriptive filename.

  Usage:
    powershell -ExecutionPolicy Bypass -File .\download-images.ps1
    powershell -ExecutionPolicy Bypass -File .\download-images.ps1 -Force

  Without -Force, files that already exist are skipped so the script
  is safe to re-run.
#>
param([switch]$Force)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'   # much faster downloads on Windows PowerShell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$dest = Join-Path $PSScriptRoot 'images'
New-Item -ItemType Directory -Force -Path $dest | Out-Null

# name = local file written to .\images\ ;  url = source
$images = @(
  # --- Home (index.html) ---
  @{ name = 'hero-home.jpg';                     url = 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=1400&q=80' }
  @{ name = 'division-civil-works.jpg';          url = 'https://images.unsplash.com/photo-1685266326187-74cdcd9241fc?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDZ8fFB1YmxpYyUyMEluZnJhc3RydWN0dXJlJTIwaW4lMjBuaWdlcmlhfGVufDB8fDB8fHww' }
  @{ name = 'division-building-group.jpg';       url = 'https://images.unsplash.com/photo-1486325212027-8081e485255e?auto=format&fit=crop&w=800&q=80' }
  @{ name = 'home-about-site.jpg';               url = 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?auto=format&fit=crop&w=800&q=80' }

  # --- Shared project thumbnails (index.html / projects.html / services.html) ---
  @{ name = 'project-meridian-office-tower.jpg'; url = 'https://images.unsplash.com/photo-1779215528561-36d80bb046bf?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjZ8fE1lcmlkaWFuJTIwT2ZmaWNlJTIwVG93ZXJ8ZW58MHx8MHx8fDA%3D' }
  @{ name = 'project-sapele-road-estate.jpg';    url = 'https://images.unsplash.com/photo-1752622176337-5d9315e2df6e?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8RXN0YXRlJTIwUm9hZCUyMGluJTIwbGFnb3N8ZW58MHx8MHx8fDA%3D' }
  @{ name = 'project-edo-bridge-rehab.jpg';      url = 'https://images.unsplash.com/photo-1719314073622-9399d167725b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fEJyaWRnZSUyMFJlaGFiJTIwaW4lMjBsYWdvc3xlbnwwfHwwfHx8MA%3D%3D' }

  # --- About (about.html) ---
  @{ name = 'about-team-at-work.jpg';            url = 'https://plus.unsplash.com/premium_photo-1750888399213-f8dce4088116?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGNpdmlsJTIwZW5naW5lZXJpbmclMjBpbiUyMG5pZ2VyaWF8ZW58MHx8MHx8fDA%3D' }
  @{ name = 'team-tega-ogbebor.jpg';             url = 'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=600&q=80' }
  @{ name = 'team-everestus-ndukwe.jpg';         url = 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=600&q=80' }
  @{ name = 'team-head-civil-works.jpg';         url = 'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?auto=format&fit=crop&w=600&q=80' }
  @{ name = 'team-head-building-group.jpg';      url = 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=600&q=80' }
  @{ name = 'team-hse-manager.jpg';              url = 'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=600&q=80' }
  @{ name = 'team-mep-manager.jpg';              url = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=600&q=80' }
  @{ name = 'team-lead-architect.jpg';           url = 'https://images.unsplash.com/photo-1598550874175-4d0ef436c909?auto=format&fit=crop&w=600&q=80' }
  @{ name = 'team-project-controls.jpg';         url = 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=600&q=80' }

  # --- Services (services.html) ---
  @{ name = 'service-highways-roads.jpg';        url = 'https://images.unsplash.com/photo-1494976388531-d1058494782d?auto=format&fit=crop&w=900&q=80' }
  @{ name = 'service-commercial-building.jpg';   url = 'https://images.unsplash.com/photo-1633605962190-b2ee3986097c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjJ8fEhvc3BpdGFsaXR5JTIwJTI2JTIwQ29tbWVyY2lhbCUyMGluJTIwbGFnb3N8ZW58MHx8MHx8fDA%3D' }
  @{ name = 'service-education-healthcare.jpg';  url = 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=900&q=80' }
  @{ name = 'service-residential-construction.jpg'; url = 'https://images.unsplash.com/photo-1704513815318-b8a233c41955?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fFJlc2lkZW50aWFsJTIwQ29uc3RydWN0aW9uJTIwaW4lMjBsYWdvc3xlbnwwfHwwfHx8MA%3D%3D' }
  @{ name = 'service-piling-excavation.jpg';     url = 'https://images.unsplash.com/photo-1652303713917-2666b8bee507?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8UGlsaW5nJTIwJTI2JTIwRXhjYXZhdGlvbnxlbnwwfHwwfHx8MA%3D%3D' }

  # --- Projects grid (projects.html) ---
  @{ name = 'project-gra-housing-estate.jpg';    url = 'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?auto=format&fit=crop&w=800&q=80' }
  @{ name = 'project-benin-commercial-plaza.jpg'; url = 'https://images.unsplash.com/photo-1519501025264-65ba15a82390?auto=format&fit=crop&w=800&q=80' }
  @{ name = 'project-premier-hotel.jpg';         url = 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80' }
  @{ name = 'project-delta-state-road-works.jpg'; url = 'https://images.unsplash.com/photo-1503174971373-b1f69850bded?auto=format&fit=crop&w=800&q=80' }
  @{ name = 'project-edo-state-hospital.jpg';    url = 'https://images.unsplash.com/photo-1538108149393-fbbd81895907?auto=format&fit=crop&w=800&q=80' }
  @{ name = 'project-luxury-villa-development.jpg'; url = 'https://images.unsplash.com/photo-1613977257363-707ba9348227?auto=format&fit=crop&w=800&q=80' }
  @{ name = 'project-warehouse-distribution.jpg'; url = 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=800&q=80' }
  @{ name = 'project-sapele-road-apartments.jpg'; url = 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80' }
)

$ok = 0; $skip = 0; $fail = 0
foreach ($img in $images) {
  $out = Join-Path $dest $img.name
  if ((Test-Path $out) -and -not $Force) {
    Write-Host ("skip   {0}  (already exists)" -f $img.name) -ForegroundColor DarkGray
    $skip++
    continue
  }
  try {
    Invoke-WebRequest -Uri $img.url -OutFile $out -UseBasicParsing -TimeoutSec 60
    $kb = [math]::Round((Get-Item $out).Length / 1KB)
    Write-Host ("ok     {0}  ({1} KB)" -f $img.name, $kb) -ForegroundColor Green
    $ok++
  } catch {
    if (Test-Path $out) { Remove-Item $out -Force }
    Write-Host ("FAIL   {0}" -f $img.name) -ForegroundColor Red
    Write-Host ("       {0}" -f $img.url) -ForegroundColor DarkRed
    Write-Host ("       {0}" -f $_.Exception.Message) -ForegroundColor DarkRed
    $fail++
  }
}

Write-Host ""
Write-Host ("Done.  downloaded={0}  skipped={1}  failed={2}" -f $ok, $skip, $fail) -ForegroundColor Cyan
Write-Host ("Folder: {0}" -f $dest) -ForegroundColor Cyan
if ($fail -gt 0) { exit 1 }
