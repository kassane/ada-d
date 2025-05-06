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
module ada.c.wrapper;

/// Ada-URL low-level library.
private import ada.c.ada;

@safe:

/++
 + A struct representing a parsed URL, providing methods to access and manipulate URL components.
 + Wraps the functionality of the Ada URL parsing library.
 +/
struct AdaUrl
{
    /++
     + Constructs an AdaUrl instance with the given parsing options.
     + Params:
     +   options = The parsing options containing the URL to parse.
     +/
    this(ParseOptions options) @nogc nothrow
    {
        _url = options.url;
    }

    /++
     + Destructor that frees the underlying URL resources.
     +/
    ~this() @nogc nothrow
    {
        ada_free(_url);
    }

    /++
     + Checks if the URL is valid.
     + Returns: true if the URL is valid, false otherwise.
     +/
    bool isValid() @nogc nothrow
    {
        return ada_is_valid(_url);
    }

    /++
     + Retrieves the origin of the URL (e.g., protocol + host + port).
     + Returns: A string representing the URL's origin.
     +/
    string getOrigin() @nogc nothrow
    {
        auto owned = ada_get_origin(_url);
        scope (exit)
            ada_free_owned_string(owned);
        return str_convert(owned);
    }

    /++
     + Retrieves the full URL as a string (href).
     + Returns: A string representing the complete URL.
     +/
    string getHref() @nogc nothrow
    {
        auto str = ada_get_href(_url);
        return str_convert(str);
    }

    /++
     + Retrieves the username component of the URL.
     + Returns: A string representing the username, or empty if none.
     +/
    string getUsername() @nogc nothrow
    {
        auto str = ada_get_username(_url);
        return str_convert(str);
    }

    /++
     + Retrieves the password component of the URL.
     + Returns: A string representing the password, or empty if none.
     +/
    string getPassword() @nogc nothrow
    {
        auto str = ada_get_password(_url);
        return str_convert(str);
    }

    /++
     + Retrieves the port component of the URL.
     + Returns: A string representing the port, or empty if none.
     +/
    string getPort() @nogc nothrow
    {
        auto str = ada_get_port(_url);
        return str_convert(str);
    }

    /++
     + Retrieves the hash (fragment) component of the URL.
     + Returns: A string representing the hash, or empty if none.
     +/
    string getHash() @nogc nothrow
    {
        auto str = ada_get_hash(_url);
        return str_convert(str);
    }

    /++
     + Retrieves the host component of the URL (hostname + port).
     + Returns: A string representing the host.
     +/
    string getHost() @nogc nothrow
    {
        auto str = ada_get_host(_url);
        return str_convert(str);
    }

    /++
     + Retrieves the hostname component of the URL.
     + Returns: A string representing the hostname.
     +/
    string getHostname() @nogc nothrow
    {
        auto str = ada_get_hostname(_url);
        return str_convert(str);
    }

    /++
     + Retrieves the pathname component of the URL.
     + Returns: A string representing the pathname.
     +/
    string getPathname() @nogc nothrow
    {
        auto str = ada_get_pathname(_url);
        return str_convert(str);
    }

    /++
     + Retrieves the search (query) parameters of the URL.
     + Returns: A SearchParams struct representing the query parameters.
     +/
    SearchParams getSearch() @nogc nothrow
    {
        return SearchParams(ada_get_search(_url));
    }

    /++
     + Converts the search parameters to a string.
     + Params:
     +   search = The SearchParams object to convert.
     + Returns: A string representing the query parameters.
     +/
    string getSearchParams(SearchParams search) @nogc nothrow
    {
        auto str = search.toString();
        return str_convert(str);
    }

    /++
     + Retrieves the protocol component of the URL (e.g., "http:").
     + Returns: A string representing the protocol.
     +/
    string getProtocol() @nogc nothrow
    {
        auto str = ada_get_protocol(_url);
        return str_convert(str);
    }

    /++
     + Retrieves the host type of the URL.
     + Returns: A ubyte representing the host type (as defined by the Ada library).
     +/
    ubyte getHostType() @nogc nothrow
    {
        return ada_get_host_type(_url);
    }

    /++
     + Retrieves the scheme type of the URL.
     + Returns: A ubyte representing the scheme type (as defined by the Ada library).
     +/
    ubyte getSchemeType() @nogc nothrow
    {
        return ada_get_scheme_type(_url);
    }

