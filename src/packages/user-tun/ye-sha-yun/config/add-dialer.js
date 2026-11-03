function main(config, log) {
    for (const p of config.proxies) {
        p["dialer-proxy"] = "direct";
    }
    return config;
}