# php-zlib

Compression for the board: `gzcompress()`, `gzuncompress()`, `gzencode()`, `gzdecode()`, `gzdeflate()`, `gzinflate()`, `zlib_encode()` and the `compress.zlib://` stream wrapper. The library is the Espressif port of zlib.

php-zlib is a `bm-php-ext` package: it activates the PHP extension `zlib` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-zlib
```

Needs: The ESP-IDF component `espressif/zlib` pinned to `==1.3.2~1`, which the build downloads from the ESP component registry.

## Example

```php
<?php
$packed = gzcompress(str_repeat('abc', 1000), 9);
echo strlen($packed), " bytes\n";
var_dump(strlen(gzuncompress($packed)));   // int(3000)
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

It has no options.

Cost: About 56 KB of flash with the zlib library and about 25 KB of RAM at startup (measured: +55.5 KB, 25 KB). Compression needs about 260 KB of `memory_limit` while it runs.

The PHP manual describes the functions: <https://www.php.net/manual/en/book.zlib.php>.

## License

MIT.
