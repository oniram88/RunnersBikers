**Installazione**

docker-compose build


Per far partire tutto:
* docker-compose run --service-ports app

Per far partire ogni singolo servizio (la prima volta):
* docker-compose run -d -p'33306:3306' --name runners_bikers_db db

Per lanciare ogni singolo servizio quando i containers sono già presenti:
* docker restart spchains_db

per poi lanciare il solito " bin/rails s "


Togliendo -d si rimane attaccati all'STDI di ogni servizio


Per lanciare un comando di rails interno:
    usare kitematick oppure:
     bash -c "clear && docker exec -it nome_container /bin/bash"