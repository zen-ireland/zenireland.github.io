set quiet := false
set dotenv-load := true

tina-dev:
    npx tinacms dev -c "jekyll serve"

tina-build:
    npx tinacms build --skip-search-index --noTelemetry --skip-indexing --skip-cloud-checks

format-tina-lock:
    cat tina/tina-lock.json | jq > tmp.json && mv tmp.json tina/tina-lock.json

jekyll-build:
    bundle exec jekyll build

jekyll-build-watch:
    bundle exec jekyll build --watch

ncu:
    npx ncu

ncuu:
    npx ncu -u

npm-ci:
    npm ci --omit=optional

docker-build target="github-builder " progress="auto":
    docker build --target {{target}} --tag zen-{{target}} --tag ghcr.io/zen-ireland/zen-{{target}} --progress {{progress}} --secret id=env,src=.env .

docker-build-verbose: (docker-build "github-builder" "plain")

bundle-install:
    bundle install

docker-run:
    docker run -p 8080:80 -t zen

github-gcr-login:
    echo $GITHUB_CONTANIER_REGISTRY_ACCESS_TOKEN | docker login ghcr.io -u tomscytale --password-stdin

github-registry-push target="github":
    docker push ghcr.io/zen-ireland/zen-{{target}}-builder:latest

web-server:
   lighttpd -D -f lighttpd.conf
 
