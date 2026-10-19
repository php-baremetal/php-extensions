# php-ctype

The character-class checks of PHP's ctype extension, for the PHP that runs on your board: `ctype_digit()`, `ctype_alpha()`, `ctype_alnum()`, `ctype_upper()`, `ctype_lower()`, `ctype_space()`, `ctype_punct()`, `ctype_xdigit()` and the rest. The cheapest extension of the set.

php-ctype is a `bm-php-ext` package: it activates the PHP extension `ctype` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-ctype
```

## Example

```php
<?php
var_dump(ctype_digit('12345'));    // bool(true)
var_dump(ctype_alpha('abc1'));     // bool(false)
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

It has no options.

Cost: About 3 KB of flash and about 2 KB of RAM at startup (measured: +2.5 KB, 1.9 KB).

The PHP manual describes the functions: <https://www.php.net/manual/en/book.ctype.php>.

## License

MIT.
