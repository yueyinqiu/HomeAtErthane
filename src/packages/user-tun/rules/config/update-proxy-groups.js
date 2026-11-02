function main(config, log) {
  const proxyNames = config.proxies.map(p => p.name);
  const groupNames = new Set(config["proxy-groups"].map(g => g.name));

  for (const group of config["proxy-groups"]) {
    group.proxies = [...group.proxies.filter(p => groupNames.has(p)), ...proxyNames];
  }

  return config;
}