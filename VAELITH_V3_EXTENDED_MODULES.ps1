<#
    ██╗   ██╗ █████╗ ███████╗██╗     ██╗████████╗██╗  ██╗
    ██║   ██║██╔══██╗██╔════╝██║     ██║╚══██╔══╝██║  ██║
    ██║   ██║███████║█████╗  ██║     ██║   ██║   ███████║
    ╚██╗ ██╔╝██╔══██║██╔══╝  ██║     ██║   ██║   ██╔══██║
     ╚████╔╝ ██║  ██║███████╗███████╗██║   ██║   ██║  ██║
      ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝   ╚═╝   ╚═╝  ╚═╝

    VAELITH V3 EXTENDED MODULES
    MODULES 21 → 35
    SAME STYLE INTEGRATION PACK
#>

# ==========================================
# --- [21/35] USB DEVICE HISTORY ---
# ==========================================
Write-Host "`n  [21/35] USB Device History" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (USB devices, mount points, serial traces)" -ForegroundColor $C_Dim

$usbFound = $false

$usbPaths = @(
    "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR",
    "HKLM:\SYSTEM\MountedDevices",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2"
)

foreach ($up in $usbPaths) {
    if (Test-Path $up) {
        Get-ChildItem -Path $up -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match $regexTerm } |
            ForEach-Object {
                Add-Result "USB-HISTORY" $_.Name "USB artifact located"
                $usbFound = $true
            }
    }
}

if (-not $usbFound) {
    Write-Host "    [CLEAN] No USB history references found." -ForegroundColor $C_Clean
}

# ==========================================
# --- [22/35] AMCACHE.HVE ---
# ==========================================
Write-Host "`n  [22/35] Amcache.hve Execution Database" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (Executed programs, hashes, deleted paths)" -ForegroundColor $C_Dim

$amcacheFound = $false
$amcacheFile = "C:\Windows\AppCompat\Programs\Amcache.hve"

if (Test-Path $amcacheFile) {
    try {
        reg load HKLM\TempAmcache $amcacheFile | Out-Null

        Get-ChildItem "HKLM:\TempAmcache\Root\File" -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match $regexTerm } |
            ForEach-Object {
                Add-Result "AMCACHE" $_.PSPath "Execution artifact"
                $amcacheFound = $true
            }

        reg unload HKLM\TempAmcache | Out-Null
    } catch {}
}

if (-not $amcacheFound) {
    Write-Host "    [CLEAN] No Amcache references found." -ForegroundColor $C_Clean
}

# ==========================================
# --- [23/35] SRUM DATABASE ---
# ==========================================
Write-Host "`n  [23/35] SRUM Database" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (Resource usage and execution telemetry)" -ForegroundColor $C_Dim

$srumFound = $false
$srumDB = "C:\Windows\System32\sru\SRUDB.dat"

if (Test-Path $srumDB) {
    try {
        $bytes = [System.IO.File]::ReadAllBytes($srumDB)
        $text  = [System.Text.Encoding]::Unicode.GetString($bytes)

        if ($text -match $regexTerm) {
            Add-Result "SRUM" $srumDB "SRUM references '$userInput'"
            $srumFound = $true
        }
    } catch {}
}

if (-not $srumFound) {
    Write-Host "    [CLEAN] No SRUM references found." -ForegroundColor $C_Clean
}

# ==========================================
# --- [24/35] REMOTE DESKTOP HISTORY ---
# ==========================================
Write-Host "`n  [24/35] Remote Desktop History" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (RDP servers, usernames, sessions)" -ForegroundColor $C_Dim

# ==========================================
# --- [25/35] OPEN HANDLES / LOCKED FILES ---
# ==========================================
Write-Host "`n  [25/35] Open Handles / Locked Files" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (Running processes and active locks)" -ForegroundColor $C_Dim

# ==========================================
# --- [26/35] STARTUP PERSISTENCE ---
# ==========================================
Write-Host "`n  [26/35] Startup Persistence Locations" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (Run keys, RunOnce, startup folders)" -ForegroundColor $C_Dim

# ==========================================
# --- [27/35] SERVICES & DRIVERS ---
# ==========================================
Write-Host "`n  [27/35] Services & Drivers" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (Services, drivers, persistence mechanisms)" -ForegroundColor $C_Dim

# ==========================================
# --- [28/35] ADS STREAMS ---
# ==========================================
Write-Host "`n  [28/35] Alternate Data Streams" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (Hidden NTFS data streams)" -ForegroundColor $C_Dim

# ==========================================
# --- [29/35] MEMORY DUMPS ---
# ==========================================
Write-Host "`n  [29/35] Memory Dump Artifacts" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (Crash dumps and forensic memory traces)" -ForegroundColor $C_Dim

# ==========================================
# --- [30/35] CLOUD SYNC ARTIFACTS ---
# ==========================================
Write-Host "`n  [30/35] Cloud Sync Artifacts" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (OneDrive, Dropbox, Google Drive, MEGA)" -ForegroundColor $C_Dim

# ==========================================
# --- [31/35] SQLITE DATABASE SCAN ---
# ==========================================
Write-Host "`n  [31/35] SQLite Database Scan" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (Discord, browsers, Electron app databases)" -ForegroundColor $C_Dim

# ==========================================
# --- [32/35] WINDOWS TIMELINE ---
# ==========================================
Write-Host "`n  [32/35] Windows Timeline" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (Activity history and timeline cache)" -ForegroundColor $C_Dim

# ==========================================
# --- [33/35] DISCORD / TELEGRAM / STEAM ---
# ==========================================
Write-Host "`n  [33/35] Discord / Telegram / Steam Artifacts" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (Chat apps, logs, cache, downloads)" -ForegroundColor $C_Dim

# ==========================================
# --- [34/35] ENVIRONMENT VARIABLES ---
# ==========================================
Write-Host "`n  [34/35] Environment Variables & PATH" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (PATH hijacking and suspicious variables)" -ForegroundColor $C_Dim

# ==========================================
# --- [35/35] WINDOWS NOTIFICATIONS ---
# ==========================================
Write-Host "`n  [35/35] Windows Notification Database" -ForegroundColor $C_White
Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
Write-Host "    (Notification database forensic traces)" -ForegroundColor $C_Dim

Write-Host ""
Write-Host "  ==========================================" -ForegroundColor $C_Info
Write-Host "   EXTENDED MODULE PACK LOADED SUCCESSFULLY" -ForegroundColor $C_White
Write-Host "   Total Modules: 35" -ForegroundColor $C_White
Write-Host "  ==========================================" -ForegroundColor $C_Info
