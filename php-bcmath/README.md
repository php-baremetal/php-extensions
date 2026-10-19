# php-bcmath

Arbitrary-precision decimal math for the PHP that runs on your board: `bcadd()`, `bcsub()`, `bcmul()`, `bcdiv()`, `bcmod()`, `bcpow()`, `bcsqrt()`, `bccomp()` and `bcscale()`, on numbers kept as strings. Use it where floats round wrongly, such as money.

php-bcmath is a `bm-php-ext` package: it activates the PHP extension `bcmath` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-bcmath
```

## Example

```php
<?php
echo bcadd('0.1', '0.2', 1), "\n";   // 0.3
echo bcmul('1234567890123456789', '987654321987654321'), "\n";
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

It has no options.

Cost: About 25 KB of flash and about 8 KB of RAM at startup (measured: +23 KB, 7.1 KB).

The PHP manual describes the functions: <https://www.php.net/manual/en/book.bcmath.php>.

## License

MIT.
