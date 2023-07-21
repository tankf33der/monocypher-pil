#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "monocypher.h"

void glue_argon2(uint8_t *hash, uint32_t hash_size, void *work_area,
                   crypto_argon2_config *c,
                   crypto_argon2_inputs *i,
                   crypto_argon2_extras *e) {
	// crypto_argon2_config config;
	// crypto_argon2_inputs inputs;
	// crypto_argon2_extras extras;
//
	// memcpy(&config, c, sizeof(config));
	// memcpy(&inputs, i, sizeof(inputs));
	// memcpy(&extras, e, sizeof(extras));

	// printf("%d:algo\n", config.algorithm);
	// printf("%d:blcs\n", config.nb_blocks);
	// printf("%d:pass\n", config.nb_passes);
	// printf("%d:lans\n", config.nb_lanes);
//
	// printf("%p:pass\n", inputs.pass);
	// printf("%d:psize\n", inputs.pass_size);
	// printf("%p:salt\n", inputs.salt);
	// printf("%d:saltsize\n", inputs.salt_size);
//
	// printf("%p:key\n", extras.key);
	// printf("%d:keysize\n", extras.key_size);
	// printf("%p:ad\n", extras.ad);
	// printf("%d:adsize\n", extras.ad_size);



	crypto_argon2(hash, hash_size, work_area, *c, *i, *e);
	// crypto_argon2(hash, hash_size, work_area, config, inputs, extras);
}
