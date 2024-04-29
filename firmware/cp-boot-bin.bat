@echo off
REM wmic logicaldisk where "drivetype=2 and size>0" get deviceid | %WINDIR%\System32\find.exe /v "DeviceID"

for /f "skip=2 tokens=2 delims=," %%a in ('wmic logicaldisk where "drivetype=2 and size>0" get deviceid /format:csv') do (
    echo copy vitis\hdmi_overlay_app_system\_ide\bootimage\BOOT.bin %%a
    copy vitis\hdmi_overlay_app_system\_ide\bootimage\BOOT.bin %%a
)
