@echo off
REM Detect the current operating system
IF "%OS%"=="Windows_NT" (
    echo [run.bat] Running on Windows
    main.bat
) ELSE (
    echo [run.bat] Running on Linux or macOS
    ./main.sh
)
