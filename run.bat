@echo off
:: 1. Call the COBOL environment initializer script to load the compiler variables
call "C:\Users\Asus\Downloads\GC32-NODB-SP1-rename-7z-to-exe.exe\set_env.cmd"

:: 2. Switch tracks to the D drive and jump into your project folder
D:
cd D:\CobolBanking

:: 3. Automatically execute your banking application
banking.exe
pause
