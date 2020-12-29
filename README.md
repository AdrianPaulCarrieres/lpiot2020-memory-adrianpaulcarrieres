# lpiot2020-memory-adrianpaulcarrieres
Memory game for LPIOT-2020 by Adrian-Paul Carrières

## Langages, frameworks

### Angular

Je n'ai pas vraiment grand chose à dire sur mon choix par rapport à Angular, vu que c'était un des deux langages au choix.

Cela étant dit, après avoir fait un peu de JQuery pendant mon DUT et un projet en ReactJS pendant la Licence Pro (et plusieurs tutoriels pour l'alternance), je dois dire que je préfère Angular.

JQuery est pour moi trop abrégé et rend la chose vraiment pas très lisible si on ne s'y connait pas.

Je n'apprécie pas vraiment plus React, qui lui mélange la logique à l'UI d'un composant, ce qui me gêne un petit peu et me donne l'impression d'avoir un code particulièrement fouillis (notamment à cause de la partie UI justement).

J'ai par contre éprouvé bien plus de difficulté avec Angular pour utiliser certaines de ses fonctionnalités (comme les Observables) mais j'y reviendrai plus bas.

### Elixir et le framework Phoenix

Elixir est un langage dynamique et fonctionnel, fait pour construire des applications maintenables et scalables.

Elixir repose pour cela sur la VM Erlang, et est donc connu pour être orienté vers les systèmes distribués et tolérants à l'erreur. On peut le retrouver sous différentes formes maintenant, grâce à notamment Phoenix, son framework Web et Nerves, un framework orienté objets embarqués.

Ici j'ai décidé d'utiliser Elixir pour mettre en place un système de parties de memory concurrentes, et j'ai greffé à cela les Channels de Phoenix, qui ajoutent tout simplement un système de Pub/Sub via des websockets. En plus des Channels, j'ai aussi mis en place une API qui va permettre aux applications de récupérer les images utilisées dans le jeu.

Pour résumer, l'application Elixir est là pour permettre le lancement et la manipulation de plusieurs parties de manière concurrente, tandis que Phoenix fournit aux joueurs l'outil pour manipuler leurs parties et communiquer le résultat de chaque opération sur celles-ci aux autres joueurs. On trouvera aussi une API (toujours via Phoenix) qui va permettre de récupérer les images en base64 depuis la base de données PostgreSQL (où elles sont stockées sous forme de BLOB, donc, en binaire).

### La base de données : PostgreSQL

L'adaptateur par défaut d'Ecto, un ORM utilisé par Phoenix, est par défaut configuré pour une base de données PostgreSQL. Étant donné notre peu d'écriture (seuls les scores de chaque partie et les joueurs y étant présents sont sauvegardés) et notre grande demande en lecture (on y stocke aussi les decks, avec thème, dos de carte et surtout les cartes), il m'a semblé logique et concevable de conserver PostgreSQL pour nos besoins de persistence.

## Installation

### Téléchargement

On commence par télécharger nos différents langages, Elixir (et Erlang, compris avec Elixir), NodeJS pour utiliser Angular, et PostgreSQL :

- [Elixir](https://elixir-lang.org/install.html)
- [NodeJS](https://nodejs.org/en/download/)
- [PostgreSQL](https://www.postgresql.org/download/)

Pendant ce temps on en profite pour cloner le projet, depuis un terminal :

```bash
git clone https://github.com/AdrianPaulCarrieres/lpiot2020-memory-adrianpaulcarrieres.git
```

Une fois qu'on a installé Elixir et NodeJS on peut passer aux frameworks, depuis un terminal, pour Elixir :

```bash
mix local.hex
```

Et pour Angular, toujours depuis un terminal :

```bash
npm install -g @angular/cli
```

### Librairies

Il faut maintenant récupérer et installer les librairies pour notre front-end et le pour le back-end.

#### Back-end

Pour le back-end, il faut ouvrir un terminal et se placer dans le dossier "[memory_backend](https://github.com/AdrianPaulCarrieres/lpiot2020-memory-adrianpaulcarrieres/tree/angular/memory_backend)".

Depuis le terminal on lancera :

```bash
mix deps.get
```

#### Front-end

Côté front-end, on se place dans 