module type Contract = sig
  (* type node = Node_provider *)
  type t = { name: string; sourceFile: string; abi: Abi.t}

  (* 
     Takes in string representing contract file location and creates a contract
  *)
  val import_contract : string -> t

  (* 
    Get name of contract given contract object
  *)
  val get_name : t -> string

  (* 
    Returns a list of all the functions available on a contract
  *)
  val functions : t -> string list

  (*
     gets name and inputs for contract constructor
   *)
  val exec_constructor : t -> unit

  (*
     Execute a function on the contract given its abi, function name, and params
  *)
  val exec_function : t -> string -> string list -> unit
end