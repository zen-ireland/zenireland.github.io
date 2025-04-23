set quiet := false

tina-dev:
    npx tinacms dev -c "jekyll serve"

tina-build:
    npx tinacms build --skip-search-index --noTelemetry --skip-indexing

format-tina-lock:
    cat tina/tina-lock.json | jq > tmp.json && mv tmp.json tina/tina-lock.json

jekyll-build:
    bundle exec jekyll build

ncu:
    npx ncu

ncuu:
    npx ncu -u

npm-ci:
    npm ci --omit=optional

docker-build:
    docker build .

docker-build-verbose:
    docker build --tag zen --progress plain --build-arg TINA_TOKEN="677e9fa4137801044bd9ab898433adaef327cd10" --build-arg NEXT_PUBLIC_TINA_CLIENT_ID="b93c9438-a1c7-4af1-9690-c46b5a0f3c18" .

bundle-install:
    bundle install

docker-run:
    docker run -p 8080:80 -t zen
