
###########
# BLAKE2b #
###########

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
(de crypto_blake2b_init (Ctx Out)
   (default Out 64)
   (native
      "libmonocypher.so.4"
      "crypto_blake2b_init"
      NIL
      Ctx
      Out ) )
(de crypto_blake2b_keyed_init (Ctx Key Out)
   (default Out 64)
   (let Ken (length Key)
      (native
         "libmonocypher.so.4"
         "crypto_blake2b_keyed_init"
         NIL
         Ctx
         Out
         (cons NIL (cons Ken) Key)
         Ken ) ) )
(de crypto_blake2b_update (Ctx Data)
   (let Len (length Data)
      (native
         "libmonocypher.so.4"
         "crypto_blake2b_update"
         NIL
         Ctx
         (cons NIL (cons Len) Data)
         Len ) ) )
(de crypto_blake2b_final (Ctx Out)
   (use R
      (native
         "libmonocypher.so.4"
         "crypto_blake2b_final"
         NIL
         Ctx
         (cons 'R (cons (cons Out 'B Out))) )
      R ) )

############
# Argon2id #
############

(de crypto_argon2id (Out Blocks Iters Password Salt Key Ad)
   (let
      (Config (%@ "malloc" 'P 16)
         Inputs (%@ "malloc" 'P 24)
         Extras (%@ "malloc" 'P 24)
         WorkArea (%@ "malloc" 'P (* 1024 Blocks))
         PrtPass NIL
         PtrSalt NIL
         PtrKey  NIL
         PtrAd   NIL
         R NIL )
      (struct Config NIL
         (cons 2  4)
         (cons Blocks 4)
         (cons Iters 4)
         (1 . 4) )
      (setq
         PtrPass (%@ "strdup" 'P Password)
         PtrSalt (%@ "strdup" 'P Salt)
         PtrKey  (%@ "strdup" 'P Key)
         PtrAd   (%@ "strdup" 'P Ad) )
      (struct Inputs NIL
         (cons PtrPass 8)
         (cons PtrSalt 8)
         (cons (length Password) 4)
         (cons (length Salt) 4 ) )
      (struct Extras NIL
         (cons PtrKey 8)
         (cons PtrAd 8)
         (cons (length Key) 4)
         (cons (length Ad) 4) )
      (native
         "./glue_argon2.so"
         "glue_argon2"
         NIL
         (cons 'R (cons (cons Out 'B Out)))
         Out
         WorkArea
         Config
         Inputs
         Extras )
      (%@ "free" NIL PtrPass)
      (%@ "free" NIL PtrSalt)
      (%@ "free" NIL PtrKey)
      (%@ "free" NIL PtrAd)
      (%@ "free" NIL Config)
      (%@ "free" NIL Inputs)
      (%@ "free" NIL Extras)
      (%@ "free" NIL WorkArea)
      R ) )

############
# Poly1305 #
############

(de crypto_poly1305 (Data Key)
   (let Len (length Data)
      (use R
         (native
            "libmonocypher.so.4"
            "crypto_poly1305"
            NIL
            '(R (16 B . 16))
            (cons NIL (cons Len) Data)
            Len
            (cons NIL (cons 32) Key) )
         R ) ) )
(de crypto_poly1305_init (Ctx Key)
   (native
      "libmonocypher.so.4"
      "crypto_poly1305_init"
      NIL
      Ctx
      (cons NIL (cons 32) Key) ) )
(de crypto_poly1305_update (Ctx Data)
   (let Len (length Data)
      (native
         "libmonocypher.so.4"
         "crypto_poly1305_update"
         NIL
         Ctx
         (cons NIL (cons Len) Data)
         Len ) ) )
(de crypto_poly1305_final (Ctx)
   (use R
      (native
         "libmonocypher.so.4"
         "crypto_poly1305_final"
         NIL
         Ctx
         '(R (16 B . 16)) )
      R ) )

(msg 'ok)
(bye)
