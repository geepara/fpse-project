module type Wallet = sig
  type t = { string: string }
  type tx = Transaction

  (*
     This function will retrive a private key from the given name of
     a config file.
  *)
  val private_key : string -> string

  (* 
     This function will take in a private key and an unsigned transaction and
     produce a signed transaction ready to be sent to the blockchain
  *)
  val sign_tx : string -> tx
end