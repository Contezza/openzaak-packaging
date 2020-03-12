# Contezza Packaging - Open Zaak

Open Zaak distributie van Contezza. Deze distributie geeft extra mogelijkheid om JSON import uit te voeren.  

## Development

Gebruik `clean install` om Docker bestand te genereren. Deze komt in `target/` map te staan. Gebruik `clean install -Pdocker-build-start` om de omgeving te starten en te testen.

## Release

1. Maak een nieuwe branch met het versienummer, bijvoorbeeld `1.0.0`. 
2. Maak vervolgens de nodige wijzigingen in de nieuw aangemaakte branch. 
3. Wanneer alles goed staat, doe je een laatste commit in de branch met als commentaar `create-release`. Gitlab CI zal vervolgens de docker image publiceren. 
4. Nadat release is uitgevoerd is er ook een tag gemaakt. Dit houdt in dat je de branch kunt mergen met `master` en vervolgens mag je de branch verwijderen.

## Image

```
docker pull https://hub.contezza.nl/vngr/openzaak:[version]
```
