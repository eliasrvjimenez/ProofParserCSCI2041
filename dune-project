(lang dune 3.10)
(using menhir 2.1)
(name final_project)

(generate_opam_files true)

(source
 (github eliasrvjimenez/ProofParserCSCI2041))

(authors "Elias Vera-Jimenez", "Dylan Ringer")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name final_project)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
