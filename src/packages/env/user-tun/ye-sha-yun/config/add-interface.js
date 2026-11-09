function main(config, log) {
    const withInterface = (proxies, iface, suffix) =>
        proxies.map((p) => ({
            ...p,
            name: `${p.name}-${suffix}`,
            "interface-name": iface,
        }));

    config.proxies = [
        ...withInterface(config.proxies, "wlp2s0", "wifi"),
    ];

    return config;
}