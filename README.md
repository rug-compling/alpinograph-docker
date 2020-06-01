
# AlpinoGraph in Docker

Getest op Linux.

Download het script `run.sh` en pas het aan voordat je het gaat gebruiken.

Run `run.sh` om Docker te starten.

Type `exit` of Ctrl-D om de database schoon af te sluiten en Docker te
stoppen.

Kopieer een dact-bestand of een compact corpus naar je datadir. In
docker kun je het corpus invoeren, bijvoorbeeld:

    dact2agens -t alpinotreebank cdb.dact | agens -a

Daarna kun je het dact-bestand weer verwijderen.

(Dit werkt ook met compacte corpora.)

De lijst van corpora kun je bewerken in `corpora.txt`
en het menu kun je aanpassen in `menu.xml`.
Run daarna `update` om de veranderingen door te voeren.

Voor een interactieve sessie met AgensGraph, run `agens`.
Sluit opdrachten af met een puntkomma.

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

user=# \q
[docker:AlpinoGraph] user:~$
```

Sluit af met Ctrl-D.
