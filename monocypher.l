###########
# blake2b #
###########

(de crypto_blake2b (Data Out)
   (default Out 64)
   (let Len (length Data)
      (use R
         (native
            "libmonocypher.so.4"
            "crypto_blake2b"
            NIL
            (list 'R (cons Out 'B Out))
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
            (list 'R (cons Out 'B Out))
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
(de crypto_blake2b_final (Ctx)
   (let (Size (struct (+ Ctx 216) 'I) R)
      (native
         "libmonocypher.so.4"
         "crypto_blake2b_final"
         NIL
         Ctx
         (cons 'R (cons (cons Size 'B Size))) )
      R ) )

############
# argon2id #
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
         (list 'R (cons Out 'B Out))
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
# poly1305 #
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

##########
# x25519 #
##########

(de crypto_x25519_public_key (SK)
   (use R
      (native
         "libmonocypher.so.4"
         "crypto_x25519_public_key"
         NIL
         '(R (32 B . 32))
         (cons NIL (cons 32) SK) )
      R ) )
(de crypto_x25519 (SK PK)
   (native
      "libmonocypher.so.4"
      "crypto_x25519"
      NIL
      '(R (32 B . 32))
      (cons NIL (cons 32) SK)
      (cons NIL (cons 32) PK) )
   R )
(de crypto_x25519_to_eddsa (K)
   (use R
      (native
         "libmonocypher.so.4"
         "crypto_x25519_to_eddsa"
         NIL
         '(R (32 B . 32))
         (cons NIL (cons 32) K) )
      R ) )
(de crypto_x25519_inverse (Secret Curve)
   (use R
      (native
         "libmonocypher.so.4"
         "crypto_x25519_inverse"
         NIL
         '(R (32 B . 32))
         (cons NIL (cons 32) Secret)
         (cons NIL (cons 32) Curve) )
      R ) )
(de crypto_x25519_dirty_small (Key)
   (use R
      (native
         "libmonocypher.so.4"
         "crypto_x25519_dirty_small"
         NIL
         '(R (32 B . 32))
         (cons NIL (cons 32) Key) )
      R ) )
(de crypto_x25519_dirty_fast (Key)
   (use R
      (native
         "libmonocypher.so.4"
         "crypto_x25519_dirty_fast"
         NIL
         '(R (32 B . 32))
         (cons NIL (cons 32) Key) )
      R ) )

#############
# chacha20 #
#############

(de crypto_chacha20_h (Key Data)
   (use R
      (native
         "libmonocypher.so.4"
         "crypto_chacha20_h"
         NIL
         '(R (32 B . 32))
         (cons NIL (cons 32) Key)
         (cons NIL (cons 16) Data) )
      R ) )
(de crypto_chacha20_djb (Data Key Nonce Ctr)
   (let
      (Len (length Data)
         R NIL
         NextCtr
         (native
            "libmonocypher.so.4"
            "crypto_chacha20_djb"
            'N
            (list 'R (cons Len 'B Len))
            (cons NIL (cons Len) Data)
            Len
            (cons NIL (cons 32) Key)
            (cons NIL (cons 8) Nonce)
            Ctr ) )
      (cons R NextCtr) ) )
(de crypto_chacha20_ietf (Data Key Nonce Ctr)
   (let
      (Len (length Data)
         R NIL
         NextCtr
         (native
            "libmonocypher.so.4"
            "crypto_chacha20_ietf"
            'I
            (list 'R (cons Len 'B Len))
            (cons NIL (cons Len) Data)
            Len
            (cons NIL (cons 32) Key)
            (cons NIL (cons 12) Nonce)
            Ctr ) )
      (cons R NextCtr) ) )
(de crypto_chacha20_x (Data Key Nonce Ctr)
   (let
      (Len (length Data)
         R NIL
         NextCtr
         (native
            "libmonocypher.so.4"
            "crypto_chacha20_x"
            'I
            (list 'R (cons Len 'B Len))
            (cons NIL (cons Len) Data)
            Len
            (cons NIL (cons 32) Key)
            (cons NIL (cons 24) Nonce)
            Ctr ) )
      (cons R NextCtr) ) )

#########
# eddsa #
#########

