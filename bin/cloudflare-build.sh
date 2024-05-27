#!/bin/sh

# Build this static site on Cloudflare Pages.
# See
# https://developers.cloudflare.com/pages/configuration/language-support-and-tools/

# Download zola
ZOLA_VERSION="0.18.0"
echo "Downloading Zola v${ZOLA_VERSION}"
ZOLA_URL="https://github.com/getzola/zola/releases/download/v${ZOLA_VERSION}/zola-v${ZOLA_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
echo "Downloading Zola from $ZOLA_URL"
curl -sL $ZOLA_URL | tar xz
echo "Downloaded Zola"
chmod +x zola
echo "Zola is executable"
./zola build
echo "Zola build complete"