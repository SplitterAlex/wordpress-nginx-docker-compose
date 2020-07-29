FROM urre/wordpress-nginx-docker-compose-image

# Install wp-cli
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /bin/wp-cli.phar
RUN cd /bin && mv wp-cli.phar wp
RUN mkdir -p /var/www/.wp-cli/cache && chown www-data:www-data /var/www/.wp-cli/cache

RUN set -ex; \
	\
    pecl uninstall imagick-3.4.4; \
    \
    apt-get update; \
	apt-get install -y --no-install-recommends \
		libjpeg-dev \ 
		libpng-dev \
        wget 


# build and install libwebp
RUN set -ex; \
    \
    cd /tmp/; \
    wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.0.tar.gz; \
    tar xvzf libwebp-1.0.0.tar.gz; \
    cd libwebp-1.0.0; \
    ./configure; \
    make; \
    make install

#build and install ImageMagick
RUN set -ex; \
    \
    cd /tmp/; \
    # apt build-dep imagemagick; \
    wget https://imagemagick.org/download/ImageMagick-7.0.10-23.tar.gz; \
    tar xvzf ImageMagick-7.0.10-23.tar.gz; \
    cd ImageMagick-7.0.10-23/; \
    ./configure --with-webp=yes; \
    make; \
    make install; \
    ldconfig /usr/local/lib

RUN set -ex; \
    \
    apt-get install -y --no-install-recommends \
        imagemagick \
        gcc \
        libmagickwand-dev; \
    pecl install imagick;


# RUN apt-get update && apt-get install php-imagick

# Note: Use docker-compose up -d --force-recreate --build when Dockerfile has changed.