(de crypto_eddsa_key_pair (Seed)
   (use (Secret Public)
      (native
         "libmonocypher.so.4"
         "crypto_eddsa_key_pair"
         NIL
         '(Secret (64 B . 64))
         '(Public (32 B . 32))
         (cons NIL (cons 32) Seed) )
      (list Secret Public) ) )
(de crypto_eddsa_sign (Secret Data)
   (let (Len (length Data)  Signature)
      (native
         "libmonocypher.so.4"
         "crypto_eddsa_sign"
         NIL
         '(Signature (64 B . 64))
         (cons NIL (cons 64) Secret)
         (cons NIL (cons Len) Data)
         Len )
      Signature ) )
(de crypto_eddsa_check (Signature Pubkey Data)
   (let Len (length Data)
      (native
         "libmonocypher.so.4"
         "crypto_eddsa_check"
         'I
         (cons NIL (cons 64) Signature)
         (cons NIL (cons 32) Pubkey)
         (cons NIL (cons Len) Data)
         Len ) ) )

########
# aead #
########

(de crypto_aead_lock (Key Nonce Ad Data)
   (let (LenAd (length Ad)  LenData (length Data)  Mac NIL  Crypto NIL)
      (native
         "libmonocypher.so.4"
         "crypto_aead_lock"
         NIL
         (list 'Crypto (cons LenData 'B LenData))
         '(Mac (16 B . 16))
         (cons NIL (cons 32) Key)
         (cons NIL (cons 24) Nonce)
         (cons NIL (cons LenAd) Ad)
         LenAd
         (cons NIL (cons LenData) Data)
         LenData )
      (list Crypto Mac) ) )
(de crypto_aead_unlock (Mac Key Nonce Ad Crypto)
   (let
      (LenAd (length Ad)
         LenCrypto (length Crypto)
         Data NIL
         Res
         (native
            "libmonocypher.so.4"
            "crypto_aead_unlock"
            'I
            (list 'Data (cons LenCrypto 'B LenCrypto))
            (cons NIL (cons 16) Mac)
            (cons NIL (cons 32) Key)
            (cons NIL (cons 24) Nonce)
            (cons NIL (cons LenAd) Ad)
            LenAd
            (cons NIL (cons LenCrypto) Crypto)
            LenCrypto ) )
      (list Res Data) ) )
(de crypto_aead_init_x (Ctx Key Nonce)
   (native
      "libmonocypher.so.4"
      "crypto_aead_init_x"
      NIL
      Ctx
      (cons NIL (cons 32) Key)
      (cons NIL (cons 24) Nonce) ) )
(de crypto_aead_init_djb (Ctx Key Nonce)
   (native
      "libmonocypher.so.4"
      "crypto_aead_init_djb"
      NIL
      Ctx
      (cons NIL (cons 32) Key)
      (cons NIL (cons 8) Nonce) ) )
(de crypto_aead_init_ietf (Ctx Key Nonce)
   (native
      "libmonocypher.so.4"
      "crypto_aead_init_ietf"
      NIL
      Ctx
      (cons NIL (cons 32) Key)
      (cons NIL (cons 12) Nonce) ) )
(de crypto_aead_write (Ctx Ad Data)
   (let (LenData (length Data)  LenAd (length Ad)  Crypto NIL  Mac NIL)
      (native
         "libmonocypher.so.4"
         "crypto_aead_write"
         NIL
         Ctx
         (list 'Crypto (cons LenData 'B LenData))
         '(Mac (16 B . 16))
         (cons NIL (cons LenAd) Ad)
         LenAd
         (cons NIL (cons LenData) Data)
         LenData )
      (list Crypto Mac) ) )
(de crypto_aead_read (Ctx Mac Ad Crypto)
   (let
      (LenCrypto (length Crypto)
         LenAd (length Ad)
         Data NIL
         Res
         (native
            "libmonocypher.so.4"
            "crypto_aead_read"
            'I
            Ctx
            (list 'Data (cons LenCrypto 'B LenCrypto))
            (cons NIL (cons 16) Mac)
            (cons NIL (cons LenAd) Ad)
            LenAd
            (cons NIL (cons LenCrypto) Crypto)
            LenCrypto ) )
         (list Res Data) ) )

