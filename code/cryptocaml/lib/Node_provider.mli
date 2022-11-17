module type Node_provider = sig
  type t
  type tx = Transaction
  type wallet = Wallet

  (* 
     Provided with the config file name, get the api URL for the node provider
  *)
  val get_provider_api_url : string -> string

  (* 
     Provided with the config file name, get the network the node provider is
     configured for
  *)
  val get_provider_network : string -> string

  (* 
     This function will take a signed transaction and submit it through an api
     call to the node provider listed in the config file
  *)
  val exec_raw_tx : tx -> unit

  (* 
    Execute an ETH transfer using a user's wallet. Takes the amount of ETH in gwei to transfer
  *)
  val exec_eth_transfer : wallet -> int -> unit
end