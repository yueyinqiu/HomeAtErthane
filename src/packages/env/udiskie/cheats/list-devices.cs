#:package Snavi.ArgumentSuggester@0.0.2
#:package CliWrap@3.10.4

using System.Runtime.CompilerServices;
using CliWrap;
using CliWrap.Buffered;
using Snavi.ArgumentSuggester;

await new Suggester().RunAsync();

class Suggester : SnaviArgumentSuggester
{
    private static Dictionary<string, string> GetMountMap()
    {
        var map = new Dictionary<string, string>();
        foreach (var line in File.ReadAllLines("/proc/mounts"))
        {
            var parts = line.Split(' ', 3);
            string dev = parts[0];
            string mount = parts[1].Replace(@"\040", " ");
            if (map.TryGetValue(dev, out var current) && current.Length < mount.Length)
                continue;
            map[dev] = mount;
        }
        return map;
    }

    public override async IAsyncEnumerable<(string Value, string Description)> SuggestAsync(
        IReadOnlyList<string> givenArguments,
        DirectoryInfo currentDirectory,
        DirectoryInfo temporaryDirectory,
        [EnumeratorCancellation] CancellationToken cancellationToken
    )
    {
        var mounts = GetMountMap();
        foreach (var block in new DirectoryInfo("/sys/block").EnumerateDirectories())
        {
            if (block.Name.StartsWith("loop") || block.Name.StartsWith("ram") || block.Name.StartsWith("zram"))
                continue;

            foreach (var part in block.EnumerateDirectories())
            {
                if (File.Exists(Path.Combine(part.FullName, "partition")))
                {
                    var dev = $"/dev/{part.Name}";
                    if (!mounts.TryGetValue(dev, out var mount))
                        mount = "Not Mounted";
                    yield return (dev, $"{mount}");
                }
            }
        }
    }
}
