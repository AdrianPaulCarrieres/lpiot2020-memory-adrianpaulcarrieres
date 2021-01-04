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
mix archive.install hex phx_new 1.5.7
```

Et pour Angular, toujours depuis un terminal :

```bash
npm install -g @angular/cli
```

### Librairies

Il faut maintenant récupérer et installer les librairies pour notre front-end et le pour le back-end.

#### Back-end

Pour le back-end, il faut ouvrir un terminal et se placer dans le dossier "[memory_backend]([memory_backend](https://github.com/AdrianPaulCarrieres/lpiot2020-memory-adrianpaulcarrieres/tree/main/memory_backend))".

Depuis le terminal on lancera :

```bash
mix deps.get
```

#### Front-end

Côté front-end, on se place dans le dossier [memory-frontend](https://github.com/AdrianPaulCarrieres/lpiot2020-memory-adrianpaulcarrieres/tree/main/memory-frontend).

On ouvre un terminal et on lance :

```bash
npm install
```

### Base de données

Il ne nous reste plus qu'à effectuer les migrations de notre base de données, depuis une base de données vide à celle structurée qui va contenir nos decks, cartes, scores et joueurs.

Attention, si vous avez changé les valeurs de nom d'utilisateur et de mot de passe par défaut de PostgreSQL (c'est à dire postgres et postgres), il faudra modifier le fichier memory_backend/config/dev.exs, à partir de la ligne 4 :

```elixir
config :memory_backend, MemoryBackend.Repo,
  username: "postgres", # Changez cette valeur
  password: "postgres", # Et celle ci
  database: "memory_backend_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

Pour cela, on lancera depuis le dossier "memory_backend" la commande :

```bash
mix ecto.create
```

Ça devrait normalement être une des commandes les plus longues à effectuer car elle d'abord compiler nos dépendances.

On pourra ensuite lancer :

```bash
mix ecto.migrate
```

On est maintenant capable d'insérer nos premières données dans la base de données.

Elles consistent tout simplement en un deck, avec pour thème "Gems" et qui contient 8 cartes. On y associera aussi des scores par défaut, avec des joueurs par défaut en nom.

Vous pouvez retrouver les images dans "memory_backend/decks".

Pour procéder à notre insertion, on va utiliser le module "DatabaseSeeder". Le paramétrage y est codé en dur, mais il va tout de même aller ouvrir nos images en format binaire et les insérer dans notre base de données. 

La commande à utiliser pour lancer une session interactive d'iex depuis le terminal (où l'on pourra utiliser Elixir) :

```bash
iex -S mix
```

Si cela ne fonctionne pas (notamment à cause de PowerShell sous Windows) :

```bash
iex.bat -S mix
```

On va ensuite écrire, dans iex :

```elixir
 MemoryBackend.DatabaseSeeder.seed()
```

Les images devraient maintenant être dans la base de données.

On va donc pouvoir lancer le serveur et notre application.

Quittez iex avec Contrôle + C (ou fermez ce terminal et ouvrez en un autre).

## Lancement

On commence par lancer le backend dans le dossier back-end avec :

```bash
mix phx.server
```

Et, avec un autre terminal, dans le dossier front-end cette fois :

```
ng serve -o
```

## Présentation du jeu

Le jeu utilise 5 modules différents pour fonctionner.

### Écran home

On trouvera d'abord le module "home", il affiche un simple input pour que le joueur entre son pseudo.

![image-20201229214500498](C:\Users\darkr\AppData\Roaming\Typora\typora-user-images\image-20201229214500498.png)

On utilise en effet le pseudo pour différencier le joueur au niveau des tours de jeu mais ce pseudo est seulement unique au niveau de la partie. On pourrait en effet jouer à une partie "123" avec le pseudo "Adrian" pendant que quelqu'un d'autre joue à la partie "42" avec le même pseudo.

### Écran lobby

C'est au niveau des lobby que les choses deviennent plus intéressantes :

