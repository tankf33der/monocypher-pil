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
      (crypto_blake2b_final Ctx) )
   (test
      (crypto_blake2b_keyed (mapcar char (chop "abc")) (mapcar char (chop "key")) 32)
      (crypto_blake2b_final CtxKeyed) )
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


(prin "chacha20 ")
(test
   (81 227 255 69 168 149 103 92 75 51 180 108 100 244 169 172 225 16 211 77 246 162 206 171 72 99 114 186 203 211 239 246)
   (crypto_chacha20_h (range 0 31) (range 0 15)) )
(test
   '((40 6 53 144 7 33 217 131 39 146 36 184 119 218 162 121 250 128 104 72 84 90 63 197 206 233 70 120 247 78 54 13) . 1234567891)
   (crypto_chacha20_djb (range 0 31) (range 0 31) (range 0 7) 1234567890) )
(test
   '((21 159 126 185 252 111 19 33 164 102 107 80 135 124 206 95 75 224 79 171 166 22 101 106 155 36 62 19 69 108 2 148) . 1234567891)
   (crypto_chacha20_ietf (range 0 31) (range 0 31) (range 0 11) 1234567890) )
(test
   '((20 239 211 74 201 101 162 81 251 80 237 15 245 217 190 112 132 27 61 79 120 130 1 80 199 29 85 47 105 170 119 70) . 0)
   (crypto_chacha20_ietf (range 0 31) (range 0 31) (range 0 11) 4294967295) )
(test
   '((179 187 149 1 22 186 53 137 65 102 233 128 245 241 1 1 51 79 213 63 196 144 99 211 211 57 88 30 59 95 194 133) . 1234567891)
   (crypto_chacha20_x (range 0 31) (range 0 31) (range 0 23) 1234567890) )
(println 'OK)

(prin "eddsa ")
(let
   (Pair (crypto_eddsa_key_pair (range 0 31))
      Secret NIL
      Public NIL
      Signature NIL )
   (test
      '((0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 246 83 51 250 99 3 182 162 61 239 215 222 42 248 170 70 28 176 71 204 191 18 212 237 210 158 243 177 235 166 112 107) (246 83 51 250 99 3 182 162 61 239 215 222 42 248 170 70 28 176 71 204 191 18 212 237 210 158 243 177 235 166 112 107))
      Pair )
   (setq
      Secret (car Pair)
      Public (cadr Pair)
      Signature (crypto_eddsa_sign Secret (need 32 0)) )
   (test
      (90 195 74 128 18 230 182 102 196 12 58 226 14 183 98 47 172 91 146 166 59 238 96 69 229 83 1 107 75 135 177 113 156 161 112 9 136 218 245 244 96 79 122 77 251 157 45 210 129 111 30 11 117 250 47 86 49 108 117 147 160 40 196 3)
      Signature )
   (test
      0
      (crypto_eddsa_check Signature Public (need 32 0)) )
   (inc Signature)
   (test
      -1
      (crypto_eddsa_check Signature Public (need 32 0)) ) )
(println 'OK)

(prin "aead ")
(let
   (Crypto
      (crypto_aead_lock
         (range 0 31)
         (range 0 23)
         (mapcar char (chop "a"))
         (mapcar char (chop "Lorem ipsum")) )
      UnCrypto
         (crypto_aead_unlock
            (cadr Crypto)
            (range 0 31)
            (range 0 23)
            (mapcar char (chop "a"))
            (car Crypto) ) )
   (test
      '((210 173 125 26 253 242 228 222 64 49 75) (209 7 245 48 59 168 253 90 117 253 81 213 126 173 87 240))
      Crypto )
   (test 0 (car UnCrypto))
   (test
      (cadr UnCrypto)
      (mapcar char (chop "Lorem ipsum")) ) )
(println 'OK)


(bye)
