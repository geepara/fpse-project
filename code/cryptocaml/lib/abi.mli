(* ABI format *)
(*  
  [                                              Each element in this array
    {                                            represents a function or constructor
      "name": fun1
      "functionType": "function" | "constructor"
      "inputs": [                                The inputs are the args of the function
        {
          "name": "arg1",
          "type": "string"
        },
        ...
      ]
      "outputs": [                               The outputs are the return values
        {
          "type": "string"
        },
        ...
      ]
    },
    ...
  ]

*)

type function_type_t = Function | Constructor [@@deriving of_yojson]
type input_output_type_t = Int | String | Address [@@deriving of_yojson]

type input_t = { name: string; inputType: input_output_type_t } [@@deriving of_yojson]
type output_t = { name: string; outputType: input_output_type_t } [@@deriving of_yojson]

type abi_function = { name: string;  functionType: function_type_t; inputs: input_t list; outputs: output_t list}  [@@deriving of_yojson]
type abi = abi_function list [@@deriving of_yojson]

(* 
  Given yojson of abi, return an abi object
*)
val file_to_yojson : string -> Yojson.Safe.t

val get_assoc_from_yojson_assoc : Yojson.Safe.t -> (string * Yojson.Safe.t) list

val get_string_from_yojson : Yojson.Safe.t -> string

val get_list_from_yojson : Yojson.Safe.t -> Yojson.Safe.t list

val get_yojson_list_from_assoc : Yojson.Safe.t -> Yojson.Safe.t list

val get_function_name_from_function_assoc : (string * Yojson.Safe.t) list -> string
    
val get_function_type_from_function_assoc : (string * Yojson.Safe.t) list -> function_type_t
      
val get_input_name_from_assoc : (string * Yojson.Safe.t) list -> string

val get_input_type_from_assoc : (string * Yojson.Safe.t) list -> input_output_type_t
  
val get_input_from_assoc : (string * Yojson.Safe.t) list -> input_t

val generate_inputs : Yojson.Safe.t list -> input_t list -> input_t list

val get_function_inputs_from_function_assoc : (string * Yojson.Safe.t) list -> input_t list

val get_output_from_assoc : (string * Yojson.Safe.t) list -> output_t

val generate_outputs : Yojson.Safe.t list -> output_t list -> output_t list

val get_function_outputs_from_function_assoc : (string * Yojson.Safe.t) list -> output_t list

val generate_abi_function : (string * Yojson.Safe.t) list -> abi_function

val get_abi_function_from_yojson_assoc : Yojson.Safe.t -> abi_function

val generate_abi : Yojson.Safe.t list -> abi_function list -> abi

val yojson_to_abi : Yojson.Safe.t -> abi