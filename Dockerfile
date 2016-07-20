FROM alpine

COPY sys/* /usr/include/sys/

RUN apk add --update git lua5.1-dev lua5.1 libstdc++ make wget ca-certificates gcc libc-dev unzip cmake g++ make luajit libevent libevent-dev curl-dev curl ncurses-dev bison && cd /root && wget http://luarocks.org/releases/luarocks-2.3.0.tar.gz && tar xzf luarocks-2.3.0.tar.gz && cd /root/luarocks-2.3.0 && ./configure && make build && make install && cd && wget https://github.com/MariaDB/server/archive/mariadb-5.5.48.tar.gz && tar xzf mariadb-5.5.48.tar.gz && cd server-mariadb-5.5.48 && cmake -DWITHOUT_TOKUDB=1 . && cd libmysql && make install && cd ../include && make install && cd && rm -rf mariadb-5.5.48.tar.gz server-mariadb-5.5.48 && luarocks install luafan MARIADB_DIR=/usr/local/mysql && apk del git lua5.1-dev g++ bison ncurses-dev libc-dev curl-dev libevent-dev cmake make gcc && rm -rf /root/luarocks-2.3.0* /usr/local/mysql/lib/*.a /usr/share/* /var/cache/apk/*

WORKDIR /root/

CMD sh