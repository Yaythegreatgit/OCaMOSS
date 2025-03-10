open Dictionary

module StringKey = struct
  type t = string
  let compare k1 k2 = Stdlib.compare k1 k2
end

module HashValue = struct
  type t = (int*int) list
  let format d = ()
end

module FileDict = HashtblDict (StringKey)(HashValue)

module DictValue = struct
  type t = FileDict.t
  let format d = ()
end

module CompDict = HashtblDict (StringKey)(DictValue)

let intersection v1 v2 =
  let rec intersection_helper lst1 lst2 common =
    match lst1 with
    | [] -> common
    | (h,p)::t -> 
      let acc = if List.mem_assoc h lst2 then (h,p)::common 
        else common in
      intersection_helper t lst2 acc

  in
  List.rev(intersection_helper v1 v2 [])

let make_pair_comp k0 file_list =
  List.fold_left (fun x (k,v) ->
      FileDict.insert k (intersection (List.assoc k0 file_list) v) x)
    FileDict.empty file_list

let compare d =
  let file_list = FileDict.to_list d in
  List.fold_left (fun x (k,v) ->
      CompDict.insert k (make_pair_comp k file_list) x)
    CompDict.empty file_list

let cmp_tuple (k1,s1) (k2,s2) = 
  if Stdlib.compare s1 s2 = 0 then Stdlib.compare k1 k2 
  else -(Stdlib.compare s1 s2)

let create_sim_list comp_dict t =
  let create_sim_list_helper comp_dict =
    List.fold_left (fun x (k,d) -> match FileDict.find k d with
        | None -> failwith "Unimplemented"
        | Some v -> let file_length = float_of_int (List.length v) in
          let file_ss =
            List.fold_left (fun (score,n) (k1,v1) ->
                if StringKey.compare k k1 = 0 then (score,n)
                else begin
                  if file_length = 0.0 then (score,n)
                  else 
                    let s = ((float_of_int (List.length v1))/.file_length) in
                    if s >= t then (score+.s,n+.1.0) else (score,n) 
                end) (0.0,0.0) (FileDict.to_list d) 
          in
          let sim_score = if (snd file_ss) = 0.0 then 0.0 
            else (fst file_ss)/.(snd file_ss) in
          if sim_score >= t then (k,sim_score)::x else x) 
      [] (CompDict.to_list comp_dict) 
  in
  List.sort (cmp_tuple) (create_sim_list_helper comp_dict)

let create_pair_sim_list f_name f_dict_list =
  try
    if f_dict_list = [] then [] else
      let f_length = float_of_int (List.length (List.assoc f_name f_dict_list)) in
      List.fold_left (fun lst (k,v) -> 
          if k = f_name then lst
          else if f_length = 0.0 then (k,0.0)::lst
          else begin
            (k,(float_of_int(List.length v))/.f_length)::lst
          end) [] f_dict_list
  with
  | Division_by_zero -> failwith "Invalid file dictionary"
