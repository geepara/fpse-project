(*
  transaction = {
    to: '0xa238b6008Bc2FBd9E386A5d4784511980cE504Cd',
    value: ethers.utils.parseEther('1'),
    gasLimit: '21000',
    maxPriorityFeePerGas: ethers.utils.parseUnits('5', 'gwei'),
    maxFeePerGas: ethers.utils.parseUnits('20', 'gwei'),
    nonce: 1,
    type: 2,
    chainId: 3
  }
*)

type transaction = { to_address: string; value: int } [@@deriving to_yojson]

val make_tx : string -> int -> transaction

val tx_to_json : transaction -> string

val sign_tx : string
