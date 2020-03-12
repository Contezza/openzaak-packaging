# Contezza Packaging - Open Zaak

Open Zaak distributie van Contezza. Deze distributie geeft extra mogelijkheid om JSON import uit te voeren.  

## Development

Gebruik `clean install` om Docker bestand te genereren. Deze komt in `target/` map te staan. Gebruik `clean install -Pdocker-build-start` om de omgeving te starten en te testen.

## Release

1. Maak een nieuwe branch met het versienummer, bijvoorbeeld `1.0.0`. 
2. Maak vervolgens de nodige wijzigingen in de nieuw aangemaakte branch. 
3. Wanneer alles goed staat, doe je een laatste commit in de branch met als commentaar `create-release`. Gitlab CI zal vervolgens de docker image publiceren. 
4. Nadat release is uitgevoerd is er ook een tag gemaakt. Dit houdt in dat je de branch kunt mergen met `master` en vervolgens mag je de branch verwijderen.

## Import

Onderstaand een voorbeeld om JSON mee te geven in compose file. Gebruik https://www.cleancss.com/json-minify/ om JSON op 1 regel te krijgen.

```
[
	{
		"model": "vng_api_common.jwtsecret",
		"pk": 2,
		"fields": {
			"identifier": "openzaak-alfresco-dev",
			"secret": "424787bc-4b5f-4466-a57d-cd248020b363"
		}
	},
	{
		"model": "vng_api_common.jwtsecret",
		"pk": 3,
		"fields": {
			"identifier": "nrc-alfresco-dev",
			"secret": "p9yxmqp6ZFYxA8jf"
		}
	},
	{
		"model": "vng_api_common.apicredential",
		"pk": 2,
		"fields": {
			"api_root": "http://tezza-acs.local:8080/alfresco/service/drc/v1/",
			"label": "DRC",
			"client_id": "b91d00dc-c762-4211-9c10-5918c81e5de6",
			"secret": "8fBLx4sY4ZUWVjsjfYHtYwYS",
			"user_id": "admin",
			"user_representation": "admin"
		}
	},
	{
		"model": "vng_api_common.apicredential",
		"pk": 3,
		"fields": {
			"api_root": "http://notificaties-vng.local:8000/api/v1/",
			"label": "NRC",
			"client_id": "nrc-alfresco-dev",
			"secret": "p9yxmqp6ZFYxA8jf",
			"user_id": "admin",
			"user_representation": "admin"
		}
	},
	{
		"model": "authorizations.authorizationsconfig",
		"pk": 1,
		"fields": {
			"api_root": "https://autorisaties-api.vng.cloud/api/v1/",
			"component": "zrc"
		}
	},
	{
		"model": "authorizations.applicatie",
		"pk": 2,
		"fields": {
			"uuid": "f45c7d60-d377-4c5d-8a51-23973b0e3007",
			"client_ids": "[\"openzaak-alfresco-dev\", \"nrc-alfresco-dev\"]",
			"label": "openzaak-alfresco-dev",
			"heeft_alle_autorisaties": true
		}
	},
	{
		"model": "notifications.notificationsconfig",
		"pk": 1,
		"fields": {
			"api_root": "http://notificaties-vng.local:8000/api/v1/"
		}
	},
	{
		"model": "accounts.user",
		"fields": {
			"password": "pbkdf2_sha256$150000$zVSrCdZDeBZz$ofraCi01JF8NPF7bBAiKQWfCL/mFKO+fvjQsTRy2fsg=",
			"last_login": "2020-01-20T13:41:29.645Z",
			"is_superuser": true,
			"username": "admin",
			"first_name": "",
			"last_name": "",
			"email": "admin@admin.org",
			"is_staff": true,
			"is_active": true,
			"date_joined": "2019-12-20T21:54:05.373Z",
			"groups": [],
			"user_permissions": []
		}
	}
]
```

## Image

```
docker pull https://hub.contezza.nl/vngr/openzaak:[version]
```