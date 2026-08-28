# Auto Git Sync Script - Commits and pushes changes every 2 minutes
$intervalSeconds = 120
$branch = "main"

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "   🚀 Git Auto-Sync Service Started (Every 2 mins)   " -ForegroundColor Green
Write-Host "   Target Remote: origin/$branch                     " -ForegroundColor Yellow
Write-Host "   Press Ctrl + C to stop at any time.              " -ForegroundColor Gray
Write-Host "=====================================================" -ForegroundColor Cyan

while ($true) {
    try {
        $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        $status = git status --porcelain

        if (-not [string]::IsNullOrWhiteSpace($status)) {
            Write-Host "[$timestamp] 🔍 Changes detected! Staging and committing..." -ForegroundColor Yellow
            
            git add -A
            
            $commitMessage = "Auto-sync update: $timestamp"
            git commit -m $commitMessage
            
            Write-Host "[$timestamp] 🚀 Pushing changes to GitHub (origin/$branch)..." -ForegroundColor Cyan
            git push origin $branch

            if ($LASTEXITCODE -eq 0) {
                Write-Host "[$timestamp] ✅ Successfully pushed to GitHub!" -ForegroundColor Green
            } else {
                Write-Host "[$timestamp] ⚠️ Push encountered an issue. Will retry on next cycle." -ForegroundColor Red
            }
        } else {
            Write-Host "[$timestamp] ⏳ No changes detected. Sleeping for 2 minutes..." -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "[$timestamp] ⚠️ Error during sync: $_" -ForegroundColor Red
    }

    Start-Sleep -Seconds $intervalSeconds
}
