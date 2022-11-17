module type Contract = sig
  type t
  type abi = Abi
  type node = Node_provider
  type contract_function = (string * string list) 
  (* type functions = Core.Map.t *)

  (* 
     Takes in string representing contract file location and creates an abi from it
  *)
  val import_contract : string  -> abi

  val get_contract_name : abi -> string

  (*
     gets name and inputs for contract constructor
   *)
  val get_constructor : abi -> contract_function

  (* 
    Returns a list of all the functions available on a contract
  *)
  val functions : abi -> contract_function list

  (*
     Execute a function on the contract given its abi, function name, and params
  *)
  val exec_function : abi -> string -> string list -> unit
end