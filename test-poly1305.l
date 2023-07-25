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
