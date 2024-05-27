#!/bin/sh

# Build this static site on Cloudflare Pages.
# See
# https://developers.cloudflare.com/pages/configuration/language-support-and-tools/

# Download zola
ZOLA_VERSION="0.18.0"
ZOLA_URL="https://github.com/getzola/zola/releases/download/v${ZOLA_VERSION}/zola-v${ZOLA_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
curl -LO $ZOLA_URL
tar -xzf zola-${ZOLA_VERSION}-x86_64-unknown-linux-gnu.tar.gz

chmod +x zola
zola build