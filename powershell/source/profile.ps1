function prompt {
    "$([char]27)[31m$([Environment]::UserName)$([char]27)[0m" + "@" + "$([char]27)[32m$((Get-ChildItem Env:HOSTNAME).Value)$([char]27)[0m" + " $([char]27)[33m[" + "$((Get-Location).Path.Split("\")[-1])" + "]$([char]27)[0m $([char]27)[32m>$([char]27)[0m "
}
