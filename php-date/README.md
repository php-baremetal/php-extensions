# php-date

PHP's date and time extension for the board: `date()`, `mktime()`, `strtotime()`, `DateTime`, `DateTimeImmutable`, `DateInterval`, `DatePeriod` and time zones. A script that needs the real time must set the clock first.

php-date is a `bm-php-ext` package: it activates the PHP extension `date` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-date
```

## Example

```php
<?php
date_default_timezone_set('Europe/Rome');
echo date('Y-m-d H:i:s', 86400 * 365), "\n";   // 1971-01-01 01:00:00
$d = new DateTimeImmutable('2026-03-29 12:00');
echo $d->modify('+1 day')->format(DATE_ATOM), "\n";
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

Options, set under `extra.baremetal.options` of the project `composer.json`:

| Option | Type | Default | Effect |
| --- | --- | --- | --- |
| `date-timezones` | `full` or `utc` | `full` | Time zone database. `full` carries every named zone; `utc` carries UTC only, and a named zone such as `Europe/Rome` is rejected with a clear error. |

```json
{
  "extra": {
    "baremetal": {
      "options": {
        "date-timezones": "utc"
      }
    }
  }
}
```

Cost: About 610 KB of flash with `full`, about 255 KB with `utc`; about 60 KB of RAM at startup (measured: +609 KB, +253 KB, 59.8 KB).

The PHP manual describes the functions: <https://www.php.net/manual/en/book.date.php>.

## License

MIT.
