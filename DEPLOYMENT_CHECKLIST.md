# 📋 PHAROS USDC - DEPLOYMENT CHECKLIST

## DEPLOYMENT ORDER

Деплой контракты **в этом порядке** в Remix IDE:

---

## 📌 CONTRACT 1: PharosUSDCVault

**File**: `1_PharosUSDCVault.sol`

### Steps:
1. Откройте https://remix.ethereum.org
2. Создайте новый файл: `PharosUSDCVault.sol`
3. Скопируйте содержимое `1_PharosUSDCVault.sol`
4. Compile (Ctrl+S) - Compiler: 0.8.19
5. Deploy с constructor argument:
   ```
   0xcfc8330f4bcab529c625d12781b1c19466a9fc8b
   ```
   (это USDC address на Pharos testnet)

### After Deploy:
✅ Скопируйте contract address и **сохраните**:
```
VAULT_ADDRESS = 0x_________________________________
```

---

## 📌 CONTRACT 2: PharosDEX

**File**: `2_PharosDEX.sol`

### Steps:
1. Создайте новый файл: `PharosDEX.sol`
2. Скопируйте содержимое `2_PharosDEX.sol`
3. Compile (Ctrl+S) - Compiler: 0.8.19
4. Deploy с constructor argument:
   ```
   0xcfc8330f4bcab529c625d12781b1c19466a9fc8b
   ```

### After Deploy:
✅ Скопируйте contract address и **сохраните**:
```
DEX_ADDRESS = 0x_________________________________
```

---

## 📌 CONTRACT 3: PharosLiquidityPool

**File**: `3_PharosLiquidityPool.sol`

### Steps:
1. Создайте новый файл: `PharosLiquidityPool.sol`
2. Скопируйте содержимое `3_PharosLiquidityPool.sol`
3. Compile (Ctrl+S) - Compiler: 0.8.19
4. Deploy с constructor argument:
   ```
   0xcfc8330f4bcab529c625d12781b1c19466a9fc8b
   ```

### After Deploy:
✅ Скопируйте contract address и **сохраните**:
```
LP_ADDRESS = 0x_________________________________
```

---

## 📌 CONTRACT 4: PharosCCTPBridge

**File**: `4_PharosCCTPBridge.sol`

### Steps:
1. Создайте новый файл: `PharosCCTPBridge.sol`
2. Скопируйте содержимое `4_PharosCCTPBridge.sol`
3. Compile (Ctrl+S) - Compiler: 0.8.19
4. Deploy с constructor argument:
   ```
   0xcfc8330f4bcab529c625d12781b1c19466a9fc8b
   ```

### After Deploy:
✅ Скопируйте contract address и **сохраните**:
```
BRIDGE_ADDRESS = 0x_________________________________
```

---

## 📝 SAVE ALL ADDRESSES

После того как задеплоил все 4 контракта, **обязательно сохрани все адреса**:

```
PHAROS USDC DEPLOYMENT ADDRESSES
═════════════════════════════════════════════════════════════

Network: Atlantic Testnet
Chain ID: 688689
USDC Contract: 0xcfc8330f4bcab529c625d12781b1c19466a9fc8b

DEPLOYED CONTRACTS:
──────────────────────────────────────────────────────────────

1. VAULT_ADDRESS
   Адрес: 0x_________________________________________________
   Deploy TX: 
   Deploy время: 

2. DEX_ADDRESS
   Адрес: 0x_________________________________________________
   Deploy TX: 
   Deploy время: 

3. LP_ADDRESS (Liquidity Pool)
   Адрес: 0x_________________________________________________
   Deploy TX: 
   Deploy время: 

4. BRIDGE_ADDRESS (CCTP Bridge)
   Адрес: 0x_________________________________________________
   Deploy TX: 
   Deploy время: 


Explorer verification:
https://atlantic.pharosscan.xyz/address/[CONTRACT_ADDRESS]
```

---

## 🎯 VERIFY ON EXPLORER

После деплоя каждого контракта, проверь на explorer:

```
1. Откройте: https://atlantic.pharosscan.xyz
2. Search: Contract address
3. Должны увидеть:
   ✓ "Contract" значок
   ✓ Код видимый
   ✓ Interaction доступен
```

---

## 💾 PASTE INTO dAPP

Когда все 4 контракта задеплоены:

1. Запустите dApp локально:
   ```bash
   npm run dev
   ```

2. Откроется на http://localhost:5173

3. Вверху будет **жёлтый бокс**:
   ```
   ⚠️ Paste Your Deployed Contract Addresses
   ```

4. **Вставьте адреса по порядку**:
   - vault   → VAULT_ADDRESS
   - dex     → DEX_ADDRESS
   - lp      → LP_ADDRESS
   - bridge  → BRIDGE_ADDRESS

5. После каждого нажмите **Tab** (blur)
   → LocalStorage сохранит автоматически
   → Увидите зелёное уведомление

---

## ✅ FINAL CHECKLIST

```
ПЕРЕД ИСПОЛЬЗОВАНИЕМ dAPP:

[ ] Contract 1 (Vault) задеплоен
    Address: 0x___________

[ ] Contract 2 (DEX) задеплоен
    Address: 0x___________

[ ] Contract 3 (LP) задеплоен
    Address: 0x___________

[ ] Contract 4 (Bridge) задеплоен
    Address: 0x___________

[ ] Все 4 адреса вставлены в dApp
    (в жёлтом боксе вверху)

[ ] dApp показывает "Connected" (зелёный)

[ ] MetaMask на Atlantic Testnet (Chain 688689)

[ ] Достаточно PHO для газа (минимум 0.1 PHO)

[ ] Достаточно USDC (из Circle Faucet)

[ ] Готов к первой транзакции! 🚀
```

---

## 🔍 TROUBLESHOOTING

### "Contract not initializing"
```
❌ Проблема: Адрес не вставлен в dApp
✓ Решение:
  - Вставьте адрес точно как в Remix
  - Нажмите Tab после каждого
  - Проверьте что 0x в начале
```

### "Network mismatch"
```
❌ Проблема: MetaMask на другой сети
✓ Решение:
  - MetaMask должен быть на Atlantic Testnet
  - Chain ID: 688689
  - RPC: https://atlantic.dplabs-internal.com
```

### "Gas too low"
```
❌ Проблема: Недостаточно PHO
✓ Решение:
  - Получите PHO из faucet
  - Нужно минимум 0.1 PHO
  - Pharos газ дешевле чем Ethereum
```

---

## 🎯 NEXT STEP

Когда все готово, читайте:
📖 **ETHERS_V6_INTEGRATION_GUIDE.md**

Там полное объяснение как работает dApp и как использовать!

---

**Status**: Ready for Deployment ✅
**Network**: Pharos Atlantic Testnet (688689)
**Contract Count**: 4 Smart Contracts
**Integration**: ethers.js v6 + MetaMask

🚀 **Go deploy!**
