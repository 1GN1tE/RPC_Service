@echo off

echo [+] Checking prerequisites

where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
	echo - Python wasn't found. Install and add it to path
	goto fail
)
echo    + Python Found

where ssh >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
	echo - ssh wasn't found
	goto fail
)
echo    + ssh Found

if not exist "C:\Program Files\Oracle\VirtualBox" (
	echo - Virtualbox wasn't found at 'C:\Program Files\Oracle\VirtualBox'
	goto fail
)
echo    + VirtualBox Found

if not exist "C:\Program Files\VcxSrv\" (
	echo - VcxSrv wasn't found at 'C:\Program Files\VcxSrv\'
	goto fail
)
echo    + VcxSrv Found

echo [+] VM settings
echo List of VMs
"C:\Program Files\Oracle\VirtualBox\vboxmanage" list vms

:inp_vm
echo;
set VM = asdf
set /p VM=Enter VM name: 

rem Check if VM exists
"C:\Program Files\Oracle\VirtualBox\vboxmanage" showvminfo %VM% >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
	echo - %VM% wasn't found
	goto inp_vm
)

echo %VM% > %~dp0helper_scripts\vm.txt

echo [+] User settings
set usrnme = name
set /p usrnme="Enter VM username: "

echo IPs of VM are:
"C:\Program Files\Oracle\VirtualBox\vboxmanage" guestproperty get %VM% "/VirtualBox/GuestInfo/Net/1/V4/IP"
"C:\Program Files\Oracle\VirtualBox\vboxmanage" guestproperty get %VM% "/VirtualBox/GuestInfo/Net/0/V4/IP"
set ip = 192.168.56.101
set /p ip="Enter full IP u want to use: "

set shell=bash
set /p shell="Enter name of shell u want to use (E.g. bash): "

set term=gnome-terminal
set /p term="Enter name of terminal u want to use (E.g. tilix): "

echo %usrnme% > %~dp0helper_scripts\config.txt
echo %ip% >> %~dp0helper_scripts\config.txt
echo %shell% >> %~dp0helper_scripts\config.txt
echo %term% >> %~dp0helper_scripts\config.txt

echo [+] Adding permissions

for /F "skip=2 tokens=1,2*" %%N in ('%SystemRoot%\System32\reg.exe query "HKCU\Environment" /v "Path" 2^>nul') do if /I "%%N" == "Path" call set "UserPath=%%P" & goto pathrd
echo [-] There is no user PATH defined.
goto fail

:pathrd
setx path "%UserPath%;%~dp0bin"

FOR /F "tokens=*" %%g IN ('where pythonw') do (SET py_path=%%g)
%SystemRoot%\System32\reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\linux-interface" /t REG_SZ /d "Open Linux Interface Here"
%SystemRoot%\System32\reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\linux-interface" /v Icon /t REG_SZ /d "%~dp0helper_scripts\icon.ico"
%SystemRoot%\System32\reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\linux-interface\command" /t REG_SZ /d "%py_path% %~dp0helper_scripts\open_shell.py"


:success
echo [+] Installation Successful
exit /B

:fail
echo [-] Installation Failed
exit /B