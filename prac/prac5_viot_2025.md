# Использование Docker Swarm 

1. Разверните несколько ВМ с Ubuntu (можно использовать [эту утилиту multipass](https://canonical.com/multipass/install))
2. [Установите](https://docs.docker.com/engine/install/ubuntu/) на каждой машине docker
3. На ВМ, которая будет выступать в качестве мастер-ноды выполните команду `docker swarm init`
4. На других ВМ, которые будут выступать в качестве воркеров, выполните команду `docker swarm join --token <TOKEN> host:port`. Она выпадет, когда вы выполните `docker swarm init` на мастер-ноде.
5. Ура! Теперь у вас есть связка.
6. Выполните клонирование вашего репозитория с вашим "стеком" на мастер-ноду ([Пример проекта](https://github.com/spbsu-2025-vct/test-swarm-app.git))
7. Зайдите в него и поднимите стек с помощью команды `sudo docker stack deploy -c docker-stack.yml app`
8. Проверьте наличие сервисов `sudo docker service ls`
9. Увеличьте количество экземляров ваших до двух `sudo docker service scale <ID>=2`
10. Проверьте количество экземляров каждого из сервисов `sudo docker service ps`
11. Попробуйте обратиться по IP-адресу мастера или воркера по endpoint `/version`, `/exit` и `/error`. Можно понаблюдать за изменением количества реплик.
12. Вы супер! 😄

----------

1. [Примеры приложений для развертывания](https://github.com/dockersamples)
2. [Мануал по Docker Swarm](https://docs.docker.com/engine/swarm/ingress/)
