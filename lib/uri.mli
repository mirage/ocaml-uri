(*
 * Copyright (c) 2012-2013 Anil Madhavapeddy <anil@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

(** Uniform Resource Identifier handling that is RFC3986-compliant. *)

(** A single URI that is a compact sequence of characters that identifies
    an abstract or physical resource. *)
type t

type component = [
  `Scheme
| `Authority
| `Userinfo (** subcomponent of authority in some schemes *)
| `Host (** subcomponent of authority in some schemes *)
| `Path
| `Query
| `Query_key
| `Query_value
| `Fragment
]

(** Percent-encode a string. The [scheme] argument defaults to 'http' and
    the [component] argument defaults to `Path *)
val pct_encode : ?scheme:string -> ?component:component -> string -> string

(** Percent-decode a percent-encoded string *)
val pct_decode : string -> string

(** Convert a percent-encoded string into a URI structure *)
val of_string : string -> t

(** Convert a URI structure into a percent-encoded URI string *)
val to_string : t -> string

(** Resolve a URI against a default scheme and base URI *)
val resolve : string -> t -> t -> t

(** Get a query string from a URI *)
val query : t -> (string * string list) list

(** Make a percent-encoded query string from percent-decoded query tuple *)
val encoded_of_query : (string * string list) list -> string

(** Parse a percent-encoded query string into a percent-decoded query tuple *)
val query_of_encoded : string -> (string * string list) list

(** Replace the query URI with the supplied list.
    Input URI is not modified
  *)
val with_query : t -> (string * string list) list -> t

(** Replace the query URI with the supplied singleton query list.
    Input URI is not modified
  *)
val with_query' : t -> (string * string) list -> t

(** [get_query_param' q key] returns the list of values for the
    [key] parameter in query [q].  Note that an empty list is not the
    same as a [None] return value.  For a query [foo], the mapping is:
- [/] returns None
- [/?foo] returns Some []
- [/?foo=] returns [Some [""]]
- [/?foo=bar] returns [Some ["bar"]]
- [/?foo=bar,chi] returns [Some ["bar","chi"]]

    Query keys can be duplicated in the URI, in which case the first
    one is returned.  If you want to resolve duplicate keys, obtain
    the full result set with {! query } instead.
  *)
val get_query_param' : t -> string -> string list option

(** [get_query_param q key] returns the value found for a [key] in
     query [q].  If there are multiple values for the key, then the
     first one is returned/ *)
val get_query_param: t -> string -> string option

(** Add a query parameter to the input query URI.
    Input URI is not modified
  *)
val add_query_param : t -> (string * string list) -> t

(** Add a query parameter to the input singleton query URI.
    Input URI is not modified
  *)
val add_query_param' : t -> (string * string) -> t

(** Add a query parameter list to the input query URI.
    Input URI is not modified
  *)
val add_query_params : t -> (string * string list) list -> t

(** Add a query singleton parameter list to the input query URI.
    Input URI is not modified
  *)
val add_query_params' : t -> (string * string) list -> t

(** Remove a query key from the input query URI.
    Input URI is not modified, and no error is generated if the
    key does not already exist in the URI.
  *)
val remove_query_param : t -> string -> t

val make : ?scheme:string -> ?userinfo:string -> ?host:string ->
  ?port:int -> ?path:string -> ?query:(string * string list) list ->
  ?fragment:string -> unit -> t

(** Get the path component of a URI *)
val path : t -> string

(** Get the path and query components of a URI *)
val path_and_query : t -> string

(** Replace the path URI with the supplied path.
  * Input URI is not modified *)
val with_path : t -> string -> t

(** Get the scheme component of a URI *)
val scheme : t -> string option

(** Get the userinfo component of a URI *)
val userinfo : t -> string option

(** Get the host component of a URI *)
val host : t -> string option

(** Replace the host component of the URI.
    Input URI is not modified. *)
val with_host: t -> string option -> t

(** Get the host component of a URI, with a default supplied if one is
    not present *)
val host_with_default: ?default:string -> t -> string

(** Get the port component of a URI *)
val port : t -> int option

(** Replace the port component of the URI with the supplied port.
    Input URI is not modified *)
val with_port : t -> int option -> t

(** Get the fragment component of a URI *)
val fragment : t -> string option

(** Replace the fragment component of a URI with the supplied fragment.
    Input URI is not modified *)
val with_fragment : t -> string option -> t

(*  Human-readable output, used by the toplevel printer *)
val pp_hum : Format.formatter -> t -> unit
