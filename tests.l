(load "monocypher.l")

(prin "blake2b ")
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
(println 'OK)

(prin "argon2id ")
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
(println 'OK)

(prin "poly1305 ")
(test
   (51 53 89 36 247 221 224 227 230 233 236 239 242 245 248 251)
   (crypto_poly1305 (mapcar char (chop "Lorem")) (range 0 31)) )
(test
   (range 16 31)
   (crypto_poly1305 NIL (range 0 31)) )
(let Ctx (%@ "malloc" 'P 80)
   (crypto_poly1305_init Ctx (range 0 31))
   (crypto_poly1305_update Ctx (mapcar char (chop "Lorem")))
   (test
      (51 53 89 36 247 221 224 227 230 233 236 239 242 245 248 251)
      (crypto_poly1305_final Ctx) )
   (%@ "free" NIL Ctx) )
(println 'OK)

(prin "x25519 ")
(test
   (143 64 197 173 182 143 37 98 74 229 178 20 234 118 122 110 201 77 130 157 61 123 94 26 209 186 111 62 33 56 40 95)
   (crypto_x25519_public_key (range 0 31)) )
(test
   (249 174 28 120 77 245 117 116 114 207 46 213 203 221 30 131 6 201 34 192 92 80 61 0 191 108 6 181 75 45 147 27)
   (crypto_x25519 (range 0 31) (range 0 31)) )
(test
   (212 194 243 71 18 130 17 210 193 231 0 51 242 62 145 168 203 196 142 250 28 147 253 135 139 10 107 78 191 46 241 106)
   (crypto_x25519_to_eddsa (range 0 31)) )
(test
   (228 52 27 172 165 46 241 190 89 209 169 227 159 10 133 194 119 146 123 20 77 208 59 65 138 158 88 54 16 80 234 8)
   (crypto_x25519_inverse (range 0 31) (range 0 31)) )
(test
   (143 64 197 173 182 143 37 98 74 229 178 20 234 118 122 110 201 77 130 157 61 123 94 26 209 186 111 62 33 56 40 95)
   (crypto_x25519_dirty_small (range 0 31)) )
(test
   (143 64 197 173 182 143 37 98 74 229 178 20 234 118 122 110 201 77 130 157 61 123 94 26 209 186 111 62 33 56 40 95)
   (crypto_x25519_dirty_fast (range 0 31)) )
(println 'OK)


(bye)