![image-20201229214549592](C:\Users\darkr\AppData\Roaming\Typora\typora-user-images\image-20201229214549592.png)

C'est dans ce composant qu'on se connecte pour la première fois aux Channels de Phoenix.

En rejoignant le lobby on rejoint le topic "game:general". "Game" est en fait notre topic et "general" le sous topic. On recevra aussi les mises à jour de scores pour chaque deck. *(Interface non implémentée mais cela devrait être mesura depuis la console).*

Au moment de la connexion on recevra aussi la liste des decks, ici il n'y en a qu'un seul, celui avec "Gems" comme thème.

Pour éviter d'envoyer des messages trop lourd, j'ai pris la décision de n'envoyer qu'une partie du deck dans le message. Ainsi, on reçoit en fait son identifiant, son thème et la liste des meilleurs scores (avec les pseudos qui y sont associés). L'application va ensuite aller chercher dans l'API le dos de carte.

On peut accéder à l'API via l'adresse localhost:4000/api/. Les routes peuvent être listées avec mix phx.routes depuis un terminal dans le dossier memory_backend.

![image-20201229215202239](C:\Users\darkr\AppData\Roaming\Typora\typora-user-images\image-20201229215202239.png)

Pour en revenir à l'application, deux options s'offrent à nous :

On peut lancer une nouvelle partie en rentrant un identifiant de partie et en clickant sur un deck, ou on peut rejoindre une partie existante via son identifiant.

Côté serveur, essayer de lancer une nouvelle partie avec un identifiant déjà existant provoque une erreur, mais côté application j'ai longuement bataillé sans succès, ainsi une alerte nous dit bien qu'une partie existe déjà, mais on se retrouve à la rejoindre ensuite.

### Écran jeu

Dans les deux cas, on finira par rejoindre l'écran de jeu :

![image-20201229215954367](C:\Users\darkr\AppData\Roaming\Typora\typora-user-images\image-20201229215954367.png)

Comme vous pouvez le voir, il y a un certain travail sur le CSS qui reste à revoir.

Apparence mise de côté on peut donc voir nos cartes, toutes tirées du deck "Gems", ainsi qu'un compteur de tour et un bouton "Let's go".

Comme ce memory est à vocation "multijoueur" il était nécessaire de prendre des mesures dans le cas où un ou plusieurs joueurs ne joueraient pas leurs tours. De même, si une partie finit abandonnée, il me fallait une solution pour la marquer telle qu'elle et la détruire.

C'est pourquoi toute partie a un état, allant de "stand_by" (en attente du ou des joueurs), "ongoing" (en cours) et "won" en cas de victoire.

Côté serveur, une fois que la partie est lancée, soit via le bouton "Let's go", soit avec un premier click sur une carte, on déclenchera un timer, d'une durée de 30 secondes, qui dira au serveur de "sauter" le tour en cours.

On peut donc commencer notre partie, et c'est malheureusement là qu'on va pouvoir s'apercevoir des défauts de mon système :

Les cartes clignotent à chaque mise à jour du jeu. L'explication est relativement simple : à cause de l'aspect fonctionnel d'Elixir, côté serveur c'est une structure représentant le jeu qui est transformée et presque retournée à chaque fonction. 

Je me suis donc plus ou moins naturellement dit qu'il était aussi normal de transmettre cette structure dans les messages échangés entre l'application et le serveur. 

A cela s'est ajouté la volonté de réduire  la taille de mes messages en évitant de transmettre les images (que ce soit en binaire comme dans la base de données ou en base64 comme depuis l'API), l'application met à jour le jeu en entier et remet les images à chaque fois qu'on reçoit un message, soit en fait à chaque fois qu'on tourne une carte.

J'ai aussi un peu mal géré les images côté client et après m'être creusé la tête toute une journée j'en suis arrivé au point où je récupère les images à chaque fois qu'on tourne une carte.

