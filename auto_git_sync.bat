@echo off
title Auto Git Sync (Every 2 Mins)
echo ======================================================
echo  AI RAG ChatBot - Auto Git Commit & Push (Every 2 Min)
echo ======================================================
powershell -ExecutionPolicy Bypass -File "%~dp0auto_git_sync.ps1" -IntervalSeconds 120 -Branch main
pause
