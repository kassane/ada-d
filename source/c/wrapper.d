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

    this(ParseOptions options) nothrow
    {

        _url = options.url;
    }

    ~this() nothrow
    {
        ada_free(_url);
    }

    bool isValid() nothrow
    {
        return ada_is_valid(_url);
    }

    string getOrigin() nothrow
    {
        auto owned = ada_get_origin(_url);
        scope (exit)
            ada_free_owned_string(owned);
        return str_convert(owned.data);
    }

    string getHref() nothrow
    {
        auto str = ada_get_href(_url);
        return str_convert(str);
    }

    string getUsername() nothrow
    {
        auto str = ada_get_username(_url);
        return str_convert(str);
    }

    string getPassword() nothrow
    {
        auto str = ada_get_password(_url);
        return str_convert(str);
    }

    string getPort() nothrow
    {
        auto str = ada_get_port(_url);
        return str_convert(str);
    }

    string getHash() nothrow
    {
        auto str = ada_get_hash(_url);
        return str_convert(str);
    }

    string getHost() nothrow
    {
        auto str = ada_get_host(_url);
        return str_convert(str);
    }

    string getHostname() nothrow
    {
        auto str = ada_get_hostname(_url);
        return str_convert(str);
    }

    string getPathname() nothrow
    {
        auto str = ada_get_pathname(_url);
        return str_convert(str);
    }

    string getSearch() nothrow
    {
        auto str = ada_get_search(_url);
        return str_convert(str);
    }

    string getProtocol() nothrow
    {
        auto str = ada_get_protocol(_url);
        return str_convert(str);
    }

    ubyte getHostType() nothrow
    {
        return ada_get_host_type(_url);
    }

    ubyte getSchemeType() nothrow
    {
        return ada_get_scheme_type(_url);
    }

    bool setHref(string input) nothrow
    {
        return ada_set_href(_url, &input[0], input.length);
    }

    bool setHost(string input) nothrow
    {
        return ada_set_host(_url, &input[0], input.length);
    }

    bool setHostname(string input) nothrow
    {
        return ada_set_hostname(_url, &input[0], input.length);
    }

    bool setProtocol(string input) nothrow
    {
        return ada_set_protocol(_url, &input[0], input.length);
    }

    bool setUsername(string input) nothrow
    {
        return ada_set_username(_url, &input[0], input.length);
    }

    bool setPassword(string input) nothrow
    {
        return ada_set_password(_url, &input[0], input.length);
    }

    bool setPort(string input) nothrow
    {
        return ada_set_port(_url, &input[0], input.length);
    }

    bool setPathname(string input) nothrow
    {
        return ada_set_pathname(_url, &input[0], input.length);
    }

    void setSearch(string input) nothrow
    {
        ada_set_search(_url, &input[0], input.length);
    }

    void setHash(string input) nothrow
    {
        ada_set_hash(_url, &input[0], input.length);
    }

    void clearPort() nothrow
    {
        ada_clear_port(_url);
    }

    void clearHash() nothrow
    {
        ada_clear_hash(_url);
    }

    void clearSearch() nothrow
    {
        ada_clear_search(_url);
    }

    bool hasCredentials() nothrow
    {
        return ada_has_credentials(_url);
    }

    bool hasEmptyHostname() nothrow
    {
        return ada_has_empty_hostname(_url);
    }

    bool hasHostname() nothrow
    {
        return ada_has_hostname(_url);
    }

    bool hasNonEmptyUsername() nothrow
    {
        return ada_has_non_empty_username(_url);
    }

    bool hasNonEmptyPassword() nothrow
    {
        return ada_has_non_empty_password(_url);
    }

    bool hasPort() nothrow
    {
        return ada_has_port(_url);
    }

    bool hasPassword() nothrow
    {
        return ada_has_password(_url);
    }

    bool hasHash() nothrow
    {
        return ada_has_hash(_url);
    }

    bool hasSearch() nothrow
    {
        return ada_has_search(_url);
    }

    const(ada_url_components)* getComponents() nothrow
    {
        return ada_get_components(_url);
    }
}

struct ParseOptions
{
    this(string input) nothrow
    {
        _url = ada_parse(&input[0], input.length);
    }

    this(string input, string base) nothrow
    {
        _url = ada_parse_with_base(&input[0], input.length, &base[0], base.length);
    }

    @property ada_url url() nothrow
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
