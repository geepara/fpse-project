open Core
open Abi
(* open Cryptokit *)
(* let ex_abi = [ { name = "yeah"; functionType = Constructor; inputs = []; outputs = [] } ] *)
type contract_t = { name: string; signer: int; abi: Abi.abi }

let rec get_contract_name_from_assoc (assoc: (string * Yojson.Safe.t) list) : string =
  match assoc with
    | [] -> "contract_name"
    | (text, value)::xs ->
      if String.(=) text "contractName" then
        Abi.get_string_from_yojson value
      else
        get_contract_name_from_assoc xs

let import_contract (filename: string) : contract_t =
  let contract_name = get_contract_name_from_assoc (Abi.get_assoc_from_yojson_assoc (Abi.file_to_yojson filename)) in
  { name = contract_name; signer = 1; abi = Abi.get_abi filename }

let get_name (contract: contract_t) : string =
  contract.name

let functions (contract: contract_t) : string list =
  let abi = contract.abi in
  let rec functions' (abi: abi) : string list =
    match abi with
      | [] -> []
      | x::xs -> x.name :: functions' xs in
      functions' abi

let exec_constructor (contract: contract_t) : unit =
  print_string contract.name

let function_exists (contract: contract_t) (function_name: string) : bool =
  let functions = functions contract in
  let rec function_exists' (functions: string list) (function_name: string) : bool =
    match functions with
      | [] -> false
      | x::xs ->
        if String.(=) x function_name then
          true
        else
          function_exists' xs function_name in
  function_exists' functions function_name


let get_function (contract: contract_t) (function_name: string) : abi_function =
  let abi = contract.abi in
  let rec get_function' (abi: Abi.abi) : Abi.abi_function =
    match abi with
      | [] -> failwith "couldn't find function"
      | x::xs ->
        if String.(=) x.name function_name then
          x
        else
          get_function' xs in
  get_function' abi


let get_input_types_of_function (contract_function: abi_function) : string list =
  let inputs = contract_function.inputs in
  let rec get_input_types_of_function' (inputs: input_t list) : string list =
    match inputs with
      | [] -> []
      | x::xs ->
        let input_type_string = match x.inputType with
          | Int -> "int"
          | String -> "string"
          | Address -> "address" in
        input_type_string :: get_input_types_of_function' xs in
  get_input_types_of_function' inputs

let rec format_input_types_for_signature (input_types: string list) : string =
  match input_types with
    | [] -> ""
    | [x] -> x
    | x::xs -> x ^ "," ^ format_input_types_for_signature xs

let get_function_signature (contract_function: abi_function) : string =
  contract_function.name ^ "(" ^ (contract_function |> get_input_types_of_function |> format_input_types_for_signature) ^ ")"

let rec pad_arg (arg: string) : string =
  if String.length arg < 64 then
    pad_arg ("0" ^ arg)
  else
    arg

let arg_to_hex (arg: string) : string =
  let unpadded = Hex.to_string (Hex.of_string arg) in
  pad_arg unpadded

let rec args_to_hex_list (args: string list) (function_inputs: input_t list): string list =
  match args with
    | [] -> []
    | x::xs -> arg_to_hex x :: args_to_hex_list xs function_inputs

let rec string_list_to_string (list: string list) : string =
  match list with
    | [] -> ""
    | x::xs -> x ^ string_list_to_string xs

let exec_function (contract: contract_t) (function_name: string) (args: string list) : string =
  if not (function_exists contract function_name) then
    failwith "function doesn't exist!"
  else
    let contract_function = get_function contract function_name in
    let function_signature_ascii = get_function_signature contract_function in
    ignore(print_endline function_signature_ascii);
    let keccak = Cryptokit.Hash.keccak 256 in
    let function_signature_hash = Hex.to_string (Hex.of_string (Cryptokit.hash_string keccak function_signature_ascii)) in
    ignore(print_endline function_signature_hash);
    let function_signature = "0x" ^ Core.String.sub function_signature_hash ~pos:0 ~len:8 in
    ignore(print_endline function_signature);
    let args_as_hex_list = args_to_hex_list args contract_function.inputs in
    function_signature ^ (string_list_to_string args_as_hex_list)

(*
open Core;;
open Cryptocaml;;
Contract.exec_function (Contract.import_contract "abi.json") "update" ["hello"];;
*)