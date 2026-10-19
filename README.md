# php-extensions

Monorepo of the PHP extension packages of [php-baremetal](https://github.com/php-baremetal). Each package
(type `bm-php-ext`) only names a PHP extension; the build recipe lives in the SDK (`php-esp32-sdk`) for every PHP
minor, so a package works only with an SDK that provides that extension.

One folder is one Composer package, `php-baremetal/<folder>`:

| Folder | Package |
|---|---|
| `php-bcmath` | `php-baremetal/php-bcmath` |
| `php-ctype` | `php-baremetal/php-ctype` |
| `php-date` | `php-baremetal/php-date` |
| `php-filter` | `php-baremetal/php-filter` |
| `php-mbstring` | `php-baremetal/php-mbstring` |
| `php-opcache` | `php-baremetal/php-opcache` |
| `php-openssl` | `php-baremetal/php-openssl` |
| `php-pdo` | `php-baremetal/php-pdo` |
| `php-pdo_sqlite` | `php-baremetal/php-pdo_sqlite` (requires `php-pdo`) |
| `php-session` | `php-baremetal/php-session` |
| `php-sqlite3` | `php-baremetal/php-sqlite3` |
| `php-tokenizer` | `php-baremetal/php-tokenizer` |
| `php-zlib` | `php-baremetal/php-zlib` |

## Releases

Packages are versioned and released independently. The version is never written in `composer.json`: it comes
from the tag. Pushing a tag `php-<name>/v<semver>` runs `.github/workflows/publish.yml`, which publishes only
that folder, with that version, to the private Composer registry
(`https://repository.php-baremetal.com`, overridable with the `REGISTRY_URL` repository variable).

```sh
git tag php-mbstring/v1.0.0 && git push origin php-mbstring/v1.0.0
```

Accepted versions are `vX.Y.Z` and `vX.Y.Z-alphaN`, `-betaN`, `-RCN`. The workflow checks the tag, that the
folder's `composer.json` `name` is `php-baremetal/<folder>`, builds a zip of the folder contents (tests and
`.github` excluded), runs `composer validate --strict` on it and uploads it. It needs the repository secret
`REGISTRY_TOKEN`, a registry token with the `repository:write` ability. The workflow can also be started by
hand (Actions, publish, Run workflow) choosing the package and the version.

To release every package at the same version, push one `all/` tag. `.github/workflows/publish-all.yml`
publishes each package, creates its `php-<name>/v<version>` tag and deletes the `all/` tag at the end; packages
whose tag already exists are skipped.

```sh
git tag all/1.0.0 && git push origin all/1.0.0
```

To publish from a shell, or to check a zip without uploading:

```sh
.github/scripts/publish.sh php-mbstring 1.0.0 --dry-run
REGISTRY_URL=http://localhost REGISTRY_TOKEN=... .github/scripts/publish.sh php-mbstring 1.0.0
```

Publish `php-pdo` before the first release of `php-pdo_sqlite`, which requires it.
