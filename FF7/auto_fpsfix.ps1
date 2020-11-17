# Please change to your FPSFIX path.
$FPSFIX_path = 'C:\FPSFIX\FPSFIX.exe'

$sleep_seconds = 5

$FF7_process = "ff7_en"
$FF7_Launcher_process = "FF7_Launcher"
$FPSFIX_process = "FPSFIX"

while ($true) {
  $FF7_Launcher_alive = Get-Process $FF7_Launcher_process -ErrorAction SilentlyContinue
  if ($FF7_Launcher_alive) {
    try {
      $p = Get-Process $FF7_process -ErrorAction SilentlyContinue
      $p.WaitForExit()
    } catch {
      Write-Host "No $FF7_process Process"
      $FPSFIX_alive = Get-Process $FPSFIX_process -ErrorAction SilentlyContinue
      If (!$FPSFIX_alive) {
        Write-Host "No $FPSFIX_process Process; Start $FPSFIX_path"
        Invoke-Item $FPSFIX_path
      }
    } finally {
      try {
        $p = Get-Process $FPSFIX_process -ErrorAction SilentlyContinue
        $p.WaitForExit()
      } catch {
        Write-Host "No $FPSFIX_process Process"
      }
    }
  } else {
    Write-Host "No $FF7_Launcher_process Process; Sleep $sleep_seconds seconds..."
    Sleep $sleep_seconds
  }
}
