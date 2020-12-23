# lpiot2020-memory-adrianpaulcarrieres
Memory game for LPIOT2020

## Langages, frameworks

### Angular

### Elixir et le framework Phoenix

Elixir is a dynamic, functional language designed for building scalable and maintainable applications.

Elixir leverages the Erlang VM, known for running low-latency, distributed and fault-tolerant systems, while also being successfully used in web development, embedded software, data ingestion, and multimedia processing domains across a wide range of industries.

Peace of mind from prototype to production
Build rich, interactive web applications quickly, with less code and fewer moving parts. Join our growing community of developers using Phoenix to craft APIs, HTML5 apps and more, for fun or at scale.

J'ai décidé d'utiliser Elixir pour pouvoir gérer du côté backend plusieurs parties et un mode multijoueur.

Le framework Phoenix va venir se greffer à l'application Elixir pour permettre aux joueurs de manipuler la partie en temps réel, grâce aux WebSockets et le module Channel de Phoenix (du Pub/Sub). On aura aussi possiblement une partie API, toujours grâce à Phoenix, pour récupérer les images par exemple.