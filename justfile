tina-dev:
    npx tinacms dev -c "jekyll serve"

format-tia-lock:
    cat tina/tina-lock.json | jq > tmp.json && mv tmp.json tina/tina-lock.json

