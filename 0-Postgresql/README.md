# PostgreSQL

## 1. Intro

## Principales commandes psql que vous devez connaître

PostgreSQL (Postgres) est u SGBD (système de gestion de base de données relationnelle) open source, fiable, robuste et performant (gratuite) utilisant le langage SQL. PostgreSQL est également l'une des bases de données relationnelles les plus populaires et les plus utilisées.

## psql

**psql** est une interface de ligne de commande vous permettant d'interagir avec les bases de données Postgres. Vous pouvez l'utiliser pour vous connecter à une DB, pour ajouter, lire et modifier des données, vérifier les bases de données et les champs disponibles, exécuter des commandes à partir d'un fichier, etc.

### 1. Se connecter à une DB

La première étape consiste à apprendre à se connecter à une base de données. Il existe deux façons de se connecter à une base de données PostgreSQL, selon l'emplacement de la base de données.

**Même base de données que l'hôte**
Si la base de données se trouve sur le même hôte que votre machine, vous pouvez utiliser la commande suivante :

```bash
psql -U <username> -d <nom_de_la_db>
psql --user=<utilisateur> -d <nom_de_la_db>
psql --user=<utilisateur> -d <nom_de_la_db> -W

#ex:
psql --user=admin12 -d cours_db
psql -U admin12 -d cours_db
```

_La commande ci-dessus l'indicateur:_

-**W** : force psql à demander le mot de passe de l'utilisateur avant de se connecter à la base de données.

### 2. Base de données hébergée hors du hôte

Dans les cas où votre base de données est hébergée ailleurs, vous pouvez vous connecter comme suit:

```bash
psql -h <dns ou adresse ip> -d cours_db -U admin12 -W

#ex:
psql -h db01.cc4c6mfb7xge.ca-central-1.rds.amazonaws.com -d cours_db -U admin12 -W
psql -h 192.168.2.67 -d cours_db -U admin12 -W
```

_L'indicateur -h spécifie l'adresse de l'hôte de la base de données._

**Mode SSL**
Au cas où vous devez utiliser SSL pour la connexion.

```bash
psql "sslmode=require host=<ip/nom_dns> dbname=<nom_db> user=<utilisateur>"

# ex:
psql "sslmode=require host=192.168.2.45 dbname=cours_db user=admin12"
```

_La commande ci-dessus ouvre une connexion SSL à la base de données spécifiée._

## 2. Lister toutes les bases de données

Dans de nombreux cas, vous travaillerez avec plusieurs bases de données. Vous pouvez lister toutes les bases de données disponibles avec la commande suivante :

```bash
\l
```
