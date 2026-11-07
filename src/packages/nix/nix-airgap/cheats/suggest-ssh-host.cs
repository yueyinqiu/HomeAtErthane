#:package Snavi.ArgumentSuggester@0.0.2

using System.Runtime.CompilerServices;
using Snavi.ArgumentSuggester;

await new Suggester().RunAsync();

class Suggester : SnaviArgumentSuggester
{
    public override async IAsyncEnumerable<(string Value, string Description)> SuggestAsync(
        IReadOnlyList<string> givenArguments,
        DirectoryInfo currentDirectory,
        DirectoryInfo temporaryDirectory,
        [EnumeratorCancellation] CancellationToken cancellationToken
    )
    {
        var config = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
            ".ssh",
            "config");
        if (!File.Exists(config))
        {
            yield break;
        }
        foreach (var line in File.ReadLines(config))
        {
            var trimmed = line.TrimStart();
            if (!trimmed.StartsWith("Host "))
            {
                continue;
            }
            var host = trimmed["Host ".Length..].Trim();
            if (host is not "")
            {
                yield return (host, "");
            }
        }
    }
}
