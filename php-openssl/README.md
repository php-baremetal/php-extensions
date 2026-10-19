# php-openssl

A partial `openssl` extension for the board, built on the mbedTLS that ships with ESP-IDF: `openssl_encrypt()` and `openssl_decrypt()` with AES-128, AES-192 and AES-256 in CBC, CTR and GCM modes (and the common OpenSSL cipher aliases), `openssl_digest()`, `openssl_random_pseudo_bytes()`, `openssl_cipher_iv_length()`, `openssl_cipher_key_length()`, `openssl_get_cipher_methods()`, `openssl_get_md_methods()` and `openssl_error_string()`. There are no keys, signatures, X.509 or TLS, and the only constants defined are `OPENSSL_RAW_DATA`, `OPENSSL_ZERO_PADDING` and `OPENSSL_DONT_ZERO_PAD_KEY`.

php-openssl is a `bm-php-ext` package: it activates the PHP extension `openssl` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-openssl
```

Needs: The ESP-IDF component `mbedtls`, which the build adds on its own.

## Example

```php
<?php
$key = openssl_random_pseudo_bytes(32);
$iv  = openssl_random_pseudo_bytes(openssl_cipher_iv_length('aes-256-cbc'));
$enc = openssl_encrypt('secret', 'aes-256-cbc', $key, OPENSSL_RAW_DATA, $iv);
var_dump(openssl_decrypt($enc, 'aes-256-cbc', $key, OPENSSL_RAW_DATA, $iv));   // string(6) "secret"
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

It has no options.

Cost: About 85 KB of flash with the mbedTLS code it links (measured without a network) and about 5 KB of RAM at startup.

## Notes

- GCM authentication tags are accepted at 4, 8 and 12 to 16 bytes only.
- Full OpenSSL and TLS are outside the first release.

The PHP manual describes the functions: <https://www.php.net/manual/en/book.openssl.php>.

## License

MIT.
