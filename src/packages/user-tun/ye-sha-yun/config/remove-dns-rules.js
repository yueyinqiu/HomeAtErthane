function main(config, log) {
    if (config["dns"]) {
        delete config["dns"]["fallback-filter"];
        delete config["dns"]["fallback"];
        delete config["dns"]["fake-ip-range"];
        delete config["dns"]["fake-ip-range6"];
        delete config["dns"]["fake-ip-filter"];
        delete config["dns"]["listen"];
    }
    config["dns"]["enhanced-mode"] = "normal";
    config["dns"]["respect-rules"] = false;
    return config;
}