FROM rakudo-star:2023.08

# Move it
WORKDIR /opt
COPY bin/ ./bin/
COPY lib/ ./lib/
COPY META6.json ./META6.json
COPY templates/ ./templates/

# Dependency time
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install libssl-dev libarchive-dev
# Get the latest and greatest for bug fix
# https://github.com/rawleyfowler/Humming-Bird/issues/60#issuecomment-1788351265
RUN zef install https://github.com/rawleyfowler/Humming-Bird --force-install
# Stupid tests failing idk
RUN zef -v install --force-test IO::Socket::Async::SSL \
    Archive::Libarchive::Raw NativeHelpers::Callback
RUN zef -v install --deps-only .

# Finish setting up the environment
EXPOSE 3000

CMD ["raku", "bin/hyperlink-redirect]
