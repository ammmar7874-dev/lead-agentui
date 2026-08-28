param (
    [int]$IntervalSeconds = 120,
    [string]$Branch = "main"
)

Write-Host "=================================================="
Write-Host "AI RAG ChatBot - Auto Git Commit and Push Daemon"
Write-Host "Interval: Every $IntervalSeconds seconds (2 minutes)"
Write-Host "Target Branch: $Branch"
Write-Host "=================================================="

while ($true) {
    Start-Sleep -Seconds $IntervalSeconds

    try {
        $status = git status --porcelain
        if ($status) {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Write-Host "[$timestamp] Changes detected! Staging and committing..."
            
            git add .
            git commit -m "auto: periodic sync $timestamp"
            
            Write-Host "[$timestamp] Pushing to origin $Branch..."
            git push origin $Branch
            
            Write-Host "[$timestamp] Successfully synced to GitHub!"
        } else {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Write-Host "[$timestamp] No changes detected. Sleeping..."
        }
    }
    catch {
        $err = $_.Exception.Message
        Write-Host "Error during auto-sync: $err"
    }
}
