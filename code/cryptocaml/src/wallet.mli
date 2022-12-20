module type Wallet = sig
  type t = { private_key: string }

  (* 
     Given filename of config file, return a wallet type
  *)
  val get_wallet_from_priv_key : string -> t

  (*
     This function will retrive a private key from the given name of
     a config file.
  *)
  (* val private_key : string -> string *)

  (* 
     This function will take in a private key and an unsigned transaction and
     produce a signed transaction ready to be sent to the blockchain
  *)
  (* val sign_tx : t ->  *)
end