(in-package #:cl-user)
#+(or sbcl ecl) (require :asdf)
#-(or sbcl ecl) (load #p"/usr/share/common-lisp/source/asdf/asdf.lisp")
(push #p"/usr/share/common-lisp/systems/" asdf:*central-registry*)
(asdf:oos 'asdf:load-op :asdf-binary-locations)
(setf asdf:*centralize-lisp-binaries* t)
(setf asdf:*source-to-target-mappings* '((#p"/usr/lib/sbcl/" nil) (#p"/usr/lib64/sbcl/" nil)))