##############
# elligator2 #
##############

(de crypto_elligator_rev (Curve Tweak)
   (let
      (Hidden NIL
         Res
         (native
            "libmonocypher.so.4"
            "crypto_elligator_rev"
            'I
            '(Hidden (32 B . 32))
            (cons NIL (cons 32) Curve)
            Tweak ) )
      (list Res Hidden) ) )
(de crypto_elligator_map (Hidden)
   (use Curve
      (native
         "libmonocypher.so.4"
         "crypto_elligator_map"
         NIL
         '(Curve (32 B . 32))
         (cons NIL (cons 32) Hidden) )
      Curve ) )
(de crypto_elligator_key_pair (Seed)
   (use (Hidden Secret)
      (native
         "libmonocypher.so.4"
         "crypto_elligator_key_pair"
         NIL
         '(Hidden (32 B . 32))
         '(Secret (32 B . 32))
         (cons NIL (cons 32) Seed) )
      (list Hidden Secret) ) )

##########
# sha512 #
##########

(de sha512 (Data)
   (let (LenData (length Data)  Res)
      (native
         "libmonocypher.so.4"
         "crypto_sha512"
         NIL
         '(Res (64 B . 64))
         (cons NIL (cons LenData) Data)
         LenData )
      Res ) )
(de crypto_sha512_init (Ctx)
   (native
      "libmonocypher.so.4"
      "crypto_sha512_init"
      NIL
      Ctx ) )
(de crypto_sha512_update (Ctx Data)
   (let LenData (length Data)
      (native
         "libmonocypher.so.4"
         "crypto_sha512_update"
         NIL
         Ctx
         (cons NIL (cons LenData) Data)
         LenData ) ) )
(de crypto_sha512_final (Ctx)
   (use Res
      (native
         "libmonocypher.so.4"
         "crypto_sha512_final"
         NIL
         Ctx
         '(Res (64 B . 64)) )
      Res ) )

###############
# sha512 hmac #
###############

(de crypto_sha512_hmac (Key Data)
   (let (LenKey (length Key)  LenData (length Data)  Res)
      (native
         "libmonocypher.so.4"
         "crypto_sha512_hmac"
         NIL
         '(Res (64 B . 64))
         (cons NIL (cons LenKey) Key)
         LenKey
         (cons NIL (cons LenData) Data)
         LenData )
      Res ) )
(de crypto_sha512_hmac_init (Ctx Key)
   (let LenKey (length Key)
      (native
         "libmonocypher.so.4"
         "crypto_sha512_hmac_init"
         NIL
         Ctx
         (cons NIL (cons LenKey) Key)
         LenKey) ) )
(de crypto_sha512_hmac_update (Ctx Data)
   (let LenData (length Data)
      (native
         "libmonocypher.so.4"
         "crypto_sha512_hmac_update"
         NIL
         Ctx
         (cons NIL (cons LenData) Data)
         LenData ) ) )
(de crypto_sha512_hmac_final (Ctx)
   (use Res
      (native
         "libmonocypher.so.4"
         "crypto_sha512_hmac_final"
         NIL
         Ctx
         '(Res (64 B . 64)) )
      Res ) )

###########
# ed25519 #
###########

(de crypto_ed25519_key_pair (Seed)
   (use (Secret Public)
      (native
         "libmonocypher.so.4"
         "crypto_ed25519_key_pair"
         NIL
         '(Secret (64 B . 64))
         '(Public (32 B . 32))
         (cons NIL (cons 32) Seed) )
      (list Secret Public) ) )
(de crypto_ed25519_sign (Secret Data)
   (let (Len (length Data)  Signature)
      (native
         "libmonocypher.so.4"
         "crypto_ed25519_sign"
         NIL
         '(Signature (64 B . 64))
         (cons NIL (cons 64) Secret)
         (cons NIL (cons Len) Data)
         Len )
      Signature ) )
(de crypto_ed25519_check (Signature Pubkey Data)
   (let Len (length Data)
      (native
         "libmonocypher.so.4"
         "crypto_ed25519_check"
         'I
         (cons NIL (cons 64) Signature)
         (cons NIL (cons 32) Pubkey)
         (cons NIL (cons Len) Data)
         Len ) ) )
