# php-mbstring

Multibyte string support for the board: `mb_strlen()`, `mb_substr()`, `mb_strtoupper()`, `mb_convert_encoding()`, `mb_detect_encoding()` and the rest of the `mb_*` functions. It covers the conversions that `iconv` would, which the firmware does not carry.

php-mbstring is a `bm-php-ext` package: it activates the PHP extension `mbstring` (`extra.baremetal.php-ext`) in the firmware, and carries no code of its own. The extension comes from the PHP source the SDK builds, so it is available on every PHP minor the ESP32 SDK supports: 8.3, 8.4 and 8.5. It needs no HAL, so conductor adds nothing for it.

## Install

In a project created with `phpbm init`:

```bash
composer require php-baremetal/php-mbstring
```

## Example

```php
<?php
echo mb_strlen('caffè'), "\n";                 // 5
echo mb_strtoupper('caffè'), "\n";             // CAFFÈ
echo bin2hex(mb_convert_encoding('è', 'ISO-8859-1', 'UTF-8')), "\n";   // e8
```

## SDK data

The SDK describes the extension per PHP minor (flash cost, memory taken at startup, options), and the package page shows that data live from the SDK release, so it is not repeated here.

Options, set under `extra.baremetal.options` of the project `composer.json`:

| Option | Type | Default | Effect |
| --- | --- | --- | --- |
| `mbstring-cjk` | bool | `true` | Chinese, Japanese and Korean encodings (SJIS, EUC-*, Big5, GB18030, ISO-2022-*) and `mb_convert_kana()`. Off saves most of the extension's flash and makes `mb_language()` reject `ja`, `ko`, `zh-cn` and `zh-tw`; UTF-8, UTF-16, UTF-32 and the Latin and Cyrillic encodings stay. On PHP 8.3 the switch also drops the Japanese mobile UTF-8 variants. |
| `mbstring-regex` | bool | `false` | The `mb_ereg*()` functions and `mb_split()`, built on the oniguruma 6.9.10 regex library. |

```json
{
  "extra": {
    "baremetal": {
      "options": {
        "mbstring-cjk": false,
        "mbstring-regex": true
      }
    }
  }
}
```

Cost: About 950 KB of flash by default, about 200 KB with `mbstring-cjk` off; `mbstring-regex` adds about 445 KB (oniguruma's own CJK encodings stay linked even with `mbstring-cjk` off). About 13 KB of RAM at startup, about 8 KB more with the regex (measured: +947 KB, +196 KB without CJK, +1392 KB with the regex; 12 KB, 20 KB with the regex).

## Notes

- The regex build uses a patched oniguruma configuration and `const` tables that give back 18.5 KB of internal RAM.

The PHP manual describes the functions: <https://www.php.net/manual/en/book.mbstring.php>.

## License

MIT.
