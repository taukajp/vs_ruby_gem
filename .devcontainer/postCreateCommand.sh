#!/usr/bin/env bash

set -e

test -s Gemfile.lock && exit 0

mv .gitignore .gitignorebk
yes n | bundle gem . --exe --test=test-unit --mit --no-coc --no-ext --no-ci --no-linter

sed -E -e 's#(spec.homepage = ).*#\1"http://example.com"#' \
  -e 's#(spec.metadata\["source_code_uri"\] = ).*#\1"http://example.com"#' \
  -e 's#(spec.metadata\["changelog_uri"\] = ).*#\1"http://example.com"#' \
  -e 's/TODO: //' \
  ${APP_NAME}.gemspec > ${APP_NAME}.gemspec.tmp && \
mv -f ${APP_NAME}.gemspec.tmp ${APP_NAME}.gemspec

# cat <<EOF >> Gemfile
# group :development, :test do
#   gem "debug", require: false
#   gem "rubocop", require: false
#   gem "yard", require: false
# end
# EOF
# bundle install
bundle add debug rubocop yard --require false --group "development, test"
bundle lock --add-platform ruby
bundle lock --add-platform x86_64-linux

cat .gitignorebk >> .gitignore && rm .gitignorebk

exit 0
