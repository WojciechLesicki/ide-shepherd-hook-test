@echo off
echo "[MOCK MALWARE] This could be something malicious running on Windows!"
powershell -Command "Get-Process | Select-Object -First 5"
exit /b 0
