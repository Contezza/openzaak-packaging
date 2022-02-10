FROM ${docker.openzaak.image}:${docker.openzaak.version}

USER root

ARG ASSETS_PATH=assets

RUN mkdir -p /app/fixtures && mkdir -p /app/init
COPY fixtures/*.json /app/init/

RUN chown -R openzaak:openzaak /app/fixtures \
	&& chown -R openzaak:openzaak /app/init \
	&& chmod -R a+rw /app/fixtures

COPY *.sh /
RUN chmod a+x /*.sh

USER openzaak

CMD ["/start.sh"]