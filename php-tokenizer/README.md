# php-tokenizer

PHP's tokenizer for the board: `token_get_all()`, `token_name()`, the `T_*` constants and the `PhpToken` class, to split PHP source into tokens. Needed by some libraries that inspect code.

php-tokenizer is a `bm-php-ext` package: it activates the PHP extension `tokenizer` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-tokenizer
```

## Example

```php
<?php
foreach (token_get_all('<?php echo 1;') as $token) {
    echo is_array($token) ? token_name($token[0]) : $token, "\n";
}
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

It has no options.

Cost: About 15 KB of flash and about 29 KB of RAM at startup (measured: +13 KB, 28.1 KB).

The PHP manual describes the functions: <https://www.php.net/manual/en/book.tokenizer.php>.

## License

MIT.
