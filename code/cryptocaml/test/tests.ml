(* open Core *)
open OUnit2

(* let test_yojson_to_abi _ =
  failwith "unimplemented" *)
  (* assert_equal (yojson_to_abi (file_to_yojson "abi.json")) @@  *)

let part1_tests =
  "Part 1"
  >: test_list
       [
         (* "yojson_to_abi" >:: test_yojson_to_abi *)
       ]

let series = "Assignment4 Tests" >::: [ part1_tests ]

(* let series = "Assignment3 Tests" >::: [ part1_tests; part2_tests ] *)
let () = run_test_tt_main series