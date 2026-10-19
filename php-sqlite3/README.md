# php-sqlite3

The native SQLite interface for the board: the `SQLite3`, `SQLite3Stmt` and `SQLite3Result` classes. The engine is SQLite 3.54.1, shared with [php-pdo_sqlite](package:php-baremetal/php-pdo_sqlite), so building both costs little more than one. A database file lives on the microSD card of a project with `microsd` storage.

php-sqlite3 is a `bm-php-ext` package: it activates the PHP extension `sqlite3` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-sqlite3
```

## Example

```php
<?php
$db = new SQLite3('/sdcard/notes.db');
$db->exec('CREATE TABLE IF NOT EXISTS boots (id INTEGER PRIMARY KEY, note TEXT)');
$db->exec("INSERT INTO boots (note) VALUES ('hello')");
echo $db->querySingle('SELECT COUNT(*) FROM boots'), "\n";
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

It has no options.

Cost: About 480 KB of flash with the SQLite engine (shared with `php-pdo_sqlite`; both together with `php-pdo` are about 550 KB) and about 26 KB of RAM at startup (measured: +482 KB, +551 KB with pdo_sqlite, 25.7 KB).

## Notes

- SQLite allocates outside `memory_limit`: up to 256 KB of page cache per open connection.
- The FAT patches (path-hash inodes, the `unix-excl` VFS, lock-probe skip) and the compile-time exclusions (threads, WAL, mmap, loadable extensions) are those of [php-pdo_sqlite](package:php-baremetal/php-pdo_sqlite).

The PHP manual describes the functions: <https://www.php.net/manual/en/book.sqlite3.php>.

## License

MIT.
