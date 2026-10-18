#!/usr/bin/env bash
set -euo pipefail

C="${MANIFEST_BRANCH#common-}"
COMMON_URL="https://android.googlesource.com/kernel/common"

if git ls-remote --exit-code "$COMMON_URL" "refs/heads/$C" >/dev/null 2>&1; then
echo ">>> $C exists upstream. No override needed."
exit 0
fi

if ! git ls-remote --exit-code "$COMMON_URL" "refs/heads/deprecated/$C" >/dev/null 2>&1; then
echo "[-] Neither $C nor deprecated/$C exists upstream."
exit 1
fi

echo ">>> $C moved to deprecated/ upstream. Overriding kernel/common revision..."
mkdir -p .repo/local_manifests
{
printf '<?xml version="1.0" encoding="UTF-8"?>\n'
printf '<manifest>\n'
printf '  <remove-project name="kernel/common" />\n'
printf '  <project path="common" name="kernel/common" remote="aosp" revision="refs/heads/deprecated/%s" />\n' "$C"
printf '</manifest>\n'
} > .repo/local_manifests/deprecated_fix.xml
cat .repo/local_manifests/deprecated_fix.xml