Nous y reviendrons plus tard, dans une partie consacrées aux améliorations à apporter à mon projet.

![image-20201229221626192](C:\Users\darkr\AppData\Roaming\Typora\typora-user-images\image-20201229221626192.png)

(Les images m'ont par ailleurs été gracieusement offertes par Christophe Marois, [ArtStation - Christophe Marois](https://www.artstation.com/qaqelol)).

La composante multijoueur peut être testée en ouvrant simplement d'autres onglets à l'adresse localhost:4200.

![image-20201229221927663](C:\Users\darkr\AppData\Roaming\Typora\typora-user-images\image-20201229221927663.png)

Vous pouvez créer ou rejoindre plusieurs parties en même temps sans aucun problème (ça, au moins, ça fonctionne).

A la fin de la partie, (si elle est gagnée et pas abandonnée), si un score a été battu il est envoyé sur le topic correspondant au thème du deck (game:theme), ici game:Gems.

Il peut donc être capté par les joueurs encore dans le lobby et supposément par les joueurs dans une partie avec le même deck que le votre.

Malheureusement, j'ai rencontré beaucoup de difficulté à utiliser une certaine fonctionnalité d'Angular qui me permettrait de mettre à jour très facilement un écran de score, et je n'ai donc pas vraiment pu développer du côté client cette fonctionnalité (mais en ouvrant la console, depuis le lobby, vous devriez voir un message apparaitre en gagnant une partie dans un autre onglet).

### Petit bonus : Phoenix Live Dashboard

Phoenix permet aussi d'avoir un genre de dashboard plutôt pratique pour suivre l'état de notre application, il est accessible à l'adresse : http://localhost:4000/dashboard/home.

Je le trouve plutôt complet, et c'est là qu'il est encore plus intéressant pour mieux comprendre le fonctionnement de mon memory, c'est qu'il possède aussi un arbre des process (je reviendrai dessus dans la partie sur le backend) :

![image-20201229222528694](C:\Users\darkr\AppData\Roaming\Typora\typora-user-images\image-20201229222528694.png)

Dans l'onglet "Applications", cherchez "memory" puis clickez sur le ✓ :

En naviguant un tout petit peu vous devriez pouvoir apercevoir l'arbre des process des parties :

![image-20201229222717892](C:\Users\darkr\AppData\Roaming\Typora\typora-user-images\image-20201229222717892.png)

Ici on peut voir qu'il y a 4 parties qui tournent en parallèle.

## Algorithmes et backend

On arrive dans la partie un peu plus difficile à expliquer parce qu'elle repose principalement sur Elixir pour se faire.

### Atomes

En Elixir un Atome est une constante dont la valeur est son propre nom.

Je m'en sers notamment pour l'état de ma partie, qui peut donc être `:ongoing` ou `:stand_by` par exemple. On verra leur importance plus bas.

### Retour

En Elixir le retour d'une fonction correspond en fait à sa dernière ligne (ou dans certains cas, par exemple un if, la dernière ligne dans le if ou la dernière ligne dans le else en fonction de exécution du code).

### Pattern matching

En Elixir l'opérateur "=" ne sert pas vraiment qu'à assigner une valeur à une variable.

Il sert en fait à matcher le membre de droite au membre de gauche.

Ainsi, si dans iex on tape :

```elixir
iex> x = 1
1
iex> 1 = x
1
iex> 2 = x
** (MatchError) no match of right hand side value: 1
```

On aura une erreur parce qu'effectivement, 2 est différent de 1, qui est la valeur de x.

On pourrait se dire que jusqu'à la fin ça semble assez simple, mais en fait tout l'intérêt réside dans ce qu'on peut faire de plus avec.

### Gérer une partie

Créer une partie est finalement assez simple, on crée tout simplement une nouvelle struct (un peu comme en C), qui contient toutes les données dont on a besoin. 

On commence à ce moment là à utiliser les fonctionnalités d'Elixir :

Pour que nos joueurs puissent interagir avec une partie, nous avons plusieurs possibilités :

- On peut la persister, soit dans une base de données classique, soit dans un système de cache comme Redis, et la récupérer à chaque requête
- On peut sinon la garder dans un "thread "à part (en Elixir on utilise des process) et utilise l'identifiant de ce process pour la retrouver et interagir avec.

En Elixir chaque process possède un genre de boite aux lettres, et on va donc pouvoir déposer des requêtes dedans, que le process va gérer les unes après les autres, sans que nous ayons à intervenir sur ce point là. Les créateurs d'Elixir ont fait un travail formidable en nous fournissant avec ça plusieurs couches d'abstractions plus ou moins différentes pour manipuler ces process.

La première est un Agent. Il va en fait servir uniquement à conserver un état, et on va pouvoir demander au process de nous le donner ou de changer l'état par un nouvel état. Ici, ça sera une partie.

On utilise ensuite un GenServer, qui lui présente en fait un genre d'API pour effectuer plusieurs requêtes différentes sur un état qu'il conserve lui aussi. L'intérêt par rapport à un process classique c'est que nous n'avons pas besoin d'implémenter nous même le tri de la boite aux lettres.

Notre GenServer, que j'ai appelé Index, va en fait conserver une map {identifiant_partie => pid_agent}, ce qui va nous permettre à chaque requête concernant une partie de récupérer l'agent qui conserve la dite, et de demander à celui ci la partie en question. A la fin du traitement on remettra la partie modifiée à l'Agent pour s'en servir plus tard.

J'ai divisé cette manipulation des parties en 3 fichiers :

* memory_backend\lib\memory_backend\index.ex : Il s'agit en fait de l'API de mon GenServer, c'est ces fonctions que le reste de mon application appelle pour interagir avec une partie
* memory_backend\lib\memory_backend\index\server.ex : Il s'agit du fichier décrivant comment le GenServer fonctionne, c'est ici qu'on va mapper l'identifiant de la partie à un Agent, et qu'on va tout simplement appliquer des transformations sur la partie en fonction de la requête. C'est aussi ici qu'on gère le fait qu'un joueur ne joue pas son tour, et le fait qu'une partie se termine. L'Agent est "tué" et on retire de la map l'association {identifiant_partie => pid de l'agent}
* memory_backend\lib\memory_backend\index\impl.ex : C'est ici qu'on va vraiment manipuler la partie. Le code a surtout été séparé du fichier server.ex pour des raisons de lisibilités et de longueur.

