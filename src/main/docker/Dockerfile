FROM ${docker.openzaak.image}:${docker.openzaak.version}

ARG ASSETS_PATH=assets

RUN mkdir -p /app/fixtures

COPY *.sh /
RUN chmod a+x /*.sh

CMD ["/start.sh"]