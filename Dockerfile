FROM alpine

COPY sys/* /usr/include/sys/

RUN apk add --update linux-headers git lua5.1-dev lua5.1 libstdc++ wget ca-certificates gcc libc-dev unzip cmake g++ make luajit libevent libevent-dev curl-dev curl ncurses-dev bison && cd /root && wget http://luarocks.org/releases/luarocks-2.4.0.tar.gz && tar xzf luarocks-2.4.0.tar.gz && cd /root/luarocks-2.4.0 && ./configure && make build && make install && cd && wget https://github.com/MariaDB/server/archive/mariadb-5.5.48.tar.gz && tar xzf mariadb-5.5.48.tar.gz && cd server-mariadb-5.5.48 && cmake -DWITHOUT_TOKUDB=1 . && cd libmysql && make install && cd ../include && make install && cd && rm -rf mariadb-5.5.48.tar.gz server-mariadb-5.5.48 && luarocks install luafan MARIADB_DIR=/usr/local/mysql && apk del linux-headers git lua5.1-dev g++ bison ncurses-dev libc-dev curl-dev libevent-dev cmake make gcc unzip && rm -rf /root/luarocks-2.4.0* /usr/local/mysql/lib/*.a /usr/share/* /var/cache/apk/*

RUN apk add --update tzdata wget gcc lua5.1-dev libc-dev zlib zlib-dev unzip cmake g++ make openssl-dev && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" >  /etc/timezone && luarocks install compat53 && luarocks install lpeg && luarocks install lua-cjson && luarocks install luafilesystem && luarocks install lzlib ZLIB_LIBDIR=/lib && luarocks install luasocket && luarocks-5.1 install openssl --server=https://rocks.moonscript.org/dev && luarocks install lbase64 && luarocks install lmd5 && apk del tzdata lua5.1-dev zlib-dev wget gcc libc-dev unzip cmake g++ make openssl-dev && rm -rf /var/cache/apk/*

WORKDIR /root/

CMD sh