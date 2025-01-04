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
module c.wrapper;

private import c.ada;

@safe:

struct AdaUrl
{
private:
    ada_url _url;
public:

    this(ParseOptions options)
    {

        _url = options.url;
    }

    ~this()
    {
        ada_free(_url);
    }

    bool isValid()
    {
        return ada_is_valid(_url);
    }

    string getOrigin()
    {
        auto owned = ada_get_origin(_url);
        scope (exit)
            ada_free_owned_string(owned);
        return str_convert(owned.data);
    }

    string getHref()
    {
        auto str = ada_get_href(_url);
        return str_convert(str);
    }

    string getUsername()
    {
        auto str = ada_get_username(_url);
        return str_convert(str);
    }

    string getPassword()
    {
        auto str = ada_get_password(_url);
        return str_convert(str);
    }

    string getPort()
    {
        auto str = ada_get_port(_url);
        return str_convert(str);
    }

    string getHash()
    {
        auto str = ada_get_hash(_url);
        return str_convert(str);
    }

    string getHost()
    {
        auto str = ada_get_host(_url);
        return str_convert(str);
    }

    string getHostname()
    {
        auto str = ada_get_hostname(_url);
        return str_convert(str);
    }

    string getPathname()
    {
        auto str = ada_get_pathname(_url);
        return str_convert(str);
    }

    string getSearch()
    {
        auto str = ada_get_search(_url);
        return str_convert(str);
    }

    string getProtocol()
    {
        auto str = ada_get_protocol(_url);
        return str_convert(str);
    }

    ubyte getHostType()
    {
        return ada_get_host_type(_url);
    }

    ubyte getSchemeType()
    {
        return ada_get_scheme_type(_url);
    }

    bool setHref(string input)
    {
        return ada_set_href(_url, &input[0], input.length);
    }

    bool setHost(string input)
    {
        return ada_set_host(_url, &input[0], input.length);
    }

    bool setHostname(string input)
    {
        return ada_set_hostname(_url, &input[0], input.length);
    }

    bool setProtocol(string input)
    {
        return ada_set_protocol(_url, &input[0], input.length);
    }

    bool setUsername(string input)
    {
        return ada_set_username(_url, &input[0], input.length);
    }

    bool setPassword(string input)
    {
        return ada_set_password(_url, &input[0], input.length);
    }

    bool setPort(string input)
    {
        return ada_set_port(_url, &input[0], input.length);
    }

    bool setPathname(string input)
    {
        return ada_set_pathname(_url, &input[0], input.length);
    }

    void setSearch(string input)
    {
        ada_set_search(_url, &input[0], input.length);
    }

    void setHash(string input)
    {
        ada_set_hash(_url, &input[0], input.length);
    }

    void clearPort()
    {
        ada_clear_port(_url);
    }

    void clearHash()
    {
        ada_clear_hash(_url);
    }

    void clearSearch()
    {
        ada_clear_search(_url);
    }

    bool hasCredentials()
    {
        return ada_has_credentials(_url);
    }

    bool hasEmptyHostname()
    {
        return ada_has_empty_hostname(_url);
    }

    bool hasHostname()
    {
        return ada_has_hostname(_url);
    }

    bool hasNonEmptyUsername()
    {
        return ada_has_non_empty_username(_url);
    }

    bool hasNonEmptyPassword()
    {
        return ada_has_non_empty_password(_url);
    }

    bool hasPort()
    {
        return ada_has_port(_url);
    }

    bool hasPassword()
    {
        return ada_has_password(_url);
    }

    bool hasHash()
    {
        return ada_has_hash(_url);
    }

    bool hasSearch()
    {
        return ada_has_search(_url);
    }

    const(ada_url_components)* getComponents()
    {
        return ada_get_components(_url);
    }
}

struct ParseOptions
{
    this(string input)
    {
        _url = ada_parse(&input[0], input.length);
    }

    this(string input, string base)
    {
        _url = ada_parse_with_base(&input[0], input.length, &base[0], base.length);
    }

    @property ada_url url()
    {
        return _url;
    }

    private ada_url _url;
}

string str_convert(T)(T str) @trusted
{
    import std.conv : to;

    static if (is(T == ada_string) || is(T == ada_owned_string))
        return to!string(str.data[0 .. str.length]);
    else
        return to!string(str);
}