    /++
     + Sets the full URL (href).
     + Params:
     +   input = The new URL string to set.
     + Returns: true if successful, false otherwise.
     +/
    bool setHref(string input) @nogc nothrow
    {
        return ada_set_href(_url, &input[0], input.length);
    }

    /++
     + Sets the host component of the URL.
     + Params:
     +   input = The new host string to set.
     + Returns: true if successful, false otherwise.
     +/
    bool setHost(string input) @nogc nothrow
    {
        return ada_set_host(_url, &input[0], input.length);
    }

    /++
     + Sets the hostname component of the URL.
     + Params:
     +   input = The new hostname string to set.
     + Returns: true if successful, false otherwise.
     +/
    bool setHostname(string input) @nogc nothrow
    {
        return ada_set_hostname(_url, &input[0], input.length);
    }

    /++
     + Sets the protocol component of the URL.
     + Params:
     +   input = The new protocol string to set (e.g., "http:").
     + Returns: true if successful, false otherwise.
     +/
    bool setProtocol(string input) @nogc nothrow
    {
        return ada_set_protocol(_url, &input[0], input.length);
    }

    /++
     + Sets the username component of the URL.
     + Params:
     +   input = The new username string to set.
     + Returns: true if successful, false otherwise.
     +/
    bool setUsername(string input) @nogc nothrow
    {
        return ada_set_username(_url, &input[0], input.length);
    }

    /++
     + Sets the password component of the URL.
     + Params:
     +   input = The new password string to set.
     + Returns: true if successful, false otherwise.
     +/
    bool setPassword(string input) @nogc nothrow
    {
        return ada_set_password(_url, &input[0], input.length);
    }

    /++
     + Sets the port component of the URL.
     + Params:
     +   input = The new port string to set.
     + Returns: true if successful, false otherwise.
     +/
    bool setPort(string input) @nogc nothrow
    {
        return ada_set_port(_url, &input[0], input.length);
    }

    /++
     + Sets the pathname component of the URL.
     + Params:
     +   input = The new pathname string to set.
     + Returns: true if successful, false otherwise.
     +/
    bool setPathname(string input) @nogc nothrow
    {
        return ada_set_pathname(_url, &input[0], input.length);
    }

    /++
     + Sets the search (query) component of the URL.
     + Params:
     +   input = The new query string to set.
     +/
    void setSearch(string input) @nogc nothrow
    {
        ada_set_search(_url, &input[0], input.length);
    }

    /++
     + Sets the hash (fragment) component of the URL.
     + Params:
     +   input = The new hash string to set.
     +/
    void setHash(string input) @nogc nothrow
    {
        ada_set_hash(_url, &input[0], input.length);
    }

    /++
     + Clears the port component of the URL.
     +/
    void clearPort() @nogc nothrow
    {
        ada_clear_port(_url);
    }

    /++
     + Clears the hash (fragment) component of the URL.
     +/
    void clearHash() @nogc nothrow
    {
        ada_clear_hash(_url);
    }

    /++
     + Clears the search (query) component of the URL.
     +/
    void clearSearch() @nogc nothrow
    {
        ada_clear_search(_url);
    }

    /++
     + Creates a copy of the URL.
     + Returns: A new ada_url handle representing the copied URL.
     +/
    ada_url copy() @nogc nothrow
    {
        return ada_copy(_url);
    }

    /++
     + Checks if the URL has credentials (username or password).
     + Returns: true if credentials are present, false otherwise.
     +/
    bool hasCredentials() @nogc nothrow
    {
        return ada_has_credentials(_url);
    }

    /++
     + Checks if the URL has an empty hostname.
     + Returns: true if the hostname is empty, false otherwise.
     +/
    bool hasEmptyHostname() @nogc nothrow
    {
        return ada_has_empty_hostname(_url);
    }

    /++
     + Checks if the URL has a hostname.
     + Returns: true if a hostname is present, false otherwise.
     +/
    bool hasHostname() @nogc nothrow
    {
        return ada_has_hostname(_url);
    }

    /++
     + Checks if the URL has a non-empty username.
     + Returns: true if the username is non-empty, false otherwise.
     +/
    bool hasNonEmptyUsername() @nogc nothrow
    {
        return ada_has_non_empty_username(_url);
    }

    /++
     + Checks if the URL has a non-empty password.
     + Returns: true if the password is non-empty, false otherwise.
     +/
    bool hasNonEmptyPassword() @nogc nothrow
    {
        return ada_has_non_empty_password(_url);
    }

