module type Abi = sig
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
  type function_t = Function | Constructor
  type input_output_type_t = Int | String | Address
  type input_t = { name: string; inputType: input_output_type_t }
  type output_t = { name: string; outputType: input_output_type_t }
  (* type functionType = "function" | "constructor" *)
  type t = { name: string;  functionType: function_t; inputs: input_t list; outputs: output_t list}

  (* 
    Given yojson of abi, return an abi object
  *)
  val abi_of_json : string -> t
end