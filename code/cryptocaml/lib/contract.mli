open Abi

type contract_t = { name: string; sourceFile: string; abi: abi }

(* 
    Takes in string representing contract file location and creates a contract
*)
val import_contract : string -> contract_t

(* 
  Get name of contract given contract object
*)
val get_name : contract_t -> string

(* 
  Returns a list of all the functions available on a contract
*)
val functions : contract_t -> string list

(*
    gets name and inputs for contract constructor
  *)
val exec_constructor : contract_t -> unit

(*
    Execute a function on the contract given its abi, function name, and params
*)
val exec_function : contract_t -> string -> string list -> unit