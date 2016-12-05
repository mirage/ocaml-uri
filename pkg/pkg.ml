#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "uri" @@ fun c ->
  Ok [ Pkg.mllib "lib/uri.mllib";
       Pkg.mllib "lib/services.mllib";
       Pkg.mllib "lib/services_full.mllib";
       Pkg.mllib "top/uri_top.mllib";
       Pkg.test "lib_test/test_runner" ]
