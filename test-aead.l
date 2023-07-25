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

(let
   (Ctx (%@ "malloc" 'P 48)
      Ctx2 (%@ "malloc" 'P 48)
      Crypto NIL
      UnCrypto NIL )
   (crypto_aead_init_x Ctx (range 0 31) (range 0 23))
   (crypto_aead_init_x Ctx2 (range 0 31) (range 0 23))
   (setq Crypto
      (crypto_aead_write
         Ctx
         (mapcar char (chop "a"))
         (mapcar char (chop "Lorem ipsum")) ) )
   (test
      '((210 173 125 26 253 242 228 222 64 49 75) (209 7 245 48 59 168 253 90 117 253 81 213 126 173 87 240))
      Crypto )
   (setq UnCrypto
      (crypto_aead_read
         Ctx2
         (cadr Crypto)
         (mapcar char (chop "a"))
         (car Crypto) ) )
   (test 0 (car UnCrypto))
   (test (mapcar char (chop "Lorem ipsum")) (cadr UnCrypto)) )


(println 'OK)