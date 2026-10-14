function main(config, log) {
    const proxy = "home-manager-mihomo-manager-to-overseas";

    const overseas = [
        "github.com",
        "githubusercontent.com",
        "gitlab.com",
        "web.archive.org",
        "nomachine.com",
        "googlesource.com",
        "cachix.org",
        "corona.studio",
        "nixos.org",
        "vsassets.io",
    ];

    const direct = [
        "aur.archlinux.org",
        "crates.io",
        "download.codebuddy.cn",
        "elpa.gnu.org",
        "roslyn.blob.core.windows.net",
        "qq.com",
        "pythonhosted.org",
        "steampowered.com",
        "sourceforge.net",
        "mirror.nju.edu.cn",
        "mirrors.tuna.tsinghua.edu.cn",
        "mirrors.cernet.edu.cn",
        "mirrors.ustc.edu.cn",
        "mirrors.cqupt.edu.cn",
        "mirror.sjtu.edu.cn",
        "nuget.org",
        "microsoft.com",
        "addons.mozilla.org",
        "feishucdn.com",
        "gitlab.freedesktop.org",
        "visualstudio.com",
        "wpscdn.cn",
        "nya.globalslb.net",
        "cdn.blizzard.com",
        "netease.com"
    ];

    config["proxy-groups"] = [
        { name: "final", type: "select", proxies: ["REJECT", "DIRECT", proxy] },
    ].concat(
        overseas
            .map(d => ({ name: d, type: "select", proxies: [proxy, "DIRECT"] }))
            .concat(direct.map(d => ({ name: d, type: "select", proxies: ["DIRECT", proxy] })))
            .sort((a, b) => a.name.localeCompare(b.name))
    );

    config["rules"] = overseas.concat(direct).map(d => "DOMAIN-SUFFIX," + d + "," + d).concat("MATCH,final");

    return config;
}
