# php-opcache

Zend OPcache for the board: compiled scripts are kept in a bytecode cache in PSRAM, so a script that runs again (every request of a `web-server` project, every `require` of the same file) skips the compile step. No JIT, and nothing is written to flash. Measured on a web project, a request went from 41-48 ms to 24-28 ms.

php-opcache is a `bm-php-ext` package: it activates the PHP extension `opcache` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-opcache
```

Needs: A board with 4 MB of PSRAM or more. Below that OPcache is disabled at boot and the script runs uncached.

## Example

```php
<?php
// Nothing to call: with the package built in, scripts are cached on first use.
var_dump(function_exists('opcache_get_status'));
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

Options, set under `extra.baremetal.options` of the project `composer.json`:

| Option | Type | Default | Effect |
| --- | --- | --- | --- |
| `opcache-memory` | int, 256 to 16384 | `1024` | Kilobytes of PSRAM for the bytecode cache, taken from PHP's `memory_limit` (OPcache allocates about 64 KB more besides it). |
| `opcache-validate` | bool | `false` | With `microsd` storage, check the scripts' timestamps (`opcache.validate_timestamps`), for PHP files the program writes on the card. Off, the sources change only with a flash or a sync, which restart the board. Always off with `embedded` storage. |

```json
{
  "extra": {
    "baremetal": {
      "options": {
        "opcache-memory": 2048
      }
    }
  }
}
```

Cost: About 280 KB of flash, about 62 KB of RAM at startup, plus `opcache-memory` KB of PSRAM taken from `memory_limit` (measured: +277 KB, 61.5 KB).

## Notes

- FAT stores modification times with a 2-second resolution, and without a set clock every file gets the same 1980 time, so with `opcache-validate` on, a file rewritten within 2 seconds or while the clock is unset may not be detected.

The PHP manual describes the functions: <https://www.php.net/manual/en/book.opcache.php>.

## License

MIT.