### Joueurs inactifs

La gestion des joueurs inactifs se base simplement sur l'envoie d'un message après 30 secondes contenant l'identifiant de la partie et le numéro du tour. Ainsi, si le joueur a fini son tour, la partie aura un compteur de tour plus élevé que le numéro envoyé et on pourra ne pas prendre en compte le message d'inactivité. Autrement, on pourra faire sauter le tour actuel et passer au suivant.

J'ai aussi décidé que si tous les joueurs de la partie étaient inactifs pendant 2 tours, la partie était arrêtée. Cela libérera des ressources pour d'autres parties !

### Jouer son tour

C'est là que ça se complique et qu'on va enfin pouvoir vraiment voir le pattern matching à l'oeuvre !

Je vais séparer la fonction play turn pour expliquer rapidement ce qu'il se passe :

```elixir
  def play_turn(
        game = %Game{
          players: players,
          cards_list: cards,
          last_flipped_indexes: last_flipped_indexes,
          turn_count: turn_count
        },
        active_player,
        card_index,
        turn
      ) do
```

Ici il s'agit simplement de la "tête de la fonction", on va pouvoir utiliser le pattern matching pour dire à Elixir qu'on a un argument game, qui est ici une struct Game, un argument active_player pour déterminer quel joueur a essayé de joueur son tour, card_index pour déterminer quelle carte on souhaite retourner et le numéro du tour.

