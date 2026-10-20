# Starts the local chain, deploys the three contracts, and opens their pages.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$machine = [Environment]::GetEnvironmentVariable("Path", "Machine")
$user = [Environment]::GetEnvironmentVariable("Path", "User")
$env:Path = "$env:USERPROFILE\.foundry\bin;$machine;$user"

function Test-Rpc {
  try {
    $body = '{"jsonrpc":"2.0","id":1,"method":"eth_chainId","params":[]}'
    $res = Invoke-RestMethod -Uri "http://127.0.0.1:8545" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 2
    return $res.result -eq "0x7a69"
  } catch {
    return $false
  }
}

if (-not (Test-Rpc)) {
  Write-Host "Starting the local chain..."
  Start-Process -FilePath "$env:USERPROFILE\.foundry\bin\anvil.exe" -WindowStyle Minimized
  $ready = $false
  foreach ($try in 1..30) {
    Start-Sleep -Seconds 1
    if (Test-Rpc) { $ready = $true; break }
  }
  if (-not $ready) { throw "The local chain did not start on port 8545." }
}

$sender = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
function Deploy([string]$dir, [string]$script) {
  Push-Location $dir
  try {
    cmd /c "forge script $script --rpc-url http://127.0.0.1:8545 --broadcast --unlocked --sender $sender"
    if ($LASTEXITCODE -ne 0) { throw "Deploy failed: $script" }
  } finally {
    Pop-Location
  }
}

Write-Host "Deploying the token, the vault, and the exchange..."
Deploy (Join-Path $root "02-capped-token") "script/Deploy.s.sol"
Deploy (Join-Path $root "03-staking-vault") "script/DeployWeb.s.sol"
Deploy (Join-Path $root "04-mini-amm") "script/DeployWeb.s.sol"
Copy-Item (Join-Path $root "04-mini-amm\web\public\addresses.json") (Join-Path $root "07-guarded-swap-copilot\public\addresses.json") -Force

function Serve([string]$dir, [int]$port) {
  $listening = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
  if ($listening) {
    Write-Host "Page already open on port $port"
    return
  }
  Push-Location $dir
  try {
    if (-not (Test-Path "node_modules")) { npm install }
  } finally {
    Pop-Location
  }
  Start-Process -FilePath "npm.cmd" -ArgumentList "run","dev" -WorkingDirectory $dir -WindowStyle Minimized
  Write-Host "http://localhost:$port"
}

Serve (Join-Path $root "01-base-wallet-explorer") 5173
Serve (Join-Path $root "02-capped-token\web") 5174
Serve (Join-Path $root "03-staking-vault\web") 5175
Serve (Join-Path $root "04-mini-amm\web") 5176
Serve (Join-Path $root "05-price-oracle-dashboard") 5177
Serve (Join-Path $root "06-defi-risk-agent") 5178
Serve (Join-Path $root "07-guarded-swap-copilot") 5179

Write-Host ""
Write-Host "Wallet explorer   http://localhost:5173"
Write-Host "Capped token      http://localhost:5174"
Write-Host "Staking vault     http://localhost:5175"
Write-Host "Mini exchange     http://localhost:5176"
Write-Host "Price oracle      http://localhost:5177"
Write-Host "Risk assistant    http://localhost:5178"
Write-Host "Swap copilot      http://localhost:5179"
