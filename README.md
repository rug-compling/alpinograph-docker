
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
link. Een symlink werkt niet.)

Je kunt een voorbeeld-corpus downloaden van ... TODO, of je kunt zelf
een corpus maken met [Alpino in Docker](https://github.com/rug-compling/alpino-docker).

Een corpus bestaat uit een of meerdere bestanden. Bestanden met de
volgende uitgangen worden herkend:

 * `.xml`, `.xml.gz` — Een enkele geparste zin in het `alpino_ds`-formaat, een zogenaam Alpino-bestand.
 * `.tar`, `.tar.gz`, `.tgz`, `.zip` — Archiefbestand met daarin meerdere Alpino-bestanden.
 * `.data.dz` — Alpino-bestanden samengevoegd in het *compact corpus*-formaat.
   Voor elk `.data.dz`-bestand dient ook een `.index`-bestand aanwezig
   te zijn.
 * `.dact` — Alpino-bestanden samengevoegd in een DbXML-bestand.

Een voorbeeld voor het invoeren van een corpus:

    alpino2agens -t mijncorpus deel1.zip deel2.zip deel3.zip | agens -a

Hierin is `mijncorpus` de interne naam die je aan het corpus geeft.
Dit moet één woord zijn, bestaand uit letters.

Let op: De Alpino-bestanden uit alle invoerbestanden samen moeten elk een
uniek sentence-ID hebben.

Wanneer je zoveel invoerbestanden hebt dat de commandoregel te lang
wordt kun je bestandsnamen via een pipe doorgeven, één naam per regel,
bijvoorbeeld zo:

    find mijncorpus -name '*.xml' | sort -g | alpino2agens -t mijncorpus | agens -a

Na het invoeren kun je als je wilt de corpusbestanden weer verwijderen
uit je data-directory.

Om het corpus te kunnen gebruiken in de webinterface moet je het
toevoegen aan het menu. Dat doe je door een regel toe te voegen in het
bestand `corpora.txt` in je data-directory. Hier staan als voorbeeld
al een aantal corpora in vermeld, maar deze corpora zijn niet
aanwezig. Die regels kun je verwijderen.

Regels die beginnen met een dubbele punt komen als tussenkopjes in het
menu.

Een regel voor een corpus bestaat uit de interne naam, het aantal
zinnen in het corpus, en de titel, bijvoorbeeld:

    :mijn corpora
    mijncorpus  42  Mijn eerste corpus

Nadat je `corpora.txt` hebt aangepast geef je het commando `update` om de
veranderingen door te voeren in de interface.

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
user=# match (w:word{lemma: 'fiets'}) return w.sentid, w.word;
 sentid |  word
--------+---------
 "269"  | "fiets"
 "3609" | "fiets"
 "697"  | "fiets"
(3 rows)

user=# match (w:word{lemma: 'fiets'}) set w.is_een_fiets = true;
UPDATE 3
user=# match (w:word{is_een_fiets: true}) return w.sentid, w.word;
 sentid |  word
--------+---------
 "697"  | "fiets"
 "269"  | "fiets"
 "3609" | "fiets"
(3 rows)

user=# match (w:word{is_een_fiets: true}) set w.is_een_fiets = NULL;
UPDATE 3
user=# match (w:word{is_een_fiets: true}) return w.sentid, w.word;
 sentid | word
--------+------
(0 rows)

user=# \q
[docker:AlpinoGraph] user:~$
```

Sluit de sessie af met Control-D.