Le pattern matching est mis à l'oeuvre avec la struct game : en fait on pouvoir, au sein même de mon argument game, donner des valeurs à d'autres variables en suivant le pattern donné.

Voyez cela comme un genre de texte à trous, où mes trous vont être remplis par les valeurs actuelles de ma struct game.

```elixir
if turn_count == turn do
      ...
      end
    else
      {:error, {:turn_passed, "Turn already passed"}}
    end
  end
```

On va ensuite vérifier que le tour actuel du jeu correspond bien au tour de la requête. Les joueurs pourraient en effet être désynchronisés pour des raisons en dehors de notre contrôle, comme par exemple un délai dans le réseau ou un message qui s'est perdu.

```elixir
if turn_count == turn do
      case players do
        [^active_player | _] ->
          with {:ok, cards} <- flip_card(cards, card_index),
               last_flipped_indexes = Tuple.append(last_flipped_indexes, card_index),
               game = %Game{
                 game
                 | cards_list: cards,
                   last_flipped_indexes: last_flipped_indexes,
                   consecutive_afk_players: 0
               },
               {status, game} = next_turn(game) do
            {:ok, {status, game}}
          else
            _error ->
              {:error, {:wrong_card, "This card is already flipped"}}
          end

        [_] ->
          {:error, {:wrong_player}}
      end
    else
      {:error, {:turn_passed, "Turn already passed"}}
    end
  end
```

On utilise encore le pattern matching avec le case :

La variable (ou la fonction) entre le case et le do va être évaluée suivant plusieurs patterns, qu'on renseigne sous cette forme ::

```elixir
case variable do
	pattern1 -> action à réaliser
	pattern2 -> action à réaliser
end
```

Ici, notre pattern1 est en fait composé de plusieurs choses :

```elixir
^active_player # signifie qu'on va matcher la valeur de la variable active_player (grâce à l'opérateur ^) à notre variable 
_ # signifie qu'on va discarder la valeur qui match ici. C'est un peu comme une variable "poubelle" ou un match Joker
[^active_player | _] # Va en fait prendre la liste players et matcher la tête de la liste (donc la première valeur de la liste, à l'index 0) à la valeur de active_player ; et le reste de la liste ne sera pas utilisé
```

On a donc un moyen très simple de dire "si le joueur qui a demandé la requête est le joueur actif", réalise l'action

Sinon, on voit qu'on a un deuxième pattern [_] qui va donc matcher avec n'importe quelle autre valeur, en 2e par rapport à notre premier pattern. Ça signifie donc que dans ce cas le joueur qui a demandé la requête n'est pas le joueur actif et on peut donc renvoyer une erreur.

```elixir
with {:ok, cards} <- flip_card(cards, card_index),
               last_flipped_indexes = Tuple.append(last_flipped_indexes, card_index),
               game = %Game{
                 game
                 | cards_list: cards,
                   last_flipped_indexes: last_flipped_indexes,
                   consecutive_afk_players: 0
               },
               {status, game} = next_turn(game) do
            {:ok, {status, game}}
          else
            _error ->
              {:error, {:wrong_card, "This card is already flipped"}}
```

Notre action à réaliser semble assez complexe, mais ne l'est pas vraiment (je me suis rendu compte un peu trop tard que j'aurais pu rassembler mon case et ce bloc là ensemble, plutôt que de les imbriquer).

Pour résumer, ce bloc fonctionne un peu comme notre case, si flip_card(cards, card_index) ne renvoie pas une erreur on continue de transformer notre partie vers le tour suivant. On va ajouter à un tuple l'index de la carte qui vient d'être retournée, et on mettra ensuite notre struct game à jour.

Elixir étant un langage où nos variables sont immutables, mettre à jour notre struct game veut en fait signifier qu'on renvoie une nouvelle struct avec les champs spécifiés de différents. Il y a une certaine optimisation faite derrière qui rend la chose viable, heureusement.

