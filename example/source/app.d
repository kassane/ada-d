import ada.url : AdaUrl, ParseOptions; // @nogc, @safe, nothrow and betterC compatible
import std.stdio : writeln; // need GC and throw exception

void main() @safe
{
	auto u = AdaUrl(ParseOptions("http://www.google:8080/love#drug"));
	writeln("port: ", u.getPort);
	writeln("hash: ", u.getHash);
	writeln("pathname: ", u.getPathname);
	writeln("href: ", u.getHref());
	u.setPort("9999");
	writeln("href: ", u.getHref); // empty '()' is optional
}
