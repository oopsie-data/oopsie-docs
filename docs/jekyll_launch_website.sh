cd /datastor1/jiahuikchen/oopsie_tools/docs
export BUNDLE_USER_HOME=$PWD/.bundle-user
export BUNDLE_APP_CONFIG=$PWD/.bundle
bundle _4.0.7_ exec jekyll serve \
  --host 0.0.0.0 \
  --livereload \
  --baseurl /oopsie_tools
