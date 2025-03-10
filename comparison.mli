open Dictionary

(* [StringKey] is a module that represents a key of a dictionary of type
* string. *)
module StringKey : Comparable with type t = string

(* [HashValue] is a module that represents a value of a dictionary of type
 * int list.
 *)
module HashValue : Formattable with type t = (int*int) list

(* [FileDict] is a module that represents a dictionary with keys of type string
 * and values of type int list.
 *)
module FileDict : Dictionary with type Key.t = string
                              and type Value.t = (int*int) list

(* [DictValue] is a module that represents a value of a dictionary of type
 * FileDict.t
 *)
module DictValue : Formattable with type t = FileDict.t

(* [CompDict] is a module that represents a dictionary with keys of type string
 * and values of type FileDict.t
 *)
module CompDict: Dictionary with type Key.t = string
                              and type Value.t = FileDict.t

(* [intersection v1 v2] returns a list of elements present in both v1 and
 * v2. The elements are in the order that they appear in v1, and the positions
 * are as they are in the corresponding values in v1.
 *)
val intersection : HashValue.t -> HashValue.t -> HashValue.t

(* [make_pair_comp k0 file_list comp_dict] returns a file dictionary where the
 * keys are the keys from file_list, and each value is the intersection of
 * the values in file_list of the key mapped to that value, and the key k0.
 *)
val make_pair_comp : string -> (StringKey.t * HashValue.t) list -> FileDict.t

(* [compare d] returns a comparison dictionary whose keys are the keys
 * from d, and whose values are dictionaries representing pairwise comparisons
 * of that key with every other key in d.
 *)
val compare : FileDict.t -> CompDict.t

(* [create_sim_list threshold comp_dict] assigns a similarity score to each of
 * the keys in comp_dict, and returns a list of files whose similarity scores
 * are above threshold, and their overall similarity score. The similarity of
 * one file with another is calculated as the number of matching hashes between
 * the files divided by the number of hashes of the file itself, and hence the
 * similarity score of a file is the average of the similarities of that
 * file with every other file. The files are ordered in decreasing order of
 * similarity, and files that have the same similarity score are ordered by
 * increasing order of filename.
 *)
val create_sim_list : CompDict.t -> float -> (StringKey.t * float) list

(* [create_pair_sim_list f_name f_dict_list] returns a list of files and
 * their corresponding pair similarity scores when compared with f_name.
 * requires: The value in f_dict_list corresponding to f_name cannot be
 * an empty list, unless f_dict_list itself is an empty list. *)
val create_pair_sim_list : StringKey.t -> (StringKey.t * HashValue.t) list ->
  (StringKey.t * float) list
