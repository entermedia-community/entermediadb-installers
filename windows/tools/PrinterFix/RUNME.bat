REM Script by helgesverre.com
@ECHO OFF

echo ####################################
echo #           Helge Sverre           #
echo #         Printer AutoFixer        #
echo ####################################


echo THIS SCRIPT MUST BE RUN WITH ADMIN RIGHTS...

REM Delete all the subkeys.
echo * Deleting Registry Keys
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Drivers" /va /f

REM stop the print spooler.
echo * Stopping Printer Spooler
net stop spooler

REM delete printers and driver files.
echo * Removing Printer Files
IObitUnlocker.exe /Delete /Advanced C:\Windows\System32\spool\PRINTERS

echo * Removing Driver Files
IObitUnlocker.exe /Delete /Advanced C:\Windows\System32\spool\drivers\x64\3

REM restart printer spooler.
echo * Restarting Print Spooler
net start spooler

echo Please re-add all your printers via the "Devices and Printers" option in the start menu.
pause