    /++
     + Checks if the URL has a port.
     + Returns: true if a port is present, false otherwise.
     +/
    bool hasPort() @nogc nothrow
    {
        return ada_has_port(_url);
    }

    /++
     + Checks if the URL has a password.
     + Returns: true if a password is present, false otherwise.
     +/
    bool hasPassword() @nogc nothrow
    {
        return ada_has_password(_url);
    }

    /++
     + Checks if the URL has a hash (fragment).
     + Returns: true if a hash is present, false otherwise.
     +/
    bool hasHash() @nogc nothrow
    {
        return ada_has_hash(_url);
    }

    /++
     + Checks if the URL has a search (query) component.
     + Returns: true if a query is present, false otherwise.
     +/
    bool hasSearch() @nogc nothrow
    {
        return ada_has_search(_url);
    }

    /++
     + Retrieves the URL components (e.g., offsets for protocol, host, etc.).
     + Returns: A pointer to the ada_url_components struct.
     +/
    const(ada_url_components)* getComponents() @nogc nothrow
    {
        return ada_get_components(_url);
    }

    private ada_url _url;
}

/++
 + A struct for parsing URLs with optional base URL support.
 +/
struct ParseOptions
{
    /++
     + Constructs a ParseOptions instance by parsing a URL string.
     + Params:
     +   input = The URL string to parse.
     +/
    this(string input) @nogc nothrow
    {
        _url = ada_parse(&input[0], input.length);
    }

    /++
     + Constructs a ParseOptions instance by parsing a URL with a base URL.
     + Params:
     +   input = The URL string to parse.
     +   base = The base URL string for relative URL resolution.
     +/
    this(string input, string base) @nogc nothrow
    {
        _url = ada_parse_with_base(&input[0], input.length, &base[0], base.length);
    }

    /++
     + Retrieves the parsed URL handle.
     + Returns: The ada_url handle.
     +/
    @property ada_url url() @nogc nothrow
    {
        return _url;
    }

    private ada_url _url;
}

/++
 + A struct for managing URL search (query) parameters.
 +/
struct SearchParams
{
    /++
     + Constructs a SearchParams instance from a query string.
     + Params:
     +   input = The query string to parse.
     +/
    this(ref ada_string input) @nogc nothrow
    {
        _str = input;
        _params = ada_parse_search_params(_str.data, _str.length);
    }

    /++
     + Destructor that frees the search parameters and associated iterators.
     +/
    ~this() @nogc nothrow
    {
        ada_free_search_params_keys_iter(keys);
        ada_free_search_params_values_iter(values);
        ada_free_search_params_entries_iter(entries);
        ada_free_search_params(_params);
    }

    /++
     + Appends a key-value pair to the search parameters.
     + Params:
     +   key = The key to append.
     +   value = The value to append.
     +/
    void append(ref string key, ref string value) @nogc nothrow
    {
        ada_search_params_append(_params, &key[0], key.length, &value[0], value.length);
    }

    /++
     + Converts the search parameters to a string.
     + Returns: An ada_owned_string representing the query string.
     +/
    ada_owned_string toString() @nogc nothrow
    {
        return ada_search_params_to_string(_params);
    }

    /++
     + Retrieves the value for a given key.
     + Params:
     +   key = The key to look up.
     + Returns: An ada_string containing the value, or empty if not found.
     +/
    ada_string get(ref string key) @nogc nothrow
    {
        return ada_search_params_get(_params, &key[0], key.length);
    }

    /++
     + Retrieves an iterator for the keys in the search parameters.
     + Returns: An ada_url_search_params_keys_iter for the keys.
     +/
    @property ada_url_search_params_keys_iter keys() @nogc nothrow
    {
        return ada_search_params_get_keys(_params);
    }

    /++
     + Retrieves an iterator for the values in the search parameters.
     + Returns: An ada_url_search_params_values_iter for the values.
     +/
    @property ada_url_search_params_values_iter values() @nogc nothrow
    {
        return ada_search_params_get_values(_params);
    }

    /++
     + Retrieves an iterator for the key-value pairs in the search parameters.
     + Returns: An ada_url_search_params_entries_iter for the entries.
     +/
    @property ada_url_search_params_entries_iter entries() @nogc nothrow
    {
        return ada_search_params_get_entries(_params);
    }

