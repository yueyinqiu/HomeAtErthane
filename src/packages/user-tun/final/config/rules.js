function main(config, log) {
    const proxies = config.proxies.map((p) => p.name);
    const groups = new Map();

    config.rules = config.rules.map((rule) => {
        const parts = rule.split(",").map((s) => s.trim());

        const policyIndex = parts[parts.length - 1] === "no-resolve" ?
            parts.length - 2 :
            parts.length - 1;
        const originalPolicy = parts[policyIndex];

        const baseName = parts.slice(0, policyIndex).join(",");

        let groupName = baseName;
        let i = 2;
        while (groups.has(groupName)) {
            groupName = `${baseName} (${i++})`;
        }
        groups.set(groupName, originalPolicy);

        const newRule = [...parts];
        newRule[policyIndex] = groupName;
        return newRule.join(",");
    });

    config["proxy-groups"] = [...groups.entries()]
        .sort(([a], [b]) => a.localeCompare(b))
        .map(([name, defaultPolicy]) => ({
            name,
            type: "select",
            proxies: [defaultPolicy, ...proxies.filter((p) => p !== defaultPolicy)],
        }));

    return config;
}