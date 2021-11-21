FROM raspbian/stretch:latest
MAINTAINER Andrew Mathieson <aim29@users.noreply.github.com>
ENV GETIPLAYER_OUTPUT=/output GETIPLAYER_PROFILE=/output/.get_iplayer PUID=1000 PGID=100 PORT=1935 BASEURL=
EXPOSE $PORT
VOLUME "$GETIPLAYER_OUTPUT"

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-armhf /tini
RUN chmod +x /tini

RUN apt-get update && \
    apt-get install -y apt-transport-https logrotate cron syslogd curl --no-install-recommends && \
    echo 'deb http://download.opensuse.org/repositories/home:/m-grant-prg/Raspbian_9.0/ /' | sudo tee /etc/apt/sources.list.d/home:m-grant-prg.list \
    curl -fsSL https://download.opensuse.org/repositories/home:m-grant-prg/Raspbian_9.0/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_m-grant-prg.gpg > /dev/null \
    apt update \
    apt-get install -y get-iplayer --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY files/ /

ENTRYPOINT ["/tini", "--"]
CMD ["/start"]
