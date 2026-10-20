# Crypto and DeFi projects

Seven separate projects. Three of them read Base mainnet. The token, vault, exchange, and swap page run on a local chain.

| Project | What it does | Code |
| --- | --- | --- |
| Wallet explorer | Shows any Base address’s ETH, USDC, and recent USDC transfers. Read only. | [base-wallet-explorer](https://github.com/mondgui/base-wallet-explorer) |
| Capped token | ERC-20 with a supply cap. Only the owner can mint. Holders can burn their own tokens. | [capped-token](https://github.com/mondgui/capped-token) |
| Staking vault | Depositors stake the capped token and earn a reward token by size and time. The owner cannot withdraw their deposits. | [staking-vault](https://github.com/mondgui/staking-vault) |
| Mini exchange | Two-token pool. Liquidity providers get shares. Swaps follow the constant-product price and revert below the caller’s minimum. | [mini-exchange](https://github.com/mondgui/mini-exchange) |
| Price oracle | ETH/USD and BTC/USD from Chainlink on Base, with a warning when a feed is older than 20 minutes. | [price-oracle](https://github.com/mondgui/price-oracle) |
| Risk assistant | Reads one Base wallet and writes a short note from those balances. No key, no transactions. | [defi-risk-agent](https://github.com/mondgui/defi-risk-agent) |
| Swap copilot | Quotes a trade on the local exchange and waits. Approve sends that quote. Decline sends nothing. | [swap-copilot](https://github.com/mondgui/swap-copilot) |

## Run the pages

Clone this repo, then clone the seven projects into the same folder with these names:

```text
01-base-wallet-explorer
02-capped-token
03-staking-vault
04-mini-amm
05-price-oracle-dashboard
06-defi-risk-agent
07-guarded-swap-copilot
```

From that folder, in PowerShell:

```powershell
.\start-local-pages.ps1
```

- Wallet explorer: http://localhost:5173
- Capped token: http://localhost:5174
- Staking vault: http://localhost:5175
- Mini exchange: http://localhost:5176
- Price oracle: http://localhost:5177
- Risk assistant: http://localhost:5178
- Swap copilot: http://localhost:5179

Needs Node, Foundry, and Anvil. The contracts are not on a public testnet.
