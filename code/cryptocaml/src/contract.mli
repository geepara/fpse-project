open Abi
type contract_t = { name: string; signer: int; abi: Abi.abi }

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

val function_exists : contract_t -> string -> bool


val get_function : contract_t -> string -> abi_function

val get_input_types_of_function : abi_function -> string list

val format_input_types_for_signature : string list -> string

val get_function_signature : abi_function -> string

val arg_to_hex : string -> string

val args_to_hex_list : string list -> input_t list -> string list

val string_list_to_string : string list -> string

(*
    Execute a function on the contract given its abi, function name, and params
*)
val exec_function : contract_t -> string -> string list -> string