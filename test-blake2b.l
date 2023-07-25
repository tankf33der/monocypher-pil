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
