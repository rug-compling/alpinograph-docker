
# AlpinoGraph in Docker

Zie ook: [AlpinoGraph](https://alpinograph.readthedocs.io/)

Dit is getest op Linux.

Download het script
[`run.sh`](https://raw.githubusercontent.com/rug-compling/alpinograph-docker/master/run.sh)
en pas het aan voordat je het gaat gebruiken.

De rest van de bestanden heb je niet nodig, tenzij je AlpinoGraph in
Docker wilt aanpassen.

Run `run.sh` om AlpinoGraph in Docker te starten.

Type `exit` of Control-D om de database schoon af te sluiten en Docker te
stoppen.

## Invoeren van een corpus

Kopieer een [Alpino](https://www.let.rug.nl/vannoord/alp/Alpino/)-corpus
naar je data-directory, dat gedefinieerd is in `run.sh`. (Of maak een harde
link. Een symlink werkt niet.) Dat kunnen een of meer dact-bestanden
zijn, een compact corpus, losse xml-bestanden al dan niet ge-gzip't,
een tar- of zipbestand. In Docker kun je het corpus invoeren, bijvoorbeeld:

    alpino2agens -t alpinotreebank cdb.dact | agens -a

of bijvoorbeeld:

    find . -name '*.xml' | sort | alpino2agens -t mijncorpus | agens -a

Daarna kun je het corpus weer verwijderen.

De lijst van corpora voor de webinterface kun je bewerken in `corpora.txt`
en het menu voor de webinterface kun je aanpassen in `menu.xml`.
Run daarna `update` om de veranderingen door te voeren.

## Webinterface

De webinterface is buiten Docker beschikbaar op http://localhost:8234/ of op een
ander poortnummer als je dat hebt aangepast in `run.sh`

## Command line

Voor een interactieve sessie in Docker met
[AgensGraph](https://bitnine.net/documentations/manual/agens_graph_developer_manual_en.html),
run `agens`. Sluit opdrachten af met een puntkomma.

```text
[docker:AlpinoGraph] user:~$ agens
agens (AgensGraph 2.2devel, based on PostgreSQL 10.4)
Type "help" for help.

user=# set graph_path = 'alpinotreebank';
SET
user=# match (w:word{lemma: 'fiets'}) return w.word;
  word
---------
 "fiets"
 "fiets"
 "fiets"
(3 rows)

user=# match (w:word{lemma: 'fiets'}) set w.is_een_fiets = true;
UPDATE 3
user=# match (w:word{is_een_fiets: true}) return w.word;
  word
---------
 "fiets"
 "fiets"
 "fiets"
(3 rows)

user=# match (w:word{is_een_fiets: true}) set w.is_een_fiets = NULL;
UPDATE 3
user=# match (w:word{is_een_fiets: true}) return w.word;
 word
------
(0 rows)

user=# \q
[docker:AlpinoGraph] user:~$
```

Sluit de sessie af met Control-D.
