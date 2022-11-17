module type Node_provider = sig
  type t
  type tx = Transaction

  (* 
     This function will take a signed transaction and submit it through an api
     call to the node provider listed in the config file
  *)
  val exec_tx : tx -> unit
end