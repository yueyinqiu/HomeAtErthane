function main(config, log) {
    for (const p of config.proxies) {
        p["interface-name"] = "wlp2s0";
    }
    return config;
}