La fonction complète, qui encore une fois aurait pu être grandement améliorée :

```elixir
  def play_turn(
        game = %Game{
          players: players,
          cards_list: cards,
          last_flipped_indexes: last_flipped_indexes,
          turn_count: turn_count
        },
        active_player,
        card_index,
        turn
      ) do
    if turn_count == turn do
      case players do
        [^active_player | _] ->
          with {:ok, cards} <- flip_card(cards, card_index),
               last_flipped_indexes = Tuple.append(last_flipped_indexes, card_index),
               game = %Game{
                 game
                 | cards_list: cards,
                   last_flipped_indexes: last_flipped_indexes,
                   consecutive_afk_players: 0
               },
               {status, game} = next_turn(game) do
            {:ok, {status, game}}
          else
            _error ->
              {:error, {:wrong_card, "This card is already flipped"}}
          end

        [_] ->
          {:error, {:wrong_player}}
      end
    else
      {:error, {:turn_passed, "Turn already passed"}}
    end
  end
```

### Tour suivant

On utilise encore la magie du pattern matching pour différencier deux situations :

- On a retourné deux cartes
- On a retourné une seule carte

On va pour cela utiliser la tête de la fonction :

```elixir
def next_turn(
        game = %Game{
          turn_count: turn_count,
          players: players,
          last_flipped_indexes: {first_index, second_index},
          cards_list: cards,
          flipped_count: flipped_count,
          state: state
        }
      ) do
```

La fonction ne sera appelée que si le champ last_flipped_indexes de la struct game passée en paramètre est un tuple de taille 2.

On en profite pour attribuer les valeurs à l'intérieur du tuple à deux variables qui vont représenter les index des deux dernières cartes retournées.

```elixir
	turn_count = turn_count + 1
    players = change_active_player(players)

    [flipped_count, cards] = update_flipped_count(flipped_count, cards, first_index, second_index)

    flipped_index = {}

    game = %Game{
      game
      | turn_count: turn_count,
        players: players,
        last_flipped_indexes: flipped_index,
        cards_list: cards,
        flipped_count: flipped_count
    }

    if flipped_count == length(cards) / 2 do
      state = :won
      game = %Game{game | state: state}
      {state, game}
    else
      {state, game}
    end
  end
```

On va mettre le compteur de tour à jour, changer le joueur en tête de liste. 

Pour cela on considère la liste comme une queue, c'est à dire que le premier joueur arrivé dans la liste est le premier sorti, et on va ensuite le replacer à la fin pour faire un cycle.

On va ensuite comparer les cartes, et si leur identifiant correspond mettre à jour le compteur de paire trouvée, autrement on va les retourner à nouveau.

On vide notre tuple des dernières cartes retournées, puisqu'un nouveau tour commence, puis on met à jour la partie.

Enfin, si on a trouvé toutes les paires (soit le nombre de carte divisé par deux), la partie est gagnée. Autrement elle continue.

Ici j'aurais pu sortir la vérification sur le fait que la partie soit gagnée ou non dans une autre fonction et faire entrer le résultat de l'une dans l'autre mais je n'y ai pas pensé sur le coup.

Dans le cas où le joueur actif n'a pas encore retourné deux cartes, on n'aura pas de match sur `last_flipped_indexes: {first_index, second_index}`, Elixir appellera donc la prochaine fonction next_turn jusqu'à en trouver une qui match, et ça tombe bien, la suivante matchera dans tous les cas :

```elixir
  def next_turn(game = %Game{state: state}) do
    {state, game}
  end
```

Dans les deux cas on retourne l'état de la partie en plus de la partie pour pouvoir matcher sur l'état et réaliser différentes actions en fonction de celui-ci, notamment en cas de victoire.

Les 2 fonctions :

