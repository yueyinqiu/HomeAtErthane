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
        foreach (var directory in currentDirectory.EnumerateDirectories())
        {
            yield return (directory.Name, "");
        }
        foreach (var file in currentDirectory.EnumerateFiles())
        {
            yield return (file.Name, "");
        }
    }
}
