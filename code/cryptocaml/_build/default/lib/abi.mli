module type Abi = sig
  (*
    As is usual, t is the type of the underlying data for the continuous map.  Note it has no parameter 'a on it since
    we will include a fixed type key below which is the type of both keys and values.
  *)
  type t

  (*
    Rather than strings as before, this dictionary will have keys (and values) of some arbitrary type.
    Since we are making continuous maps over one type here the key and value types will be the same.
    But to make the interface more clear we will declare an alias type. 

  *)
  type key
  type value = key (* values are the same type as keys *)

  (* Interpolated lookup should use the Key.interpolate function to return an interpolated value even if the key is not
        directly present.  You should interpolate from the two keys nearest to the key provided here; the previous two functions
     will provide those keys.  If the key here is not between two existing keys there is no interpolation to be done so return None.
     Note that if the key is in fact already in the mapping its value can directly be returned - there is no need to interpolate. *)
  val interpolated_lookup : key -> t -> value option
end