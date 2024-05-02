# EIP-3074 Demo

Forked from Jaydon's repo, since `EIP-3074` has not been activated yet, the current source code cannot be compiled.
However, the current example can be used to demonstrate the operation of `EIP-3074` once it is activated.

[Source Code:`/contract/Invoker.sol`](/contract/Invoker.sol)

# Simple Invoker + Super Paymaster + D2FA

We will build a security and easy flow for EOA accounts to get gas sponsors seamlessly.
## Binding your EOA with AirAccount
+ Just register and get an ENS name in a specific chain.
+ Get an NFT card for seamless gas payment service with three times free USDT/USDC transfer.
+ You can use your Email to bind your EOA optionally.
+ Optionally charge or use PNTs to redeem annual fees and gas charges.

## Authorization for a Simple Invoker
+ We build a series of invoker templates for daily use.
+ Sign a signature with your local private key.
+ Only the transaction complies with the rules you selected, and it will be launched.
+ See rules detail and signature structure.

  ```
  
  ```
+ Generate the proof and store it in every CommunityNode.

## Security settings
+ Set your CommunityNode confirming number, default is 3.
+ It means if three nodes validate that your transaction signature is right, the transaction was permitted.
+ If you set a D2FA, you must use your passkey to sign the data.

## Verification
+ If you want to transfer 20 USDT to your friends because you have signed a USDT transfer Simple Invoker Contract.
+ Use any wallet with AirAccount SDK or AirAccount homepage, log in with your Email or passkey.
+ Search your friends in the ENS list, input 20, and click send.
+ It depends on your D2FA security setting, pop up a window to scan.
+ The CommunityNode will get the transaction data and spread it to the node network. + If the BLS signature is enough, send it to RPC nodes with a gas sponsorship.
+ The transaction will be build into blocks on blockchain.

## Extensions
+ An AirAccount Purse is building, for community reputation and Blockchain game.
+ It is also a D2FA for your binding EOA with automated notification to avoid scans and some adaptable questions.
