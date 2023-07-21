# BLAKE2b
(de crypto_blake2b (M O)
   (default O 64)
   (let Len (length M)
      (use R
         (native
            "libmonocypher.so.4"
            "crypto_blake2b"
            NIL
            (cons 'R (cons (cons O 'B O)))
            O
            (cons NIL (cons Len) M)
            Len )
         R ) ) )
(de crypto_blake2b_keyed (M K O)
   (default O 64)
   (let (Len (length M)  Ken (length K))
      (use R
         (native
            "libmonocypher.so.4"
            "crypto_blake2b_keyed"
            NIL
            (cons 'R (cons (cons O 'B O)))
            O
            (cons NIL (cons Ken) K)
            Ken
            (cons NIL (cons Len) M)
            Len )
         R ) ) )
(test
   (crypto_blake2b (mapcar char (chop "abc")))
   (crypto_blake2b_keyed (mapcar char (chop "abc"))) )

# Argon2
# - Algorithm   (0 = Argon2d, 1 = Argon2i, 2 -> Argon2id)
# - Memory      (number of KiB)
# - Time        (number of iterations)
# - Parallelism (number of lanes)
# - Password
# - Salt
# - Key
# - Additional data
(de crypto_argon2 ()
   (let
      (Config (%@ "malloc" 'P 16)
         Inputs (%@ "malloc" 'P 24)
         Extras (%@ "malloc" 'P 24)
         WorkArea (%@ "malloc" 'P (* 1024 8))
         PrtPass NIL
         PtrSalt NIL
         R NIL
         O 64
      )
      (println 'w WorkArea)
      (struct Config NIL -1 -8 -3 -1)
      (println 'c (struct Config '(I I I I)))

      (setq
         PtrPass (%@ "strdup" 'P "mike")
         PtrSalt (%@ "strdup" 'P "salt") )
      (struct Inputs NIL (cons PtrPass 8) (cons PtrSalt 8) (4 . 4) (4 . 4))
      (println 'i Inputs (struct Inputs '(P P I I)))


      (struct Extras NIL (0 . 8) (0 . 8) (0 . 4) (0 . 4))
      (println 'e (struct Extras '(P P I I)))

      (native
         "glue_argon2.so"
         "crypto_argon2"
         NIL
         (cons 'R (cons (cons O 'B O)))
         O
         WorkArea
         Config
         Inputs
         Extras )
      (println 'R R)


      # clean up
      (%@ "free" NIL PtrPass)
      (%@ "free" NIL PtrSalt)

      (%@ "free" NIL Config)
      (%@ "free" NIL Inputs)
      (%@ "free" NIL Extras)
      (%@ "free" NIL WorkArea)
   )

)
(crypto_argon2)

(msg 'ok)
(bye)
