#!/bin/bash

chown -Rv jerakia:jerakia {/etc/jerakia/policy.d,/var/lib/jerakia/plugins,/var/lib/jerakia/data,/var/lib/jerakia/schema,/var/db/jerakia,/etc/jerakia/config}

su jerakia -s /bin/bash -c "jerakia $@"
