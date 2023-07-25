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
