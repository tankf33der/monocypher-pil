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

# Argon2id
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
(test
   (138 45 5 70 112 111 225 163 92 26 0 15 167 142 206 154 26 92 126 252 172 226 179 90 71 181 156 245 83 185 62 193)
   (crypto_argon2id
      32       # output size
      32       # Memory blocks
      4        # Iterations
      "0101"   # Password
      "a"      # Salt
      "b"      # Key
      "c" ) )  # Ad
(test
   (226 186 176 25 45 190 242 255 149 89 11 11 167 145 179 222 203 97 252 111 145 44 170 214 236 246 63 231 13 181 39 198)
   (crypto_argon2id 32 32 4 (pack (mapcar char (97 98 99)))) )
(test
   (78 20 242 75 5 251 195 121 22 19 67 159 249 240 174 204 96 168 186 187 217 199 14 87 164 115 183 15 234 229 239 124)
   (crypto_argon2id 32 100000 1) )

(msg 'ok)
(bye)
