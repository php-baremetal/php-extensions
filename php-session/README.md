# php-session

PHP sessions for the board: `session_start()`, `$_SESSION` and the rest of the session API, mostly for `web-server` projects. The default handler keeps sessions in memory (at most 64 sessions, 64 KB in all, least recently used first, in PSRAM outside `memory_limit`). With `microsd` storage the `files` handler stores them in `/sdcard/sessions`, so they survive a reset.

php-session is a `bm-php-ext` package: it activates the PHP extension `session` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-session
```

## Example

```php
<?php
session_start();
$_SESSION['hits'] = ($_SESSION['hits'] ?? 0) + 1;
echo 'visit #', $_SESSION['hits'], "\n";
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

It has no options.

Cost: About 45 KB of flash and about 18 KB of RAM at startup (measured: +43 KB, 17.4 KB).

The PHP manual describes the functions: <https://www.php.net/manual/en/book.session.php>.

## License

MIT.
