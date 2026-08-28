@echo off
title Git Auto-Sync (Every 2 Minutes)
echo ========================================================
echo   Starting Git 2-Minute Auto-Sync Service...
echo   Target Repo: https://github.com/ammmar7874-dev/lead-agentui.git
echo ========================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0auto_git_sync.ps1"
pause
