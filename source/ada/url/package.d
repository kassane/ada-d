/*
 * Copyright 2025 Matheus C. França
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
module ada.url;

version (D_BetterC) // no DRT
{
    /// if betterC and LDC, disable moduleinfo and typeinfo
    version (LDC)
    {
        pragma(LDC_no_moduleinfo);
        pragma(LDC_no_typeinfo);
    }
}

public import ada.c.wrapper;

@("Simple URL parser user-friendly API")
@nogc nothrow unittest
{
    import core.stdc.string : strlen; // @system
    import ada.c.ada;

    // Test ada_parse
    const(char)* input = "http://user:pass@example.com:8080/path/to/file.html?query=value#fragment";
    auto url = ada_parse(input, strlen(input));
    scope (exit)
        ada_free(url);
    assert(ada_is_valid(url));
}

@("Search params parser key-value pair")
nothrow @nogc unittest
{
    import core.stdc.string : strlen; // @system
    import ada.c.ada;

    const(char)* input = "a=b&c=d&c=e&f=g";
    auto url = ada_parse_search_params(input, strlen(input));

    assert(ada_search_params_size(url) == 4);

    const(char)* key = "key1";
    const(char)* value = "value1";
    const(char)* value2 = "value2";
    ada_search_params_append(url, key, strlen(key), value, strlen(value));
    assert(ada_search_params_size(url) == 5);

    ada_search_params_set(url, key, strlen(key), value2, strlen(value2));
    assert(ada_search_params_size(url) == 5);

    assert(ada_search_params_has(url, key, strlen(key)));
    assert(!ada_search_params_has_value(url, key, strlen(key), value, strlen(value)));
    assert(ada_search_params_has_value(url, key, strlen(key), value2, strlen(value2)));

    auto result = ada_search_params_get_all(url, key, strlen(key));
    assert(ada_strings_size(result) == 1);
    ada_free_strings(result);

    auto keys = ada_search_params_get_keys(url);
    auto values = ada_search_params_get_values(url);
    auto entries = ada_search_params_get_entries(url);

    assert(ada_search_params_keys_iter_has_next(keys));
    assert(ada_search_params_values_iter_has_next(values));
    assert(ada_search_params_entries_iter_has_next(entries));

    assert(str_convert(ada_search_params_keys_iter_next(keys)) == "a");
    assert(str_convert(ada_search_params_keys_iter_next(keys)) == "c");
    assert(str_convert(ada_search_params_keys_iter_next(keys)) == "c");
    assert(str_convert(ada_search_params_keys_iter_next(keys)) == "f");
    assert(str_convert(ada_search_params_keys_iter_next(keys)) == "key1");
    assert(!ada_search_params_keys_iter_has_next(keys));

    assert(str_convert(ada_search_params_values_iter_next(values)) == "b");
    assert(str_convert(ada_search_params_values_iter_next(values)) == "d");
    assert(str_convert(ada_search_params_values_iter_next(values)) == "e");
    assert(str_convert(ada_search_params_values_iter_next(values)) == "g");
    assert(str_convert(ada_search_params_values_iter_next(values)) == "value2");
    assert(!ada_search_params_values_iter_has_next(values));

    auto pair = ada_search_params_entries_iter_next(entries);
    assert(str_convert(pair.value) == "b");
    assert(str_convert(pair.key) == "a");

    pair = ada_search_params_entries_iter_next(entries);
    assert(str_convert(pair.value) == "d");
    assert(str_convert(pair.key) == "c");

    while (ada_search_params_entries_iter_has_next(entries))
    {
        ada_search_params_entries_iter_next(entries);
    }

    ada_search_params_remove(url, key, strlen(key));
    ada_search_params_remove_value(url, key, strlen(key), value, strlen(value));

    auto str = ada_search_params_to_string(url);
    assert(str_convert(str) == "a=b&c=d&c=e&f=g");

    ada_free_search_params_keys_iter(keys);
    ada_free_search_params_values_iter(values);
    ada_free_search_params_entries_iter(entries);
    ada_free_owned_string(str);
    ada_free_search_params(url);
}

@("Wrapped API")
@safe nothrow @nogc unittest
{
    // Test parsing a URL
    auto url = AdaUrl(ParseOptions("https://example.com/path?query=value#hash"));
    assert(url.isValid());

    assert(url.getProtocol() == "https:");
    assert(url.getHost() == "example.com");
    assert(url.getPathname() == "/path");
    assert(url.getSearch().toString().str_convert() == "query=value");
    assert(url.getHash() == "#hash");

    // Test setting URL components
    url.setProtocol("http");
    assert(url.getProtocol() == "http:");
    url.setHost("example.org");
    assert(url.getHost() == "example.org");
    url.setPathname("/new-path");
    assert(url.getPathname() == "/new-path");
    url.setSearch("?new=value");
    assert(url.getSearch().toString().str_convert() == "new=value");
    url.setHash("#new-hash");
    assert(url.getHash() == "#new-hash");

    // Test clearing URL components
    url.clearPort();
    assert(!url.hasPort());
    url.clearHash();
    assert(!url.hasHash());
    url.clearSearch();
    assert(!url.hasSearch());

    // Test parsing with base URL
    auto baseUrl = AdaUrl(ParseOptions("https://example.com/base"));
    auto relativeUrl = AdaUrl(ParseOptions("/relative/path?query=value#hash", baseUrl.getHref()));
    assert(relativeUrl.getProtocol() == "https:");
    assert(relativeUrl.getHost() == "example.com");
    assert(relativeUrl.getPathname() == "/relative/path");
    assert(relativeUrl.getSearch().toString().str_convert() == "query=value");
    assert(relativeUrl.getHash() == "#hash");
}
