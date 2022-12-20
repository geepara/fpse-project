const ethers = require("ethers")
const ethTx = require('ethereumjs-tx');

const express = require("express")
const app = express()
app.use(express.json());

const PORT = process.env.PORT || 3200;

app.listen(PORT, () => {
  console.log("Express app is running!");
});

async function signtx(private_key, tx) {
  console.log(tx)
  let wallet = new ethers.Wallet(private_key)

  // tx.from = await wallet.getAddress()
  // console.log(tx.from)
  // return await wallet.signTransaction(tx)
  let transaction = {
    to: tx.to,
    from: wallet.getAddress(),
    value: ethers.utils.parseEther(tx.value),
    gasLimit: '21000',
    maxPriorityFeePerGas: ethers.utils.parseUnits('5', 'gwei'),
    maxFeePerGas: ethers.utils.parseUnits('20', 'gwei'),
    nonce: 1,
    type: 2,
    chainId: 3
  };

  let rawTransaction = await wallet.signTransaction(transaction).then(ethers.utils.serializeTransaction(transaction));
  return rawTransaction
}

app.post("/sign", async (req, res) => {
  try {
    const { private_key, tx } = req.body
    const data = await signtx(private_key, tx)
    res.json({ data })
  } catch {
    res.status(err.status).json({ message: err.message })
  }
});