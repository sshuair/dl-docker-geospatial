FROM debian:jessie-slim

ENV MAPNIK_VERSION v3.0.16

ENV BUILD_DEPENDENCIES="build-essential \
    ca-certificates \
    git \
    icu-devtools \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-regex-dev \
    libboost-thread-dev \
    libboost-system-dev \
    libcairo-dev \
    libfreetype6-dev \
    libgdal-dev \
    libharfbuzz-dev \
    libicu-dev \
    libjpeg-dev \
    libpq-dev  \
    libproj-dev \
    librasterlite-dev \
    libsqlite3-dev \
    libtiff-dev \
    libwebp-dev"

ENV DEPENDENCIES="libboost-filesystem1.55.0 \
    libboost-program-options1.55.0 \
    libboost-regex1.55.0 \
    libboost-thread1.55.0 \
    libboost-system1.55.0 \
    libcairo2 \
    libfreetype6 \
    libgdal1h \
    libharfbuzz-gobject0 \
    libharfbuzz-icu0 \
    libharfbuzz0b \
    libicu52 \
    libjpeg62-turbo \
    libpq5 \
    libproj0 \
    librasterlite2 \
    libsqlite3-0 \
    libtiff5 \
    libtiffxx5 \
    libwebp5  \
    libwebpdemux1 \
    libwebpmux1 \
    python"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        $BUILD_DEPENDENCIES $DEPENDENCIES \
    && git clone https://github.com/mapnik/mapnik.git \
    && cd mapnik \
    && git checkout $MAPNIK_VERSION \
    && git submodule update --init \
    && python scons/scons.py INPUT_PLUGINS='all' \
    && make \
    && make install