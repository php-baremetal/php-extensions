# php-filter

PHP's filter extension for the board: `filter_var()`, `filter_var_array()`, `filter_input()` and the `FILTER_*` constants, to validate and sanitise values such as e-mail addresses, URLs, integers and IP addresses. Handy for the query string and form data of a web-server project.

php-filter is a `bm-php-ext` package: it activates the PHP extension `filter` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-filter
```

## Example

```php
<?php
var_dump(filter_var('42', FILTER_VALIDATE_INT));                  // int(42)
var_dump(filter_var('not an ip', FILTER_VALIDATE_IP));            // bool(false)
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

It has no options.

Cost: About 20 KB of flash and about 22 KB of RAM at startup (measured: +20 KB, 21.6 KB).

The PHP manual describes the functions: <https://www.php.net/manual/en/book.filter.php>.

## License

MIT.
