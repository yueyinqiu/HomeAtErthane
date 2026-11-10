#!/usr/bin/env bash

# "$MMMM" for the MihomoManager.MihomoMixin binary
# "$OUTPUT_PATH" for writing the final merged configuration
# "$TEMP_DIRECTORY" for temporary files (cleaned up after the service stops)
# "$STATE_DIRECTORY" for persistent files (retained across runs)
# "$HOME_MANAGER_MIHOMO_MANAGER_PROXIES" for the generated list of managed proxy instances
# . for the instance's own configuration files

tongji_proxy_credential="$(tr -d '[:space:]' < tongji-proxy-credential.txt)"
sed "s|uuid: @tongji-proxy-credential@|uuid: ${tongji_proxy_credential}|g" template.yaml > "$OUTPUT_PATH"
