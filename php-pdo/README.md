# php-pdo

PHP's database access layer for the board: the `PDO` and `PDOStatement` classes, prepared statements and exceptions. PDO alone talks to nothing: add a driver package, such as [php-pdo_sqlite](package:php-baremetal/php-pdo_sqlite), which requires this one.

php-pdo is a `bm-php-ext` package: it activates the PHP extension `pdo` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-pdo
```

## Example

```php
<?php
var_dump(PDO::getAvailableDrivers());   // lists the drivers built in, e.g. ['sqlite']
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

It has no options.

Cost: About 55 KB of flash and about 47 KB of RAM at startup (measured: +56 KB, 46.7 KB).

The PHP manual describes the functions: <https://www.php.net/manual/en/book.pdo.php>.

## License

MIT.
