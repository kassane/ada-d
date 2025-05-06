/*
 * Copyright 2025 Matheus C. França
 *
 * Licensed under the Apache License, Version 2.0 (the "License") @trusted;
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

module ada.c.ada;

@nogc nothrow @safe extern (C)
{
   /++
 + A struct representing a string owned by the ada_url instance.
 + The string is managed by the Ada library and does not require manual freeing.
 +/
   struct ada_string
   {
      const(char)* data = void; /// Pointer to the string data.
      size_t length = void; /// Length of the string.
   }

   /++
 + A struct representing a string that must be freed by the caller.
 + Typically used for strings returned by the Ada library that require manual memory management.
 +/
   struct ada_owned_string
   {
      const(char)* data = void; /// Pointer to the string data.
      size_t length = void; /// Length of the string.
   }

   /++
 + A struct representing the components of a parsed URL.
 + Each field indicates the position or value of a URL component, with `ada_url_omitted` indicating an absent component.
 +/
   struct ada_url_components
   {
      uint protocol_end = void; /// End position of the protocol (e.g., after "http:").
      uint username_end = void; /// End position of the username.
      uint host_start = void; /// Start position of the host.
      uint host_end = void; /// End position of the host.
      uint port = void; /// Port number, or `ada_url_omitted` if not present.
      uint pathname_start = void; /// Start position of the pathname.
      uint search_start = void; /// Start position of the search (query) component.
      uint hash_start = void; /// Start position of the hash (fragment) component.
   }

   /++
 + A struct representing a key-value pair in search parameters.
 +/
   struct ada_string_pair
   {
      ada_string key = void; /// The key string.
      ada_string value = void; /// The value string.
   }

   /++
 + A constant representing an omitted URL component.
 + Equivalent to `uint32_t(-1)` in the Ada library, used in `ada_url_components` to indicate absence.
 +/
   enum uint ada_url_omitted = 0xffffffff;

   /++
 + An opaque pointer type representing a parsed URL in the Ada library.
 +/
   alias ada_url = void*;

   /++
 + An opaque pointer type representing URL search (query) parameters in the Ada library.
 +/
   alias ada_url_search_params = void*;

   /++
 + An opaque pointer type representing a collection of strings (e.g., multiple values for a query parameter).
 +/
   alias ada_strings = void*;

   /++
 + An opaque pointer type representing an iterator over search parameter keys.
 +/
   alias ada_url_search_params_keys_iter = void*;

   /++
 + An opaque pointer type representing an iterator over search parameter values.
 +/
   alias ada_url_search_params_values_iter = void*;

   /++
 + An opaque pointer type representing an iterator over search parameter key-value pairs.
 +/
   alias ada_url_search_params_entries_iter = void*;

   /++
 + Parses a URL string and returns a handle to the parsed URL.
 + The input must be a null-terminated C string (ASCII or UTF-8).
 + Params:
 +   input = The URL string to parse.
 +   length = The length of the input string.
 + Returns: An `ada_url` handle, which must be freed with `ada_free`.
 +/
   ada_url ada_parse(scope const(char)* input, size_t length) @trusted;

   /++
 + Parses a URL string with a base URL for relative URL resolution.
 + Both input and base must be null-terminated C strings (ASCII or UTF-8).
 + Params:
 +   input = The URL string to parse.
 +   input_length = The length of the input string.
 +   base = The base URL string.
 +   base_length = The length of the base URL string.
 + Returns: An `ada_url` handle, which must be freed with `ada_free`.
 +/
   ada_url ada_parse_with_base(scope const(char)* input, size_t input_length, scope const(char)* base, size_t base_length) @trusted;

   /++
 + Checks if a URL string can be parsed.
 + The input must be a null-terminated C string (ASCII or UTF-8).
 + Params:
 +   input = The URL string to check.
 +   length = The length of the input string.
 + Returns: true if the URL can be parsed, false otherwise.
 +/
   bool ada_can_parse(scope const(char)* input, size_t length) @trusted;

   /++
 + Checks if a URL string can be parsed with a base URL.
 + Both input and base must be null-terminated C strings (ASCII or UTF-8).
 + Params:
 +   input = The URL string to check.
 +   input_length = The length of the input string.
 +   base = The base URL string.
 +   base_length = The length of the base URL string.
 + Returns: true if the URL can be parsed, false otherwise.
 +/
   bool ada_can_parse_with_base(scope const(char)* input, size_t input_length, scope const(char)* base, size_t base_length) @trusted;

   /++
 + Frees the resources associated with a parsed URL.
 + Params:
 +   result = The `ada_url` handle to free.
 +/
   void ada_free(scope ada_url result) @trusted;

   /++
 + Frees the resources associated with an owned string.
 + Params:
 +   owned = The `ada_owned_string` to free.
 +/
   void ada_free_owned_string(ada_owned_string owned) @trusted;

   /++
 + Creates a copy of a parsed URL.
 + Params:
 +   input = The `ada_url` handle to copy.
 + Returns: A new `ada_url` handle, which must be freed with `ada_free`.
 +/
   ada_url ada_copy(scope ada_url input) @trusted;

   /++
 + Checks if a parsed URL is valid.
 + Params:
 +   result = The `ada_url` handle to check.
 + Returns: true if the URL is valid, false otherwise.
 +/
   bool ada_is_valid(scope ada_url result) @trusted;

   /++
 + Retrieves the origin of a parsed URL (e.g., protocol + host + port).
 + Returns an empty string if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: An `ada_owned_string` containing the origin, which must be freed with `ada_free_owned_string`.
 +/
   ada_owned_string ada_get_origin(scope ada_url result) @trusted;

   /++
 + Retrieves the full URL (href) as a string.
 + Returns an empty string if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: An `ada_string` containing the href.
 +/
   ada_string ada_get_href(scope ada_url result) @trusted;

   /++
 + Retrieves the username component of a parsed URL.
 + Returns an empty string if the URL is invalid or no username is present.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: An `ada_string` containing the username.
 +/
   ada_string ada_get_username(scope ada_url result) @trusted;

   /++
 + Retrieves the password component of a parsed URL.
 + Returns an empty string if the URL is invalid or no password is present.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: An `ada_string` containing the password.
 +/
   ada_string ada_get_password(scope ada_url result) @trusted;

   /++
 + Retrieves the port component of a parsed URL.
 + Returns an empty string if the URL is invalid or no port is present.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: An `ada_string` containing the port.
 +/
   ada_string ada_get_port(scope ada_url result) @trusted;

   /++
 + Retrieves the hash (fragment) component of a parsed URL.
 + Returns an empty string if the URL is invalid or no hash is present.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: An `ada_string` containing the hash.
 +/
   ada_string ada_get_hash(scope ada_url result) @trusted;

   /++
 + Retrieves the host component of a parsed URL (hostname + port).
 + Returns an empty string if the URL is invalid or no host is present.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: An `ada_string` containing the host.
 +/
   ada_string ada_get_host(scope ada_url result) @trusted;

   /++
 + Retrieves the hostname component of a parsed URL.
 + Returns an empty string if the URL is invalid or no hostname is present.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: An `ada_string` containing the hostname.
 +/
   ada_string ada_get_hostname(scope ada_url result) @trusted;

   /++
 + Retrieves the pathname component of a parsed URL.
 + Returns an empty string if the URL is invalid or no pathname is present.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: An `ada_string` containing the pathname.
 +/
   ada_string ada_get_pathname(scope ada_url result) @trusted;

   /++
 + Retrieves the search (query) component of a parsed URL.
 + Returns an empty string if the URL is invalid or no search is present.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: An `ada_string` containing the search.
 +/
   ada_string ada_get_search(scope ada_url result) @trusted;

   /++
 + Retrieves the protocol component of a parsed URL (e.g., "http:").
 + Returns an empty string if the URL is invalid or no protocol is present.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: An `ada_string` containing the protocol.
 +/
   ada_string ada_get_protocol(scope ada_url result) @trusted;

   /++
 + Retrieves the host type of a parsed URL.
 + Returns an undefined value if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: A ubyte representing the host type (as defined by the Ada library).
 +/
   ubyte ada_get_host_type(scope ada_url result) @trusted;

   /++
 + Retrieves the scheme type of a parsed URL.
 + Returns an undefined value if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: A ubyte representing the scheme type (as defined by the Ada library).
 +/
   ubyte ada_get_scheme_type(scope ada_url result) @trusted;

   /++
 + Sets the full URL (href) of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +   input = The new URL string (null-terminated C string).
 +   length = The length of the input string.
 + Returns: true if successful, false otherwise.
 +/
   bool ada_set_href(scope ada_url result, scope const(char)* input, size_t length) @trusted;

   /++
 + Sets the host component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +   input = The new host string (null-terminated C string).
 +   length = The length of the input string.
 + Returns: true if successful, false otherwise.
 +/
   bool ada_set_host(scope ada_url result, scope const(char)* input, size_t length) @trusted;

   /++
 + Sets the hostname component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +   input = The new hostname string (null-terminated C string).
 +   length = The length of the input string.
 + Returns: true if successful, false otherwise.
 +/
   bool ada_set_hostname(scope ada_url result, scope const(char)* input, size_t length) @trusted;

   /++
 + Sets the protocol component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +   input = The new protocol string (null-terminated C string, e.g., "http:").
 +   length = The length of the input string.
 + Returns: true if successful, false otherwise.
 +/
   bool ada_set_protocol(scope ada_url result, scope const(char)* input, size_t length) @trusted;

   /++
 + Sets the username component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +   input = The new username string (null-terminated C string).
 +   length = The length of the input string.
 + Returns: true if successful, false otherwise.
 +/
   bool ada_set_username(scope ada_url result, scope const(char)* input, size_t length) @trusted;

   /++
 + Sets the password component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +   input = The new password string (null-terminated C string).
 +   length = The length of the input string.
 + Returns: true if successful, false otherwise.
 +/
   bool ada_set_password(scope ada_url result, scope const(char)* input, size_t length) @trusted;

   /++
 + Sets the port component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +   input = The new port string (null-terminated C string).
 +   length = The length of the input string.
 + Returns: true if successful, false otherwise.
 +/
   bool ada_set_port(scope ada_url result, scope const(char)* input, size_t length) @trusted;

   /++
 + Sets the pathname component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +   input = The new pathname string (null-terminated C string).
 +   length = The length of the input string.
 + Returns: true if successful, false otherwise.
 +/
   bool ada_set_pathname(scope ada_url result, scope const(char)* input, size_t length) @trusted;

   /++
 + Sets the search (query) component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +   input = The new search string (null-terminated C string).
 +   length = The length of the input string.
 +/
   void ada_set_search(scope ada_url result, scope const(char)* input, size_t length) @trusted;

   /++
 + Sets the hash (fragment) component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +   input = The new hash string (null-terminated C string).
 +   length = The length of the input string.
 +/
   void ada_set_hash(scope ada_url result, scope const(char)* input, size_t length) @trusted;

   /++
 + Clears the port component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +/
   void ada_clear_port(scope ada_url result) @trusted;

   /++
 + Clears the hash (fragment) component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +/
   void ada_clear_hash(scope ada_url result) @trusted;

   /++
 + Clears the search (query) component of a parsed URL.
 + Has no effect if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 +/
   void ada_clear_search(scope ada_url result) @trusted;

   /++
 + Checks if a parsed URL has credentials (username or password).
 + Returns false if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: true if credentials are present, false otherwise.
 +/
   bool ada_has_credentials(scope ada_url result) @trusted;

   /++
 + Checks if a parsed URL has an empty hostname.
 + Returns false if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: true if the hostname is empty, false otherwise.
 +/
   bool ada_has_empty_hostname(scope ada_url result) @trusted;

   /++
 + Checks if a parsed URL has a hostname.
 + Returns false if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: true if a hostname is present, false otherwise.
 +/
   bool ada_has_hostname(scope ada_url result) @trusted;

   /++
 + Checks if a parsed URL has a non-empty username.
 + Returns false if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: true if the username is non-empty, false otherwise.
 +/
   bool ada_has_non_empty_username(scope ada_url result) @trusted;

   /++
 + Checks if a parsed URL has a non-empty password.
 + Returns false if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: true if the password is non-empty, false otherwise.
 +/
   bool ada_has_non_empty_password(scope ada_url result) @trusted;

   /++
 + Checks if a parsed URL has a port.
 + Returns false if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: true if a port is present, false otherwise.
 +/
   bool ada_has_port(scope ada_url result) @trusted;

   /++
 + Checks if a parsed URL has a password.
 + Returns false if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: true if a password is present, false otherwise.
 +/
   bool ada_has_password(scope ada_url result) @trusted;

   /++
 + Checks if a parsed URL has a hash (fragment).
 + Returns false if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: true if a hash is present, false otherwise.
 +/
   bool ada_has_hash(scope ada_url result) @trusted;

   /++
 + Checks if a parsed URL has a search (query) component.
 + Returns false if the URL is invalid.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: true if a search is present, false otherwise.
 +/
   bool ada_has_search(scope ada_url result) @trusted;

   /++
 + Retrieves the internal components of a parsed URL.
 + Params:
 +   result = The `ada_url` handle.
 + Returns: A pointer to the `ada_url_components` struct, or null if the URL is invalid.
 +/
   scope ada_url_components* ada_get_components(scope ada_url result) @trusted;

   /++
 + Converts an IDNA-encoded string to Unicode.
 + Params:
 +   input = The input string (null-terminated C string).
 +   length = The length of the input string.
 + Returns: An `ada_owned_string` containing the Unicode string, which must be freed with `ada_free_owned_string`.
 +/
   ada_owned_string ada_idna_to_unicode(scope const(char)* input, size_t length) @trusted;

   /++
 + Converts a Unicode string to IDNA-encoded ASCII.
 + Params:
 +   input = The input string (null-terminated C string).
 +   length = The length of the input string.
 + Returns: An `ada_owned_string` containing the ASCII string, which must be freed with `ada_free_owned_string`.
 +/
   ada_owned_string ada_idna_to_ascii(scope const(char)* input, size_t length) @trusted;

   /++
 + Parses a query string into search parameters.
 + Params:
 +   input = The query string (null-terminated C string).
 +   length = The length of the input string.
 + Returns: An `ada_url_search_params` handle, which must be freed with `ada_free_search_params`.
 +/
   ada_url_search_params ada_parse_search_params(scope const(char)* input, size_t length) @trusted;

   /++
 + Frees the resources associated with search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle to free.
 +/
   void ada_free_search_params(scope ada_url_search_params result) @trusted;

   /++
 + Retrieves the number of key-value pairs in search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle.
 + Returns: The number of pairs.
 +/
   size_t ada_search_params_size(scope ada_url_search_params result) @trusted;

   /++
 + Sorts the search parameters by key.
 + Params:
 +   result = The `ada_url_search_params` handle.
 +/
   void ada_search_params_sort(scope ada_url_search_params result) @trusted;

   /++
 + Converts search parameters to a query string.
 + Params:
 +   result = The `ada_url_search_params` handle.
 + Returns: An `ada_owned_string` containing the query string, which must be freed with `ada_free_owned_string`.
 +/
   ada_owned_string ada_search_params_to_string(scope ada_url_search_params result) @trusted;

   /++
 + Appends a key-value pair to search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle.
 +   key = The key string (null-terminated C string).
 +   key_length = The length of the key string.
 +   value = The value string (null-terminated C string).
 +   value_length = The length of the value string.
 +/
   void ada_search_params_append(scope ada_url_search_params result, scope const(char)* key, size_t key_length, const(
         char)* value, size_t value_length) @trusted;

   /++
 + Sets a key-value pair in search parameters, replacing any existing values for the key.
 + Params:
 +   result = The `ada_url_search_params` handle.
 +   key = The key string (null-terminated C string).
 +   key_length = The length of the key string.
 +   value = The value string (null-terminated C string).
 +   value_length = The length of the value string.
 +/
   void ada_search_params_set(scope ada_url_search_params result, scope const(char)* key, size_t key_length, const(
         char)* value, size_t value_length) @trusted;

   /++
 + Removes all values for a given key in search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle.
 +   key = The key string (null-terminated C string).
 +   key_length = The length of the key string.
 +/
   void ada_search_params_remove(scope ada_url_search_params result, scope const(char)* key, size_t key_length) @trusted;

   /++
 + Removes a specific key-value pair from search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle.
 +   key = The key string (null-terminated C string).
 +   key_length = The length of the key string.
 +   value = The value string (null-terminated C string).
 +   value_length = The length of the value string.
 +/
   void ada_search_params_remove_value(scope ada_url_search_params result, scope const(char)* key, size_t key_length, const(
         char)* value, size_t value_length) @trusted;

   /++
 + Checks if a key exists in search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle.
 +   key = The key string "::" (null-terminated C string).
 +   key_length = The length of the key string.
 + Returns: true if the key exists, false otherwise.
 +/
   bool ada_search_params_has(scope ada_url_search_params result, scope const(char)* key, size_t key_length) @trusted;

   /++
 + Checks if a key-value pair exists in search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle.
 +   key = The key string (null-terminated C string).
 +   key_length = The length of the key string.
 +   value = The value string (null-terminated C string).
 +   value_length = The length of the value string.
 + Returns: true if the key-value pair exists, false otherwise.
 +/
   bool ada_search_params_has_value(scope ada_url_search_params result, scope const(char)* key, size_t key_length, const(
         char)* value, size_t value_length) @trusted;

   /++
 + Retrieves the value for a given key in search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle.
 +   key = The key string (null-terminated C string).
 +   key_length = The length of the key string.
 + Returns: An `ada_string` containing the value, or empty if not found.
 +/
   ada_string ada_search_params_get(scope ada_url_search_params result, scope const(char)* key, size_t key_length) @trusted;

   /++
 + Retrieves all values for a given key in search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle.
 +   key = The key string (null-terminated C string).
 +   key_length = The length of the key string.
 + Returns: An `ada_strings` handle containing all values, which must be freed with `ada_free_strings`.
 +/
   ada_strings ada_search_params_get_all(scope ada_url_search_params result, scope const(char)* key, size_t key_length) @trusted;

   /++
 + Resets search parameters to a new query string.
 + Params:
 +   result = The `ada_url_search_params` handle.
 +   input = The new query string (null-terminated C string).
 +   length = The length of the input string.
 +/
   void ada_search_params_reset(scope ada_url_search_params result, scope const(char)* input, size_t length) @trusted;

   /++
 + Retrieves an iterator for the keys in search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle.
 + Returns: An `ada_url_search_params_keys_iter` handle, which must be freed with `ada_free_search_params_keys_iter`.
 +/
   ada_url_search_params_keys_iter ada_search_params_get_keys(scope ada_url_search_params result) @trusted;

   /++
 + Retrieves an iterator for the values in search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle.
 + Returns: An `ada_url_search_params_values_iter` handle, which must be freed with `ada_free_search_params_values_iter`.
 +/
   ada_url_search_params_values_iter ada_search_params_get_values(scope ada_url_search_params result) @trusted;

   /++
 + Retrieves an iterator for the key-value pairs in search parameters.
 + Params:
 +   result = The `ada_url_search_params` handle.
 + Returns: An `ada_url_search_params_entries_iter` handle, which must be freed with `ada_free_search_params_entries_iter`.
 +/
   ada_url_search_params_entries_iter ada_search_params_get_entries(
      scope ada_url_search_params result) @trusted;

   /++
 + Frees the resources associated with a string collection.
 + Params:
 +   result = The `ada_strings` handle to free.
 +/
   void ada_free_strings(ada_strings result) @trusted;

   /++
 + Retrieves the number of strings in a collection.
 + Params:
 +   result = The `ada_strings` handle.
 + Returns: The number of strings.
 +/
   size_t ada_strings_size(ada_strings result) @trusted;

   /++
 + Retrieves a string at a specific index in a collection.
 + Params:
 +   result = The `ada_strings` handle.
 +   index = The index of the string to retrieve.
 + Returns: An `ada_string` containing the string at the specified index.
 +/
   ada_string ada_strings_get(ada_strings result, size_t index) @trusted;

   /++
 + Frees the resources associated with a search parameters keys iterator.
 + Params:
 +   result = The `ada_url_search_params_keys_iter` handle to free.
 +/
   void ada_free_search_params_keys_iter(scope ada_url_search_params_keys_iter result) @trusted;

   /++
 + Retrieves the next key from a search parameters keys iterator.
 + Params:
 +   result = The `ada_url_search_params_keys_iter` handle.
 + Returns: An `ada_string` containing the next key, or empty if no more keys.
 +/
   ada_string ada_search_params_keys_iter_next(scope ada_url_search_params_keys_iter result) @trusted;

   /++
 + Checks if there are more keys in a search parameters keys iterator.
 + Params:
 +   result = The `ada_url_search_params_keys_iter` handle.
 + Returns: true if there are more keys, false otherwise.
 +/
   bool ada_search_params_keys_iter_has_next(scope ada_url_search_params_keys_iter result) @trusted;

   /++
 + Frees the resources associated with a search parameters values iterator.
 + Params:
 +   result = The `ada_url_search_params_values_iter` handle to free.
 +/
   void ada_free_search_params_values_iter(scope ada_url_search_params_values_iter result) @trusted;

   /++
 + Retrieves the next value from a search parameters values iterator.
 + Params:
 +   result = The `ada_url_search_params_values_iter` handle.
 + Returns: An `ada_string` containing the next value, or empty if no more values.
 +/
   ada_string ada_search_params_values_iter_next(scope ada_url_search_params_values_iter result) @trusted;

   /++
 + Checks if there are more values in a search parameters values iterator.
 + Params:
 +   result = The `ada_url_search_params_values_iter` handle.
 + Returns: true if there are more values, false otherwise.
 +/
   bool ada_search_params_values_iter_has_next(scope ada_url_search_params_values_iter result) @trusted;

   /++
 + Frees the resources associated with a search parameters entries iterator.
 + Params:
 +   result = The `ada_url_search_params_entries_iter` handle to free.
 +/
   void ada_free_search_params_entries_iter(scope ada_url_search_params_entries_iter result) @trusted;

   /++
 + Retrieves the next key-value pair from a search parameters entries iterator.
 + Params:
 +   result = The `ada_url_search_params_entries_iter` handle.
 + Returns: An `ada_string_pair` containing the next key-value pair, or empty if no more entries.
 +/
   ada_string_pair ada_search_params_entries_iter_next(
      scope ada_url_search_params_entries_iter result) @trusted;

   /++
 + Checks if there are more key-value pairs in a search parameters entries iterator.
 + Params:
 +   result = The `ada_url_search_params_entries_iter` handle.
 + Returns: true if there are more entries, false otherwise.
 +/
   bool ada_search_params_entries_iter_has_next(scope ada_url_search_params_entries_iter result) @trusted;
}