    /++
     + Retrieves all values for a given key.
     + Params:
     +   key = The key to look up.
     + Returns: A Strings struct containing all values for the key.
     +/
    Strings getAll(ref string key) @nogc nothrow
    {
        return Strings(ada_search_params_get_all(_params, &key[0], key.length));
    }

    /++
     + Checks if a key exists in the search parameters.
     + Params:
     +   key = The key to check.
     + Returns: true if the key exists, false otherwise.
     +/
    bool has(ref string key) @nogc nothrow
    {
        return ada_search_params_has(_params, &key[0], key.length);
    }

    /++
     + Checks if a key-value pair exists in the search parameters.
     + Params:
     +   key = The key to check.
     +   value = The value to check.
     + Returns: true if the key-value pair exists, false otherwise.
     +/
    bool hasValue(ref string key, ref string value) @nogc nothrow
    {
        return ada_search_params_has_value(_params, &key[0], key.length, &value[0], value.length);
    }

    /++
     + Retrieves the number of key-value pairs in the search parameters.
     + Returns: The number of pairs.
     +/
    size_t length() @nogc nothrow
    {
        return ada_search_params_size(_params);
    }

    /++
     + Resets the search parameters to the original query string.
     +/
    void reset() @nogc nothrow
    {
        ada_search_params_reset(_params, _str.data, _str.length);
    }

    /++
     + Removes all values for a given key.
     + Params:
     +   key = The key to remove.
     +/
    void remove(ref string key) @nogc nothrow
    {
        ada_search_params_remove(_params, &key[0], key.length);
    }

    /++
     + Removes a specific key-value pair.
     + Params:
     +   key = The key to remove.
     +   value = The value to remove.
     +/
    void removeValue(ref string key, ref string value) @nogc nothrow
    {
        ada_search_params_remove_value(_params, &key[0], key.length, &value[0], value.length);
    }

    /++
     + Sets a key-value pair, replacing any existing values for the key.
     + Params:
     +   key = The key to set.
     +   value = The value to set.
     +/
    void set(ref string key, ref string value) @nogc nothrow
    {
        ada_search_params_set(_params, &key[0], key.length, &value[0], value.length);
    }

    /++
     + Sorts the search parameters by key.
     +/
    void sort() @nogc nothrow
    {
        ada_search_params_sort(_params);
    }

    /++
     + Gets the next key-value pair from a search parameters iterator.
     + Params:
     +   it = The search parameters iterator to get the next pair from.
     + Returns: The next key-value pair in the iterator, or an empty pair if iteration is complete.
     +/
    ada_string_pair itNext(scope ada_url_search_params_entries_iter it) @nogc nothrow
    {
        return ada_search_params_entries_iter_next(it);
    }

    private
    {
        ada_url_search_params _params;
        ada_string _str;
    }
}

/++
 + A struct for managing a collection of strings, typically used for multiple values of a query parameter.
 +/
struct Strings
{
    /++
     + Constructs a Strings instance from an ada_strings collection.
     + Params:
     +   input = The ada_strings collection to manage.
     +/
    this(ref ada_strings input) @nogc nothrow
    {
        _str = input;
    }

    /++
     + Destructor that frees the string collection.
     +/
    ~this() @nogc nothrow
    {
        ada_free_strings(_str);
    }

    /++
     + Retrieves a string at the specified index.
     + Params:
     +   index = The index of the string to retrieve.
     + Returns: The string at the specified index.
     +/
    string getStr(size_t index) @nogc nothrow
    {
        return str_convert(ada_strings_get(_str, index));
    }

    /++
     + Retrieves the raw ada_string data at the specified index.
     + Params:
     +   index = The index of the string to retrieve.
     + Returns: The ada_string at the specified index.
     +/
    ada_string getData(size_t index) @nogc nothrow
    {
        return ada_strings_get(_str, index);
    }

    /++
     + Retrieves the number of strings in the collection.
     + Returns: The number of strings.
     +/
    size_t length() @nogc nothrow
    {
        return ada_strings_size(_str);
    }

    private ada_strings _str;
}

/++
 + Converts an Ada string type (ada_string or ada_owned_string) to a D string.
 + Params:
 +   str = The Ada string to convert.
 + Returns: A D string representing the input.
 +/
string str_convert(T)(ref T str) @trusted @nogc nothrow
{
    // pointer slicing not allowed in safe [checked] functions
    static if (is(T == ada_string) || is(T == ada_owned_string))
        return cast(string)(str.data[0 .. str.length]);
    else
        return cast(string)(str);
}
