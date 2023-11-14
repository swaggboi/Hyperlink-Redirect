# Hyperlink-Redirect

A "useful" tool for turning hyperlinks into redirects in the name of shortening hyperlinks! 🧠 🧑‍🔬

## Run locally

### Install dependencies

    zef -v install --deps-only .

### Run the guy

    ./bin/hyperlink-redirect

## Container stuff

### Build

    podman build -t hyperlink-redirect .

### Tag

    podman tag hyperlink-redirect \
        git.minimally.online/swaggboi_priv/hyperlink-redirect

### Push

    podman push git.minimally.online/swaggboi_priv/hyperlink-redirect

### Pull

    podman pull git.minimally.online/swaggboi_priv/hyperlink-redirect

### Run

    podman run -dt --rm --name hyperlink-redirect -p 3003:3000 \
        hyperlink-redirect

### Generate unit file

    podman generate systemd --files --new --name hyperlink-redirect

## TODO

1. Charset should be `utf-8` not `utf8` (in Content-Type response header)
1. Verify status of meta-refresh; should it be 200 or 3xx?
1. Tests
1. Test UTF-8 chars in return-url
