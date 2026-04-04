# Jekyll development server for local docs preview.
# Does NOT include the pdoc API reference — use Dockerfile.full for that.
#
# Usage (from docs/):
#   docker compose up

FROM --platform=linux/amd64 ruby:3.2-slim


WORKDIR /site

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock* ./
RUN bundle install
RUN bundle lock --add-platform x86_64-linux

COPY . .

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--baseurl", "", "--livereload", "--livereload-port", "35729"]
