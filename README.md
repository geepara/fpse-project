# Cryptocaml

## Summary

Cryptocaml is an OCaml library that interfaces with the Ethereum and Polygon blockchains.
Cryptocaml can...

<ul>
  <li> Import smart contracts </li>
  <li> Execute smart contract functions </li>
  <li> Send raw ETH transactions </li>
  <li> Send transfer ETH transactions </li>
  <li> Read on-chain wallet balances </li>
  <!-- <li> Read on-chain contract states </li> -->
</ul>

...all in OCaml!

## Details

### Smart Contracts and ABIs

The Application Binary Interface (ABI) can be though of as a "compile smart contract".
ABIs essentially list all of the methods that you can call on a smart contract.
The ABI contains all of the methods, the names of those methods, their arguments and argument types, and return types.

Here is an example of a basic `HelloWorld` smart contract:

```solidity
// SPDX-License-Identifier: MIT

contract HelloWorld {
  string public message;

  constructor(string memory initMessage) {
    message = initMessage;
  }

  function update(string memory newMessage) public {
    message = newMessage;
  }
}
```

and here is its ABI:

```json
{
  "_format": "hh-sol-artifact-1",
  "contractName": "HelloWorld",
  "sourceName": "contracts/HelloWorld.sol",
  "abi": [
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "initMessage",
          "type": "string"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [],
      "name": "message",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "newMessage",
          "type": "string"
        }
      ],
      "name": "update",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ],
  "bytecode": "0x60806040523...",
  "linkReferences": {},
  "deployedLinkReferences": {}
}
```

Each element of the ABI is a function that can be executed on the contract.
In the case of the `HelloWorld` contract, we have 3 functions we can execute:

<ul>
  <li>constructor: self explanatory</li>
  <li>message(): for every data field of the contract, a getter method is automatically generated. This is the method to view the value of the message field of the contract</li>
  <li>update(string newMessage)</li>
</ul>

### Cryptocaml.Abi

The `Abi` module of Cryptocaml is where the abi of a smart contract gets imported and parsed.
It does this by converting the ABI JSON file into a `Yojson.Safe.t` object, and then dissecting that `Yojson.Safe.t` object for relevant information.
This information is then stored in a custom type: `abi_t` which is an `abi_function_t` list.
Here is an example of an `abi_t` object:

```ocaml
utop # Cryptocaml.Abi.get_abi "abi.json";;
- : Cryptocaml.Abi.abi =
[
  {
    Cryptocaml.Abi.name = "update";
    functionType = Cryptocaml.Abi.Function;
    inputs = [
      {
        Cryptocaml.Abi.name = "newMessage";
        inputType = Cryptocaml.Abi.String
      }
    ];
    outputs = [
      {
        Cryptocaml.Abi.name = "";
        outputType = Cryptocaml.Abi.String
      }
    ]
  };
  {
    Cryptocaml.Abi.name = "message";
    functionType = Cryptocaml.Abi.Function;
    inputs = [];
    outputs = [
      {
        Cryptocaml.Abi.name = "";
        outputType = Cryptocaml.Abi.String
      }
    ]
  };
  {
    Cryptocaml.Abi.name = "function";
    functionType = Cryptocaml.Abi.Constructor;
    inputs = [
      {
        Cryptocaml.Abi.name = "initMessage"; inputType = Cryptocaml.Abi.String
      }
    ];
    outputs = []
  }
]
```

This abi was obtained by running `dune utop` in the `cryptocaml/src` folder and running

```ocaml
Cryptocaml.Abi.get_abi "abi.json";;
```

As we can see in the final result, the ABI is dissected and the relevant information is entered into an ocaml object.

### Cryptocaml.Contract

The `Cryptocaml.Contract` module contains the functions necessary to interface with an ethereum smart contract from ocaml code.

To import a contract, go to the `cryptocaml/src` folder and run `dune utop` and then run the command:

```ocaml
let contract = Cryptocaml.Contract.import_contract "abi.json";;
```

The resulting object contains the name of the contract, the secret key of the signer, and the ABI of the contract.

In order to view the executable functions on the contract, run the following command:

```ocaml
Cryptocaml.Contract.functions contract;;
```

In order to understand how to use a function, you must look at the contract's solidity code.
In the case of our `HelloWorld` contract, let's look at `update()`:

```
function update(string memory newMessage) public {
  message = newMessage;
}
```

As we can see, `update()` receives 1 argument called `newMessage`.
In order to execute `update()` we can use the `Cryptocaml.Contract.exec_function` function.
Here's an example of executing the `update()` function on our `HelloWorld` contract using cryptocaml:

```ocaml
Cryptocaml.Contract.exec_function contract "update" ["hello world!"];;
```

Currently, `Cryptocaml.Contract.exec_function` only produces the function execution signature.
This signature must be attached as a data field to an ethereum transaction that looks like this:

```json
{
  "from": "0xEA674fdDe714fd979de3EdF0F56AA9716B898ec8",
  "to": "0xac03bb73b6a9e108530aff4df5077c2b3d481e5a",
  "gasLimit": "21000",
  "maxFeePerGas": "300",
  "maxPriorityFeePerGas": "10",
  "nonce": "0",
  "value": "10000000000"
}
```

In this transaction, `to` must contain the address of the deployed contract on the blockchain.

### Cryptocaml.Transaction

The `Cryptocaml.Transaction` module is responsible for constructing the final ethereum transaction to be sent to a node provider.
The main function of interest in this module is the `Cryptocaml.Transaction.sign_tx` function.
This function takes in a custom `transaction` object and the secret key of the transaction executer.

Currently, the function does not produce the signed transaction.
In order to sign the transaction, I had to use a very specific cryptographic signing algorithm.
This algorithm is found in the `secp256k1` library which Cryptocaml depends on.
The beginnings of the function can be seen in `transaction.mli`.
The documentation for this library was really bad (basically nonexistent) and I had to manually search through the library's code in order to understand how to use it.

Since I couldn't get transaction signing to work, I temporarily tried to offload it to a small express app api with a singular endpoint.
This api endpoint works and can successfully sign a transaction given a secret key and a transaction object.
It uses the ethers.js library which was an inspiration for how I built cryptocaml.
The express app can be found in `cryptocaml/src/signature-server`.

### Cryptocaml.Node_provider

After all the previous steps were completed, the user should end up with a signed ethereum transaction.
The last step (that hasn't been implemented yet) is actually sending the transaction to the node provider to be included in a block.
This can be acccomplished by a very simple `POST` request to the api of the node provider.
In my case the node provider would have been alchemy.
The specifics of the request can be seen <a href="https://docs.alchemy.com/reference/eth-sendrawtransaction-polygon">here</a>.

## Mock Use

Someone wants to create an NFT project using OCaml.

They write their NFT contract.

They develop an app with an OCaml frontend that needs
to interface with the contract.

As an example, maybe they want to allow users to mint
directly from the contract so their frontend app has
to be able to call functions on the contract.

## Libraries

<ul>
  <li>yojson</li>
  <li>cryptokit</li>
  <li>lwt</li>
  <li>secp256k1</li>
</ul>
