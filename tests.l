(load "monocypher.l")

(println 'blake2b)
(test
   (crypto_blake2b (mapcar char (chop "abc")))
   (crypto_blake2b_keyed (mapcar char (chop "abc"))) )
(let (Ctx (%@ "malloc" 'P 224)  CtxKeyed (%@ "malloc" 'P 224))
   (crypto_blake2b_init Ctx 32)
   (crypto_blake2b_keyed_init CtxKeyed (mapcar char (chop "key")) 32)

   (crypto_blake2b_update Ctx       (97 98 99))
   (crypto_blake2b_update CtxKeyed  (97 98 99))

   (test
      (crypto_blake2b (mapcar char (chop "abc")) 32)
      (crypto_blake2b_final Ctx 32) )
   (test
      (crypto_blake2b_keyed (mapcar char (chop "abc")) (mapcar char (chop "key")) 32)
      (crypto_blake2b_final CtxKeyed 32) )
   (%@ "free" NIL Ctx)
   (%@ "free" NIL CtxKeyed) )

(println 'crypto_argon2id)
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
