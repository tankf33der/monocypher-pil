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
   (let (Len (length M) Ken (length K))
      (use R
         (native
            "libmonocypher.so.4"
            "crypto_blake2b_keyed"
            NIL
            (cons 'R (cons (cons O 'B O)))
            O
            (cons NIL (cons Ken) K)

(println (crypto_blake2b (mapcar char (chop "abc"))))
(msg 'ok)
(bye)
