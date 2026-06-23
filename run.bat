@echo off
title Whisper Flow
cd /d "%~dp0"

REM Prefer the project's virtual environment (created by install.bat).
REM Falls back to system Python if no venv is present.
if exist "%~dp0.venv\Scripts\python.exe" (
    "%~dp0.venv\Scripts\python.exe" -u whisper_flow.py
) else (
    python -u whisper_flow.py
)
pause
