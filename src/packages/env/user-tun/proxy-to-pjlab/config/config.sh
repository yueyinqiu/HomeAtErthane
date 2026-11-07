#!/usr/bin/env bash

# "$MMMM" for the MihomoManager.MihomoMixin binary
# "$OUTPUT_PATH" for writing the final merged configuration
# "$TEMP_DIRECTORY" for temporary files (cleaned up after the service stops)
# "$STATE_DIRECTORY" for persistent files (retained across runs)
# "$HOME_MANAGER_MIHOMO_MANAGER_PROXIES" for the generated list of managed proxy instances
# . for the instance's own configuration files

cp config.yaml "$OUTPUT_PATH"
