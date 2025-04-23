tina-dev:
    npx tinacms dev -c "jekyll serve"

format-tina-lock:
    cat tina/tina-lock.json | jq > tmp.json && mv tmp.json tina/tina-lock.json

jekyll-build:
    bundle exec jekyll build

ncu:
    npx ncu

ncuu:
    npx ncu -u
