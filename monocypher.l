# BLAKE2b
(de crypto_blake2b (Data Out)
   (default Out 64)
   (let Len (length Data)
      (use R
         (native
            "libmonocypher.so.4"
            "crypto_blake2b"
            NIL
            (cons 'R (cons (cons Out 'B Out)))
            Out
            (cons NIL (cons Len) Data)
            Len )
         R ) ) )
(de crypto_blake2b_keyed (Data Key Out)
   (default Out 64)
   (let (Len (length Data)  Ken (length Key))
      (use R
         (native
            "libmonocypher.so.4"
            "crypto_blake2b_keyed"
            NIL
            (cons 'R (cons (cons Out 'B Out)))
            Out
            (cons NIL (cons Ken) Key)
            Ken
            (cons NIL (cons Len) Data)
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
(de crypto_argon2 (Out Blocks Iters)
   (let
      (Config (%@ "malloc" 'P 16)
         Inputs (%@ "malloc" 'P 24)
         Extras (%@ "malloc" 'P 24)
         WorkArea (%@ "malloc" 'P (* 1024 Blocks))
         PrtPass NIL
         PtrSalt NIL
         PtrKey  NIL
         PtrAd   NIL
         R NIL
      )
# - Algorithm   (0 = Argon2d, 1 = Argon2i, 2 -> Argon2id)
# - Memory      (number of KiB)
# - Time        (number of iterations)
# - Parallelism (number of lanes)
# - Password
# - Salt
# - Key
# - Additional data
# - Digest
# 0200000000000000:
# 2000000000000000:
# 0300000000000000:
# 0400000000000000:
# 0101010101010101010101010101010101010101010101010101010101010101:
# 02020202020202020202020202020202:
# 0303030303030303:
# 040404040404040404040404:
# 0d640df58d78766c08c037a34a8b53c9d01ef0452d75b65eb52520e96b01e659:

      # XXX 4 . Lanes
      (struct Config NIL
         (2 . 4)
         (cons Blocks 4)
         (cons Iters 4)
         (1 . 4)
      )
      (println 'c (struct Config '(I I I I)))

      (setq
         PtrPass (%@ "strdup" 'P "a")
         PtrSalt (%@ "strdup" 'P "a")
         PtrKey  (%@ "strdup" 'P "a")
         PtrAd   (%@ "strdup" 'P "a")
      )
      (struct Inputs NIL (0 . 8) (0 . 8) (0 . 4) (0 . 4))
      (println 'i Inputs (struct Inputs '(P P I I)))


      (struct Extras NIL (0 . 8) (0 . 8) (0 . 4) (0 . 4))
      (println 'e (struct Extras '(P P I I)))

      (native
         "./glue_argon2.so"
         "glue_argon2"
         NIL
         (cons 'R (cons (cons Out 'B Out)))
         Out
         WorkArea
         Config
         Inputs
         Extras
      )
      (println 'R (length R) R)


      # clean up
      (%@ "free" NIL PtrPass)
      (%@ "free" NIL PtrSalt)
      (%@ "free" NIL PtrKey)
      (%@ "free" NIL PtrAd)
      (msg 0)
      (%@ "free" NIL Config)
      (msg -1)
      (%@ "free" NIL Inputs)
      (msg -2)
      (%@ "free" NIL Extras)
      (msg -3)
      (%@ "free" NIL WorkArea)
      (msg -4)
   )

)
(crypto_argon2
   32       # Hash
   2        # Memory blocks
   3        # Iterations
)

(msg 'ok)
(bye)
