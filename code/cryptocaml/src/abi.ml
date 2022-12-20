type function_type_t = Function | Constructor
type input_output_type_t = Int | String | Address

type input_t = { name: string; inputType: input_output_type_t }
type output_t = { name: string; outputType: input_output_type_t }

type abi_function = { name: string;  functionType: function_type_t; inputs: input_t list; outputs: output_t list}
type abi = abi_function list

open Core

let file_to_yojson (filename: string) : Yojson.Safe.t =
  In_channel.read_all filename |> Yojson.Safe.from_string

let get_assoc_from_yojson_assoc (assoc: Yojson.Safe.t) : (string * Yojson.Safe.t) list =
  match assoc with
  | `Tuple _ -> failwith "not matched"
  | `Intlit _ -> failwith "not matched"
  | `Bool _ -> failwith "not matched"
  | `Null -> failwith "not matched"
  | `Variant _ -> failwith "not matched"
  | `List _ -> failwith "not matched"
  | `Float _ -> failwith "not matched"
  | `Int _ -> failwith "not matched"
  | `String _ -> failwith "not matched"
  | `Assoc l -> l

let get_string_from_yojson (yojson: Yojson.Safe.t) : string =
  match yojson with
  | `Tuple _ -> failwith "not matched"
  | `Intlit _ -> failwith "not matched"
  | `Bool _ -> failwith "not matched"
  | `Null -> failwith "not matched"
  | `Variant _ -> failwith "not matched"
  | `List _ -> failwith "not matched"
  | `Float _ -> failwith "not matched"
  | `Int _ -> failwith "not matched"
  | `Assoc _ -> failwith "not matched"
  | `String s -> s

let get_list_from_yojson (yojson: Yojson.Safe.t) : Yojson.Safe.t list =
    match yojson with
    | `Tuple _ -> failwith "not matched"
    | `Intlit _ -> failwith "not matched"
    | `Bool _ -> failwith "not matched"
    | `Null -> failwith "not matched"
    | `Variant _ -> failwith "not matched"
    | `Float _ -> failwith "not matched"
    | `Int _ -> failwith "not matched"
    | `Assoc _ -> failwith "not matched"
    | `String _ -> failwith "not matched"
    | `List l -> l

let get_yojson_list_from_assoc (assoc: Yojson.Safe.t) : Yojson.Safe.t list =
    match assoc with
    | `Tuple _ -> failwith "not matched"
    | `Intlit _ -> failwith "not matched"
    | `Bool _ -> failwith "not matched"
    | `Null -> failwith "not matched"
    | `Variant _ -> failwith "not matched"
    | `Float _ -> failwith "not matched"
    | `Int _ -> failwith "not matched"
    | `String _ -> failwith "not matched"
    | `Assoc _ -> failwith "not matched"
    | `List l -> l

let rec get_function_name_from_function_assoc (function_assoc: (string * Yojson.Safe.t) list) : string =
  match function_assoc with
    | [] -> "function"
    | (text, value)::xs ->
      if String.(=) text "name" then
        get_string_from_yojson value
      else
        get_function_name_from_function_assoc xs
    
let rec get_function_type_from_function_assoc (function_assoc: (string * Yojson.Safe.t) list) : function_type_t =
  match function_assoc with
    | [] -> Function
    | (text, value)::xs ->
      if String.(=) text "type" then
        match get_string_from_yojson value with
          | "function" -> Function
          | "constructor" -> Constructor
          | _ -> Function
      else
        get_function_type_from_function_assoc xs
      
let rec get_input_name_from_assoc (assoc: (string * Yojson.Safe.t) list) : string =
  match assoc with
    | [] -> "input"
    | (text, value)::xs ->
      if String.(=) text "name" then
        get_string_from_yojson value
      else
        get_input_name_from_assoc xs

let rec get_input_type_from_assoc (assoc: (string * Yojson.Safe.t) list) : input_output_type_t =
  match assoc with
    | [] -> String
    | (text, value)::xs ->
      if String.(=) text "type" then
        match get_string_from_yojson value with
          | "string" -> String
          | "int" -> Int
          | "address" -> Address
          | _ -> String
      else
        get_input_type_from_assoc xs
  
let get_input_from_assoc (assoc: (string * Yojson.Safe.t) list) : input_t =
  let input_name = get_input_name_from_assoc assoc in
  let input_type = get_input_type_from_assoc assoc in
  { name = input_name; inputType = input_type }

let rec generate_inputs (inputs_list: Yojson.Safe.t list) (accum: input_t list) : input_t list =
  match inputs_list with
    | [] -> accum
    | x::xs ->
      generate_inputs xs (get_input_from_assoc (get_assoc_from_yojson_assoc x) :: accum)
      

let rec get_function_inputs_from_function_assoc (function_assoc: (string * Yojson.Safe.t) list) : input_t list =
  match function_assoc with
    | [] -> []
    | (text, value)::xs ->
      if String.(=) text "inputs" then
        generate_inputs (get_list_from_yojson value) []
      else
        get_function_inputs_from_function_assoc xs

let get_output_from_assoc (assoc: (string * Yojson.Safe.t) list) : output_t =
  let output_name = get_input_name_from_assoc assoc in
  let output_type = get_input_type_from_assoc assoc in
  { name = output_name; outputType = output_type }

let rec generate_outputs (outputs_list: Yojson.Safe.t list) (accum: output_t list) : output_t list =
  match outputs_list with
    | [] -> accum
    | x::xs ->
      generate_outputs xs (get_output_from_assoc (get_assoc_from_yojson_assoc x) :: accum)

let rec get_function_outputs_from_function_assoc (function_assoc: (string * Yojson.Safe.t) list) : output_t list =
  match function_assoc with
    | [] -> []
    | (text, value)::xs ->
      if String.(=) text "outputs" then
        generate_outputs (get_list_from_yojson value) []
      else
        get_function_outputs_from_function_assoc xs

let generate_abi_function (function_assoc: (string * Yojson.Safe.t) list) : abi_function =
  let function_type = get_function_type_from_function_assoc function_assoc in
  let function_name = get_function_name_from_function_assoc function_assoc in
  let function_inputs = get_function_inputs_from_function_assoc function_assoc in
  let function_outputs = get_function_outputs_from_function_assoc function_assoc in
  { name = function_name; functionType = function_type; inputs = function_inputs; outputs = function_outputs }

let get_abi_function_from_yojson_assoc (yojson_assoc: Yojson.Safe.t) : abi_function =
  generate_abi_function (get_assoc_from_yojson_assoc yojson_assoc)

let rec generate_abi (functions_list: Yojson.Safe.t list) (accum: abi_function list): abi =
  match functions_list with
    | [] -> accum
    | x::xs ->
      generate_abi xs (get_abi_function_from_yojson_assoc x :: accum)

let yojson_to_abi (yojson_assoc: Yojson.Safe.t) : abi =
  match get_assoc_from_yojson_assoc yojson_assoc with
    | [] -> failwith "abi not found"
    | _::[] -> failwith "abi not found"
    | _::_::[] -> failwith "abi not found"
    | _::_::_::[] -> failwith "abi not found"
    | _::_::_::abi_functions_yojson_list::_ ->
      match abi_functions_yojson_list with
        | (_, yojson_list) -> (
          let functions_list = get_list_from_yojson yojson_list in
          generate_abi functions_list []
        )

let get_abi (filename: string) : abi =
  yojson_to_abi (file_to_yojson filename)