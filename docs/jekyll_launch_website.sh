#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
LOCAL_ROOT="$REPO_ROOT/.local"
LOCAL_RUBY_ROOT="$LOCAL_ROOT/ruby-3.3.11-install"

cd "$SCRIPT_DIR"
export BUNDLE_USER_HOME="$SCRIPT_DIR/.bundle-user"
export BUNDLE_APP_CONFIG="$SCRIPT_DIR/.bundle"
export PATH="$LOCAL_RUBY_ROOT/bin:$PATH"
export GEM_HOME="$LOCAL_RUBY_ROOT/lib/ruby/gems/3.3.0"
export GEM_PATH="$GEM_HOME"
export RUBYLIB="$LOCAL_RUBY_ROOT/lib/ruby/site_ruby/3.3.0:$LOCAL_RUBY_ROOT/lib/ruby/site_ruby:$LOCAL_RUBY_ROOT/lib/ruby/vendor_ruby/3.3.0:$LOCAL_RUBY_ROOT/lib/ruby/vendor_ruby:$LOCAL_RUBY_ROOT/lib/ruby/3.3.0:$LOCAL_RUBY_ROOT/lib/ruby/3.3.0/x86_64-linux"
export LD_LIBRARY_PATH="$LOCAL_ROOT/openssl-3.0.20-install/lib64:$LOCAL_ROOT/libyaml-0.2.5-install/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

exec "$LOCAL_RUBY_ROOT/bin/ruby" -S bundle _4.0.7_ exec jekyll serve \
  --host 0.0.0.0 \
  --livereload