```elixir
  def next_turn(
        game = %Game{
          turn_count: turn_count,
          players: players,
          last_flipped_indexes: {first_index, second_index},
          cards_list: cards,
          flipped_count: flipped_count,
          state: state
        }
      ) do
    turn_count = turn_count + 1
    players = change_active_player(players)

    [flipped_count, cards] = update_flipped_count(flipped_count, cards, first_index, second_index)

    flipped_index = {}

    game = %Game{
      game
      | turn_count: turn_count,
        players: players,
        last_flipped_indexes: flipped_index,
        cards_list: cards,
        flipped_count: flipped_count
    }

    if flipped_count == length(cards) / 2 do
      state = :won
      game = %Game{game | state: state}
      {state, game}
    else
      {state, game}
    end
  end

  def next_turn(game = %Game{state: state}) do
    {state, game}
  end
```

### Victoire

En cas de victoire, on enregistre le score dans la base de données, puis, on vérifie s'il se trouve dans les 10 premiers ou non. Ce n'est clairement pas le meilleur choix à faire, mais je me pensais que quitte à retourner les meilleurs scores aux joueurs à la fin de leur partie accompagné du leur pour pouvoir comparer, en plus de le sauvegarder dans la base de données, ce n'était pas forcément plus mal.

### Les Channels

On peut retrouver tout le code relatif au mécanisme de Pub/Sub des channels dans le fichier memory_backend\lib\memory_backend_web\channels\game_channel.ex.

```elixir
def join("game:general", _payload, socket) do
    decks = MemoryBackend.Model.list_decks_with_scores()

    topics = for deck <- decks, do: "game:#{deck.theme}"

    {:ok, %{decks: decks},
     socket
     |> assign(:topics, [])
     |> subscribe_to_high_scores_topics(topics)}
  end
  
def join("game:" <> game_id, _params, socket) do
```

Pour faire simple, on match encore une fois le fait de s'abonner à un topic à deux fonctions :

La première pour le sous topic général, là où on recevra la liste des decks, les mises à jour de tous les meilleurs scores de chaque deck, et ensuite une fonction qui va permettre de savoir qu'on rejoint un sous topic dédié à une partie en particulier. On utilise aussi le pattern matching pour déterminer l'identifiant de la partie.

Dans la connexion au serveur, représentée par la variable socket on retrouvera aussi le pseudo du joueur (socket.assigns.player).

```elixir
def handle_in("start_game", _payload, socket = %Phoenix.Socket{topic: "game:" <> game_id}) do
    case Index.start_game(game_id) do
      {:ok, game} ->
        broadcast!(socket, "start_game", %{game: game})
        {:reply, {:ok, game}, socket}

      {:error, msg} ->
        {:reply, {:error, msg}, socket}
    end
  end
```

Basiquement on va se servir du pattern matching pour déterminer :

- L'événement, ici start_game
- Des possibles paramètres, ici payload n'est pas utilisé, mais pour retourner des cartes on en aura besoin
- L'identifiant de la partie en fonction du topic renseigné dans la socket

On appelle grâce à ces variables l'API de notre GenServeur qui relie l'identifiant d'une partie au process qui l'héberge et on match sur les valeurs que notre API nous retourne pour renvoyer les messages appropriés.

Ici on utilise aussi `broadcast!(socket, "start_game", %{game: game})` pour dire à Phoenix d'envoyer un message à tous les utilisateurs connectés au même topic:sous_topic. On s'en sert donc pour communiquer à tous les joueurs d'une partie ce qu'il se passe, ou alors pour communiquer à tous les utilisateurs du lobby la mise à jour des scores.

## Front-End

Côté front-end la partie la plus importante repose sur l'utilisation d'Observables :

```typescript
join_game(game_id: String): Observable<Game> {
    return new Observable((observer: Observer<Game>) => {
      this.channel = this.socket.channel("game:" + game_id);
      this.channel.join()
        .receive("ok", resp => {
          console.log("Joined game successfully");
          this.topic = "game:" + game_id;
          this.game = Game.parse_game(resp.game);
          return observer.next(this.game);
        })
```

