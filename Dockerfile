FROM raspbian/stretch:latest
MAINTAINER Andrew Mathieson <aim29@users.noreply.github.com>
ENV GETIPLAYER_OUTPUT=/output GETIPLAYER_PROFILE=/output/.get_iplayer PUID=1000 PGID=100 PORT=1935 BASEURL=
EXPOSE $PORT
VOLUME "$GETIPLAYER_OUTPUT"

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-armhf /tini
RUN chmod +x /tini

RUN apt-get update && \
    apt-get install -y apt-transport-https logrotate cron syslogd --no-install-recommends && \
    wget -qO - "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x4C5653EB93401EAECAF6B28E8B07C4FF0F5BFDFE" | apt-key add - && \
    wget -qO - "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x5690DA116DE2A66298231BCA0315CB6C13924333" | sudo apt-key add - && \
    echo "deb https://packages.hedgerows.org.uk/raspbian stable/" | sudo tee /etc/apt/sources.list.d/packages.hedgerows.org.uk.list && \
    echo "deb-src https://packages.hedgerows.org.uk/raspbian stable/" | sudo tee -a /etc/apt/sources.list.d/packages.hedgerows.org.uk.list && \
    apt-get update && \
    apt-get install -y get-iplayer --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY files/ /

ENTRYPOINT ["/tini", "--"]
CMD ["/start"]
