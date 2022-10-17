---
geometry: margi=2cm
author: Matias Negro
---

# Review UML

![[activity.png]]

- Non è stato inserito il database, non so se questo è giusto o meno

![[state_machine.png]]

- Il getSteamData è corretto così? quella funzione viene chiamata sempre onClick() di un gioco precedentemente caricato, che sia da db o che sia dall'Api.
  Non sarebbe più giusto staccarla e mettere i collegamenti sia da "Database update" che da "fetch data"?
