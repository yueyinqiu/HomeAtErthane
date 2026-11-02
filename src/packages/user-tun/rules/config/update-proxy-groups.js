function main(config, log) {
  const proxyNames = config.proxies.map(p => p.name);
  const groupNames = new Set(config["proxy-groups"].map(g => g.name));

  for (const group of config["proxy-groups"]) {
    group.proxies = [
      ...group.proxies.filter(p => p === "DIRECT" || groupNames.has(p)),
      ...proxyNames
    ].map(p => p === "DIRECT" ? "direct" : p);
  }

  return config;
}