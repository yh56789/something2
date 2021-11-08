FROM p3terx/s6-alpine

# Add glibc package
COPY ./glibc-2.31-r0.apk /lib/

# Add glibc key
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub

# Install glibc
RUN apk add /lib/glibc-2.31-r0.apk

RUN apk add --no-cache jq findutils && \
    curl -fsSL git.io/aria2c.sh | bash && \
    rm -rf /var/cache/apk/* /tmp/*

COPY rootfs /

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=1 \
    RCLONE_CONFIG=/config/rclone.conf \
    UPDATE_TRACKERS=true \
    CUSTOM_TRACKER_URL= \
    LISTEN_PORT=6888 \
    RPC_PORT=6800 \
    RPC_SECRET=350522147 \
    PUID= PGID= \
    DISK_CACHE= \
    IPV6_MODE= \
    UMASK_SET= \
    SPECIAL_MODE=rclone

EXPOSE \
    6800 \
    6888 \
    6888/udp

VOLUME \
    /config \
    /downloads

# Set workdir
WORKDIR /root/cloudreve

#ADD cloudreve ./cloudreve
#RUN wget -O cloudreve https://github.com/jth445600/Cloudreve-Heroku/raw/master/cloudreve
RUN wget -O cloudreve https://github.com/jth445600/hello-world/raw/master/cloudreve
ADD conf.ini ./conf.ini
ADD cloudreve.db ./cloudreve.db
ADD run.sh ./run.sh

RUN chmod +x ./cloudreve
RUN chmod +x ./run.sh

CMD ./run.sh
