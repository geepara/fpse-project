open Abi
(* let ex_abi = [ { name = "yeah"; functionType = Constructor; inputs = []; outputs = [] } ] *)
type contract_t = { name: string; sourceFile: string; abi: abi }

let import_contract (filename: string) : contract_t =
  { name = filename; sourceFile = filename; abi = [ { name = "yeah"; functionType = Constructor; inputs = []; outputs = [] } ] }

let get_name (contract: contract_t) : string =
  contract.name

let functions (contract: contract_t) : string list =
  [contract.name]

let exec_constructor (contract: contract_t) : unit =
  print_string contract.name

let exec_function (contract: contract_t) (function_name: string) (inputs: string list) : unit =
  let rec print_list (l: string list) =
    match l with
      | [] -> print_string ""
      | x::xs -> ignore(print_string x); print_list xs in
    ignore(print_list inputs);
    ignore(print_string contract.name);
    print_string function_name
