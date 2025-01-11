module bench.bench;
import std.algorithm : count, filter, map, sum;
import std.array : array, split;
import std.datetime.stopwatch : StopWatch, AutoStart, Duration;
import std.file : exists, readText;
import std.format : format;
import std.stdio : stderr, writeln, writefln;
import ada_url;

@safe:

immutable string[11] urlExamples = [
    "https://www.google.com/webhp?hl=en&ictx=2&sa=X&ved=0ahUKEwil_oSxzJj8AhVtEFkFHTHnCGQQPQgI",
    "https://support.google.com/websearch/?p=ws_results_help&hl=en-CA&fg=1",
    "https://en.wikipedia.org/wiki/Dog#Roles_with_humans",
    "https://www.tiktok.com/@aguyandagolden/video/7133277734310038830",
    "https://business.twitter.com/en/help/troubleshooting/how-twitter-ads-work.html?ref=web-twc-ao-gbl-adsinfo&utm_source=twc&utm_medium=web&utm_campaign=ao&utm_content=adsinfo",
    "https://images-na.ssl-images-amazon.com/images/I/41Gc3C8UysL.css?AUIClients/AmazonGatewayAuiAssets",
    "https://www.reddit.com/?after=t3_zvz1ze",
    "https://www.reddit.com/login/?dest=https%3A%2F%2Fwww.reddit.com%2F",
    "postgresql://other:9818274x1!!@localhost:5432/otherdb?connect_timeout=10&application_name=myapp",
    "http://192.168.1.1",
    "http://[2606:4700:4700::1111]",
];

struct BenchmarkData
{
    const(string)[] urls;
    size_t totalBytes;

    static BenchmarkData fromFile(string filename) @trusted
    {
        if (!filename.exists)
        {
            stderr.writeln("File not found: ", filename);
            return BenchmarkData(urlExamples, urlExamples.array.map!(s => s.length).sum);
        }

        auto urls = filename.readText.split;
        return BenchmarkData(urls, urls.map!(s => s.length).sum);
    }

    static BenchmarkData defaultData()
    {
        return BenchmarkData(urlExamples, urlExamples.array.map!(s => s.length).sum);
    }

    size_t countInvalidUrls() const @trusted
    {
        return urls.filter!(url => !AdaUrl(ParseOptions(url)).isValid).count;
    }
}

struct BenchmarkResults
{
    Duration totalTime;
    double bytesPerSecond;
    double urlsPerSecond;
    double timePerByte;
    double timePerUrl;
    size_t paramCount;
    string toString() const
    {
        return format("Benchmark results:\n" ~
                "Total time: %s\n" ~
                "Speed: %.2f bytes/s\n" ~
                "URLs processed: %.2f urls/s\n" ~
                "Time per byte: %.9f s\n" ~
                "Time per URL: %.9f s",
            totalTime,
            bytesPerSecond,
            urlsPerSecond,
            timePerByte,
            timePerUrl);
    }
}

BenchmarkResults runBenchmark(const BenchmarkData data) @trusted
{
    size_t paramCount;
    auto sw = StopWatch(AutoStart.yes);
    foreach (url_string; data.urls)
    {
        auto url = AdaUrl(ParseOptions(url_string));
        if (url.isValid)
        {
            auto params = url.getSearchParams(url.getSearch);
            paramCount += params.length;
        }
    }

    sw.stop();
    immutable duration = sw.peek();
    immutable double seconds = duration.total!"nsecs" / 1_000_000_000.0;

    return BenchmarkResults(
        duration,
        data.totalBytes / seconds,
        data.urls.length / seconds,
        seconds / data.totalBytes,
        seconds / data.urls.length,
        paramCount
    );
}

void main(string[] args)
{
    auto data = args.length > 1 ? BenchmarkData.fromFile(
        args[1]) : BenchmarkData.defaultData();
    writefln("Loaded %d URLs, totaling %d bytes.", data
            .urls.length, data.totalBytes);
    writefln("Found %d invalid URLs.", data.countInvalidUrls());

    auto results = runBenchmark(data);
    writeln(results);
}
