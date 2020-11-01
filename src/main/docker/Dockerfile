FROM ${docker.openzaak.image}:${docker.openzaak.version}

ARG ASSETS_PATH=assets

RUN mkdir -p /app/fixtures && mkdir -p /app/init
COPY fixtures/*.json /app/init/

COPY *.sh /
RUN chmod a+x /*.sh

CMD ["/start.sh"]