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

    SearchParams getSearch() nothrow
    {
        return SearchParams(ada_get_search(_url));
    }

    string getSearchParams(SearchParams search) nothrow
    {
        auto str = search.toString();
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

    ada_url copy() nothrow
    {
        return ada_copy(_url);
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

    private ada_url _url;
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

struct SearchParams
{
    this(ada_string input) nothrow
    {
        _str = input;
        _params = ada_parse_search_params(_str.data, _str.length);
    }

    ~this() nothrow
    {
        ada_free_search_params_keys_iter(keys);
        ada_free_search_params_values_iter(values);
        ada_free_search_params_entries_iter(entries);
        ada_free_search_params(_params);
    }

    void append(string key, string value) nothrow
    {
        ada_search_params_append(_params, &key[0], key.length, &value[0], value.length);
    }

    ada_owned_string toString() nothrow
    {
        return ada_search_params_to_string(_params);
    }

    ada_string get(string key) nothrow
    {
        return ada_search_params_get(_params, &key[0], key.length);
    }

    @property ada_url_search_params_keys_iter keys() nothrow
    {
        return ada_search_params_get_keys(_params);
    }

    @property ada_url_search_params_values_iter values() nothrow
    {
        return ada_search_params_get_values(_params);
    }

    @property ada_url_search_params_entries_iter entries() nothrow
    {
        return ada_search_params_get_entries(_params);
    }

    Strings getAll(string key) nothrow
    {
        return Strings(ada_search_params_get_all(_params, &key[0], key.length));
    }

    bool has(string key) nothrow
    {
        return ada_search_params_has(_params, &key[0], key.length);
    }

    bool hasValue(string key, string value) nothrow
    {
        return ada_search_params_has_value(_params, &key[0], key.length, &value[0], value.length);
    }

    size_t length() nothrow
    {
        return ada_search_params_size(_params);
    }

    void reset() nothrow
    {
        ada_search_params_reset(_params, _str.data, _str.length);
    }

    void remove(string key) nothrow
    {
        ada_search_params_remove(_params, &key[0], key.length);
    }

    void removeValue(string key, string value) nothrow
    {
        ada_search_params_remove_value(_params, &key[0], key.length, &value[0], value.length);
    }

    void set(string key, string value) nothrow
    {
        ada_search_params_set(_params, &key[0], key.length, &value[0], value.length);
    }

    void sort() nothrow
    {
        ada_search_params_sort(_params);
    }

    private
    {
        ada_url_search_params _params;
        ada_string _str;
    }
}

struct Strings
{
    this(ada_strings input) nothrow
    {
        _str = input;
    }

    ~this() nothrow
    {
        ada_free_strings(_str);
    }

    string getStr(size_t index) nothrow
    {
        return str_convert(ada_strings_get(_str, index));
    }

    ada_string getData(size_t index) nothrow
    {
        return ada_strings_get(_str, index);
    }

    size_t length() nothrow
    {
        return ada_strings_size(_str);
    }

    private ada_strings _str;
}

string str_convert(T)(T str) @trusted
{
    import std.conv : to;

    static if (is(T == ada_string) || is(T == ada_owned_string))
        return to!string(str.data[0 .. str.length]);
    else
        return to!string(str);
}
