#:package Snavi.ArgumentSuggester@0.0.2

using System.Runtime.CompilerServices;
using Snavi.ArgumentSuggester;

await new Suggester().RunAsync();

class Suggester : SnaviArgumentSuggester
{
    static readonly HashSet<string> ArchiveExtensions = new(StringComparer.OrdinalIgnoreCase)
    {
        ".7z", ".zip", ".tar", ".gz", ".tgz", ".xz", ".bz2", ".rar", ".zst"
    };

    public override async IAsyncEnumerable<(string Value, string Description)> SuggestAsync(
        IReadOnlyList<string> givenArguments,
        DirectoryInfo currentDirectory,
        DirectoryInfo temporaryDirectory,
        [EnumeratorCancellation] CancellationToken cancellationToken
    )
    {
        foreach (var file in currentDirectory.EnumerateFiles())
        {
            if (ArchiveExtensions.Contains(file.Extension))
            {
                yield return (file.Name, "");
            }
        }
    }
}