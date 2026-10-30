@echo off
setlocal
set PORT=8765
cd /d "%~dp0"

where python >nul 2>nul
if %errorlevel%==0 (
  start "OCR-Server" cmd /k "python -m http.server %PORT% --bind 127.0.0.1"
  goto OPEN
)
where python3 >nul 2>nul
if %errorlevel%==0 (
  start "OCR-Server" cmd /k "python3 -m http.server %PORT% --bind 127.0.0.1"
  goto OPEN
)
where node >nul 2>nul
if %errorlevel%==0 (
  start "OCR-Server" cmd /k "npx --yes serve -l %PORT% ."
  goto OPEN
)

echo ERROR: Python or Node.js not found.
echo Install Python, then run:  python -m http.server 8765
echo Then open in browser:  http://127.0.0.1:8765/index.html
pause
goto :eof

:OPEN
timeout /t 2 >nul
start http://127.0.0.1:%PORT%/index.html
