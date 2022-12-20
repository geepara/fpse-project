(* 0AD2847583DE27515E414CF4740887258A93490E0437F99DBA038AA1D775F3F5  *)
open Core


type transaction = { to_address: string; value: int } [@@deriving to_yojson]

let make_tx (to_address: string) (value: int) : transaction =
  { to_address = to_address; value = value }

let tx_to_json (tx: transaction) : string =
  tx |> transaction_to_yojson |> Yojson.Safe.pretty_to_string

(* let char_list_to_buffer (char_list: char list) (buffer) =
  let rec char_list_to_buffer' (char_list: char list) (buffer) (counter: int) =
    match char_list with
      | [] -> buffer
      | x::xs -> ignore(Bigarray.Array1.set buffer counter x); char_list_to_buffer' xs buffer (counter + 1) in
  char_list_to_buffer' char_list buffer 0 *)

(* let assemble_tx_to_sign (tx: transaction) : string = *)
  

let sign_tx (*(tx: transaction) (secret_key: string)*) =
  (* let body1 =
    let req_body = Cohttp_lwt.Body.of_string "{\"private_key\": \"0AD2847583DE27515E414CF4740887258A93490E0437F99DBA038AA1D775F3F5\", \"tx\": {\"to\": \"0xac03bb73b6a9e108530aff4df5077c2b3d481e5a\", \"value\": \"10000000000\"}}" in
    Client.post (Uri.of_string "http://localhost:3200/sign") ~body:req_body >>= fun (resp, body) ->
    let code = resp |> Response.status |> Code.code_of_status in
    Printf.printf "Response code: %d\n" code;
    Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
    body |> Cohttp_lwt.Body.to_string >|= fun body ->
    Printf.printf "Body of length: %d\n" (String.length body);
    body in

  Lwt_main.run body1 *)

  (* let secp_ctx = Secp256k1.Context.create [Secp256k1.Context.Sign] in

  (* type buffer = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t *)
  let sk_buffer = Bigarray.Array1.create Bigarray.char Bigarray.c_layout 64 in


  (* ignore(Bigarray.Array1.set sk_buffer 0 'A'); *)

  let secp_sk = Secp256k1.Key.read_sk_exn secp_ctx (char_list_to_buffer (String.to_list secret_key) sk_buffer) in

  let msg = "hello" in
  let msg_buffer = Bigarray.Array1.create Bigarray.char Bigarray.c_layout 64 in
  let secp_msg = Secp256k1.Sign.msg_of_bytes_exn (char_list_to_buffer (String.to_list msg) msg_buffer) in
  
  (* let signature = Secp256k1.Sign.sign_exn secp_ctx ~sk:secp_sk ~msg:secp_msg in *)

  let output_buffer = Bigarray.Array1.create Bigarray.char Bigarray.c_layout 128 in
  ignore(Secp256k1.Sign.write_sign_exn secp_ctx ~sk:secp_sk ~msg:secp_msg output_buffer); *)

  (* let size = Bigarray.Array1.dim output_buffer in
  let rec print_array1 (arr) (size: int) : unit =
    if Int.(>=) size 0 then
      ignore(print_string (Char.to_string (Bigarray.Array1.get arr (size - 1))));
      print_array1 arr (size - 1) in
  
  print_array1 output_buffer size *)

  (* Secp256k1.Sign.write_sign_exn *)
      "yes"