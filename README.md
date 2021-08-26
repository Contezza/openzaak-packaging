# Contezza Packaging - Open Zaak

Open Zaak distributie van Contezza. Deze distributie geeft extra mogelijkheid om JSON import uit te voeren en maakt standaard superuser admin/admin aan (is wel zo handig).

## Development

Gebruik `clean install` om Docker bestand te genereren. Deze komt in `target/` map te staan. Gebruik `clean install -Pdocker-build-start` om de omgeving te starten en te testen.

## Release

1. Geef commit in de master branch met als commentaar `create-release`. Gitlab CI zal vervolgens de docker image publiceren.

## Image

```
docker pull https://harbor.contezza.nl/vngr/openzaak:[version]
```
