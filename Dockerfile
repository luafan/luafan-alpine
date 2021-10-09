FROM alpine

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apk add --update bsd-compat-headers tzdata linux-headers git lua5.3-dev lua5.3 libstdc++ wget ca-certificates gcc libc-dev unzip cmake g++ make libevent libevent-dev curl-dev curl ncurses-dev bison openssl-dev openssl \
    && ln -s /usr/bin/lua5.3 /usr/bin/lua \
    && cd /root \
    && wget http://luarocks.org/releases/luarocks-3.7.0.tar.gz && tar xzf luarocks-3.7.0.tar.gz && cd /root/luarocks-3.7.0 && ./configure && make build && make install && cd \
    && wget https://github.com/MariaDB/server/archive/mariadb-5.5.65.tar.gz && tar xzf mariadb-5.5.65.tar.gz \
    && cd server-mariadb-5.5.65 && cmake -DWITHOUT_TOKUDB=1 . && cd libmysql && make install && cd ../include && make install && cd && rm -rf mariadb-5.5.65.tar.gz server-mariadb-5.5.65 \
    && git clone https://github.com/luafan/luafan.git && cd luafan && luarocks make luafan-0.7-2.rockspec MARIADB_DIR=/usr/local/mysql && cd .. && rm -rf luafan \
    && luarocks install compat53 && luarocks install lpeg && luarocks install lua-cjson 2.1.0-1 && luarocks install luafilesystem \
    && luarocks install lzlib ZLIB_LIBDIR=/lib && luarocks install openssl && luarocks install lbase64 && luarocks install lmd5 \
    && luarocks install lua-protobuf \
    && luarocks install lua-iconv \
    && cd /root/luarocks-3.7.0 && make uninstall && cd \
    && apk del linux-headers git lua5.3-dev g++ bison ncurses-dev libc-dev curl-dev wget libevent-dev cmake make gcc unzip openssl-dev bsd-compat-headers \
    && rm -rf /root/luarocks-3.7.0* /usr/local/mysql/lib/*.a /var/cache/apk/* .cache

WORKDIR /root/

CMD sh
