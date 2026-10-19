# php-pdo_sqlite

The SQLite driver of PDO for the board: `new PDO('sqlite:...')` against a database file. The engine is SQLite 3.54.1, shared with [php-sqlite3](package:php-baremetal/php-sqlite3), so building both costs little more than one. A database file lives on the microSD card of a project with `microsd` storage.

php-pdo_sqlite is a `bm-php-ext` package: it activates the PHP extension `pdo_sqlite` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-pdo_sqlite
```

Needs: `php-baremetal/php-pdo`, which Composer installs with it.

## Example

```php
<?php
$pdo = new PDO('sqlite:file:/sdcard/notes.db?nolock=1');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->exec('CREATE TABLE IF NOT EXISTS boots (id INTEGER PRIMARY KEY, note TEXT)');
$pdo->prepare('INSERT INTO boots (note) VALUES (?)')->execute(['hello']);
echo $pdo->query('SELECT COUNT(*) FROM boots')->fetchColumn(), "\n";
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

It has no options.

Cost: About 530 KB of flash together with `php-pdo` (the SQLite engine is about 470 KB and is shared with `php-sqlite3`), about 21 KB of RAM at startup for the driver (measured: +527 KB with pdo, 67 KB with pdo).

## Notes

- SQLite allocates outside `memory_limit`: up to 256 KB of page cache per open connection.
- SQLite on FAT (the card) is patched in three ways: the inode is a hash of the path, because FATFS leaves `st_ino` at 0 and every file shared one lock state; the default VFS is `unix-excl`, because `fcntl` locks do nothing on FATFS and a reset mid-transaction corrupted the database; read-only `unix-excl` connections skip the lock probe too, so they see a journal to roll back. The rollback was verified with 4 reset cycles.
- The build leaves out threads, WAL, mmap and loadable extensions, and keeps temporary files in RAM.

The PHP manual describes the functions: <https://www.php.net/manual/en/book.pdo_sqlite.php>.

## License

MIT.
