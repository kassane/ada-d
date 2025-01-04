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

module c.ada;

@nogc nothrow @safe extern (C)
{
    // string that is owned by the ada_url instance
    struct ada_string
    {
        const(char)* data = void;
        ulong length = void;
    }

    // string that must be freed by the caller
    struct ada_owned_string
    {
        const(char)* data = void;
        ulong length = void;
    }

    struct ada_url_components
    {
        uint protocol_end = void;
        uint username_end = void;
        uint host_start = void;
        uint host_end = void;
        uint port = void;
        uint pathname_start = void;
        uint search_start = void;
        uint hash_start = void;
    }

    // This is a reference to ada::url_components::omitted
    // It represents "uint32_t(-1)"
    enum uint ada_url_omitted = 0xffffffff;

    alias ada_url = void*;

    // input should be a null terminated C string (ASCII or UTF-8)
    // you must call ada_free on the returned pointer
    ada_url ada_parse(scope const(char)* input, ulong length) @trusted;
    ada_url ada_parse_with_base(scope const(char)* input, ulong input_length, scope const(char)* base, ulong base_length) @trusted;

    // input and base should be a null terminated C strings
    bool ada_can_parse(scope const(char)* input, ulong length) @trusted;
    bool ada_can_parse_with_base(scope const(char)* input, ulong input_length, scope const(char)* base, ulong base_length) @trusted;
    void ada_free(scope ada_url result) @trusted;
    void ada_free_owned_string(ada_owned_string owned) @trusted;
    ada_url ada_copy(scope ada_url input) @trusted;
    bool ada_is_valid(scope ada_url result) @trusted;

    // url_aggregator getters
    // if ada_is_valid(result)) is false, an empty string is returned
    ada_owned_string ada_get_origin(scope ada_url result) @trusted;
    ada_string ada_get_href(scope ada_url result) @trusted;
    ada_string ada_get_username(scope ada_url result) @trusted;
    ada_string ada_get_password(scope ada_url result) @trusted;
    ada_string ada_get_port(scope ada_url result) @trusted;
    ada_string ada_get_hash(scope ada_url result) @trusted;
    ada_string ada_get_host(scope ada_url result) @trusted;
    ada_string ada_get_hostname(scope ada_url result) @trusted;
    ada_string ada_get_pathname(scope ada_url result) @trusted;
    ada_string ada_get_search(scope ada_url result) @trusted;
    ada_string ada_get_protocol(scope ada_url result) @trusted;
    ubyte ada_get_host_type(scope ada_url result) @trusted;
    ubyte ada_get_scheme_type(scope ada_url result) @trusted;

    // url_aggregator setters
    // if ada_is_valid(result)) is false, the setters have no effect
    // input should be a null terminated C string
    bool ada_set_href(scope ada_url result, scope const(char)* input, ulong length) @trusted;
    bool ada_set_host(scope ada_url result, scope const(char)* input, ulong length) @trusted;
    bool ada_set_hostname(scope ada_url result, scope const(char)* input, ulong length) @trusted;
    bool ada_set_protocol(scope ada_url result, scope const(char)* input, ulong length) @trusted;
    bool ada_set_username(scope ada_url result, scope const(char)* input, ulong length) @trusted;
    bool ada_set_password(scope ada_url result, scope const(char)* input, ulong length) @trusted;
    bool ada_set_port(scope ada_url result, scope const(char)* input, ulong length) @trusted;
    bool ada_set_pathname(scope ada_url result, scope const(char)* input, ulong length) @trusted;
    void ada_set_search(scope ada_url result, scope const(char)* input, ulong length) @trusted;
    void ada_set_hash(scope ada_url result, scope const(char)* input, ulong length) @trusted;

    // url_aggregator clear methods
    void ada_clear_port(scope ada_url result) @trusted;
    void ada_clear_hash(scope ada_url result) @trusted;
    void ada_clear_search(scope ada_url result) @trusted;

    // url_aggregator functions
    // if ada_is_valid(result) is false, functions below will return false
    bool ada_has_credentials(scope ada_url result) @trusted;
    bool ada_has_empty_hostname(scope ada_url result) @trusted;
    bool ada_has_hostname(scope ada_url result) @trusted;
    bool ada_has_non_empty_username(scope ada_url result) @trusted;
    bool ada_has_non_empty_password(scope ada_url result) @trusted;
    bool ada_has_port(scope ada_url result) @trusted;
    bool ada_has_password(scope ada_url result) @trusted;
    bool ada_has_hash(scope ada_url result) @trusted;
    bool ada_has_search(scope ada_url result) @trusted;

    // returns a pointer to the internal url_aggregator::url_components
    const(ada_url_components)* ada_get_components(scope ada_url result) @trusted;

    // idna methods
    ada_owned_string ada_idna_to_unicode(scope const(char)* input, ulong length) @trusted;
    ada_owned_string ada_idna_to_ascii(scope const(char)* input, ulong length) @trusted;

    // url search params
    alias ada_url_search_params = void*;

    // Represents an std::vector<std::string>
    alias ada_strings = void*;
    alias ada_url_search_params_keys_iter = void*;
    alias ada_url_search_params_values_iter = void*;
    struct ada_string_pair
    {
        ada_string key = void;
        ada_string value = void;
    }

    alias ada_url_search_params_entries_iter = void*;
    ada_url_search_params_keys_iter ada_parse_search_params(scope const(char)* input, ulong length) @trusted;
    void ada_free_search_params(scope ada_url result) @trusted;
    ulong ada_search_params_size(scope ada_url result) @trusted;
    void ada_search_params_sort(scope ada_url result) @trusted;
    ada_owned_string ada_search_params_to_string(scope ada_url result) @trusted;
    void ada_search_params_append(scope ada_url result, scope const(char)* key, ulong key_length, scope const(
            char)* value, ulong value_length) @trusted;
    void ada_search_params_set(scope ada_url result, scope const(char)* key, ulong key_length, scope const(
            char)* value, ulong value_length) @trusted;
    void ada_search_params_remove(scope ada_url result, scope const(char)* key, ulong key_length) @trusted;
    void ada_search_params_remove_value(scope ada_url result, scope const(char)* key, ulong key_length, const(
            char)* value, ulong value_length) @trusted;
    bool ada_search_params_has(scope ada_url result, scope const(char)* key, ulong key_length) @trusted;
    bool ada_search_params_has_value(scope ada_url result, scope const(char)* key, ulong key_length, scope const(
            char)* value, ulong value_length) @trusted;
    ada_string ada_search_params_get(scope ada_url result, scope const(char)* key, ulong key_length) @trusted;
    ada_url_search_params_keys_iter ada_search_params_get_all(scope ada_url result, scope const(
            char)* key, ulong key_length) @trusted;
    void ada_search_params_reset(scope ada_url result, scope const(char)* input, ulong length) @trusted;
    ada_url_search_params_keys_iter ada_search_params_get_keys(scope ada_url result) @trusted;
    ada_url_search_params_keys_iter ada_search_params_get_values(scope ada_url result) @trusted;
    ada_url_search_params_keys_iter ada_search_params_get_entries(scope ada_url result) @trusted;
    void ada_free_strings(scope ada_url result) @trusted;
    ulong ada_strings_size(scope ada_url result) @trusted;
    ada_string ada_strings_get(scope ada_url result, ulong index) @trusted;
    void ada_free_search_params_keys_iter(scope ada_url result) @trusted;
    ada_string ada_search_params_keys_iter_next(scope ada_url result) @trusted;
    bool ada_search_params_keys_iter_has_next(scope ada_url result) @trusted;
    void ada_free_search_params_values_iter(scope ada_url result) @trusted;
    ada_string ada_search_params_values_iter_next(scope ada_url result) @trusted;
    bool ada_search_params_values_iter_has_next(scope ada_url result) @trusted;
    void ada_free_search_params_entries_iter(scope ada_url result) @trusted;
    ada_string_pair ada_search_params_entries_iter_next(scope ada_url result) @trusted;
    bool ada_search_params_entries_iter_has_next(scope ada_url result) @trusted;
}