L'intérêt en fait réside dans le fait que lorsque notre socket va recevoir un message de la part de notre backend, tout module ou composant qui s'abonne à notre Observable soit notifié de la réponse du backend.

```typescript
this.channelService.join_game(game_id)
      .pipe(delay(500))
      .subscribe(game => {
        this.game = game;
        this.turn = game.turn_count;
        this.get_images();
        return game;
      });
  }
```

On va donc pouvoir dans notre composant Game mettre à jour nos cartes quand on recevra la mise à jour de la partie par un autre joueur.

Ce fut je pense une des parties les plus compliquées du projet, j'ai dû passer une bonne journée à essayer de les faire fonctionner correctement, sans vraiment le succès que j'attendais, et ça nous amène à la prochaine partie.

## Les améliorations

### Contenu des messages

Une des premières choses que je referais c'est le contenu des messages. Comme dit plus haut, j'envoie actuellement le jeu en entier (sans les images) à chaque message, ce qui provoque des problèmes de clignotement du côté front-end. C'est plutôt frustant.

A la place j'aurais dû transmettre les transformations à effectuer sur le jeu. Le front-end aurait ainsi un peu de logique à appliquer et mettrait à jour lui même son état, plutôt que ce qu'il se passe actuellement où en fait le back-end lui tend directement un état à afficher à et à consommer.

### Concurrence

Malgré tout ce que j'ai pu dire sur les process, j'ai mal géré les miens. Une "simple" erreur de compréhension et une envie d'aller trop vite m'ont conduit à suivre une moitié du tutoriel sans lire quelques liens plus bas.

En effet, ce qu'il se passe actuellement dans mon back-end, c'est que mes parties vivent chacune dans leur Agent, qui sont donc eux distribués entre mes coeurs de processeurs, tandis que mon GenServer Index, qui permet de retrouver une partie et d'appliquer des transformations dessus lui est unique. C'est un seul process qui s'occupe de transformer chaque partie.

Non seulement ça pourrait être problématique avec une montée de charge, où le process serait en fait totalement noyé entre les messages de chaque joueur, les messages d'inactivités et les transformations ; mais ça pose aussi un problème de jouabilité : il n'y a aucun moyen de délayer le retournement de deux cartes si elles ne correspondent pas. Côté backend ça marche pour le joueur actif, parce que l'Observable à un délai entre plusieurs émissions, mais côté serveur je ne peux pas mettre de délai dans le traitement d'une requête parce qu'il n'y a qu'un seul process qui les gère.

## Conclusion

Ce fut possiblement un des meilleurs projets que j'ai pu faire. 

J'ai rencontré beaucoup de difficultés avec Angular (et je ne parle même pas du CSS que j'ai à peine effleuré), mais j'ai découvert un framework Web qui me plait véritablement et qui parait se marier très bien avec Phoenix.

Côté backend, ce fut mon premier gros projet d'Elixir et de Phoenix (au Québec j'avais seulement généré l'API avec Phoenix), et je dois dire que j'ai énormément appris et que je me suis beaucoup amusé.

Elixir a vraiment changé ma manière de voir certaines choses et je suis aussi très content de me rendre compte après avoir codé que j'aurais dû mieux faire les choses, ce qui parait quand même assez ironique.

Je reste toutefois frustré du résultat qui me déçoit un petit peu, je pense que j'ai passé trop de temps sur des erreurs un peu stupides d'Observable. J'ai peut-être aussi mis la barre un peu haute pour un projet pour lequel j'avais assez peu de temps finalement (on parle quand même d'un langage de programmation au paradigme différent et de deux frameworks). J'ai quand même assez de fierté d'avoir réussi à gérer ça et d'avoir ingéré autant de connaissances en si peu de temps.

J'ai aussi plutôt bien géré mon github, je ne pensais pas être capable de le faire pour un projet en solo.

En tout cas ce fut les 48h et plus de code les plus intensives et intéressantes de ma vie !