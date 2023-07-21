#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "monocypher.h"

void glue_argon2(uint8_t *hash, uint32_t hash_size, void *work_area,
                   crypto_argon2_config *c,
                   crypto_argon2_inputs *i,
                   crypto_argon2_extras *e) {
	crypto_argon2_config config;
	crypto_argon2_inputs inputs;
	crypto_argon2_extras extras;

	memcpy(&config, c, sizeof(config));
	memcpy(&inputs, i, sizeof(inputs));
	memcpy(&extras, e, sizeof(extras));
	crypto_argon2(hash, hash_size, work_area, config, inputs, extras);
}
