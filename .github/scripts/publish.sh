#!/usr/bin/env bash
# Build the zip of one php-extensions sub-package and upload it to the Composer registry (Packistry upload API).
#
# usage: .github/scripts/publish.sh <package> <version> [--dry-run]
#   <package>  folder name, e.g. php-mbstring
#   <version>  X.Y.Z or X.Y.Z-alphaN|-betaN|-RCN (a leading "v" is accepted and stripped)
#   --dry-run  build and validate the zip, do not upload
#
# env:
#   REGISTRY_URL         default https://repository.php-baremetal.com
#   REGISTRY_REPOSITORY  optional: upload to {REGISTRY_URL}/r/{repository}/... instead of the root repository
#   REGISTRY_TOKEN       token with the repository:write ability (not needed with --dry-run)
#   OUT_DIR              where the zip is written (default: a temporary directory)
set -euo pipefail

package="${1:-}"
version="${2:-}"
dry_run=0
[[ "${3:-}" == "--dry-run" ]] && dry_run=1

if [[ -z "$package" || -z "$version" ]]; then
  echo "usage: $0 <package> <version> [--dry-run]" >&2
  exit 2
fi

version="${version#v}"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
registry="${REGISTRY_URL:-https://repository.php-baremetal.com}"
registry="${registry%/}"

if ! [[ "$package" =~ ^php-[a-z0-9_]+$ ]] || [[ ! -f "$root/$package/composer.json" ]]; then
  echo "::error::'$package' is not a package folder of this repository" >&2
  exit 1
fi

semver='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-(alpha|beta|RC)(\.?[0-9]+)?)?$'
if ! [[ "$version" =~ $semver ]]; then
  echo "::error::version '$version' is not X.Y.Z or X.Y.Z-alphaN/-betaN/-RCN (semver that Composer accepts)" >&2
  exit 1
fi

name="$(jq -r '.name // empty' "$root/$package/composer.json")"
if [[ "$name" != "php-baremetal/$package" ]]; then
  echo "::error::composer.json name is '$name', expected 'php-baremetal/$package'" >&2
  exit 1
fi
if jq -e 'has("version")' "$root/$package/composer.json" >/dev/null; then
  echo "::error::$package/composer.json must not have a \"version\" field (the version comes from the tag)" >&2
  exit 1
fi

out="${OUT_DIR:-$(mktemp -d)}"
mkdir -p "$out"
zip_file="$out/$package-$version.zip"
rm -f "$zip_file"

# contents of the folder at the archive root; tests and CI files stay out
(cd "$root/$package" && zip -q -r -X "$zip_file" . -x 'tests/*' '.github/*' '.git/*' '.gitignore' '.gitattributes')
echo "built $zip_file"

check="$(mktemp -d)"
trap 'rm -rf "$check"' EXIT
unzip -q "$zip_file" -d "$check"
[[ -f "$check/composer.json" ]] || { echo "::error::composer.json is not at the archive root" >&2; exit 1; }
(cd "$check" && COMPOSER_ROOT_VERSION="$version" composer validate --strict --no-check-publish --no-interaction)

if [[ $dry_run -eq 1 ]]; then
  echo "dry run: not uploading"
  exit 0
fi

if [[ -z "${REGISTRY_TOKEN:-}" ]]; then
  echo "::error::REGISTRY_TOKEN is not set" >&2
  exit 1
fi

url="$registry"
[[ -n "${REGISTRY_REPOSITORY:-}" ]] && url="$registry/r/$REGISTRY_REPOSITORY"
url="$url/$name"

response="$(mktemp)"
status="$(curl --silent --show-error --output "$response" --write-out '%{http_code}' \
  --request POST "$url" \
  --header "Authorization: Bearer $REGISTRY_TOKEN" \
  --header 'Accept: application/json' \
  --form "version=$version" \
  --form "file=@$zip_file;type=application/zip")"

echo "POST $url -> HTTP $status"
cat "$response"
echo
if [[ ! "$status" =~ ^2[0-9][0-9]$ ]]; then
  echo "::error::upload of $name $version failed (HTTP $status)" >&2
  exit 1
fi
echo "published $name $version"
