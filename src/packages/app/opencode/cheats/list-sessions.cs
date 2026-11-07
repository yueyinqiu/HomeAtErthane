#:package Snavi.ArgumentSuggester@0.0.2
#:package CliWrap@3.10.4

using System.Runtime.CompilerServices;
using System.Text.Json.Nodes;
using CliWrap;
using CliWrap.Buffered;
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
        var output = await Cli.Wrap("opencode")
            .WithArguments(["session", "list", "--format", "json"])
            .WithWorkingDirectory(currentDirectory.FullName)
            .ExecuteBufferedAsync(cancellationToken);
        var node = JsonNode.Parse(output.StandardOutput);
        foreach (var item in node?.AsArray()!)
        {
            yield return ((string)item!["id"]!, (string)item["title"]!);
        }
    }
}
