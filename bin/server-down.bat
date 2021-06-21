@echo off

if not exist %~dp0..\helper_scripts\vm.txt (
	echo VM configuration missing
	exit /B
)
set /p vm=<%~dp0..\helper_scripts\vm.txt
"c:\Program Files\Oracle\VirtualBox\vboxmanage" controlvm %vm% acpipowerbutton