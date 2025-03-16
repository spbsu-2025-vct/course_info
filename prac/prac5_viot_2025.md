
## Работа с образами

**docker images** или **docker image ls** — посмотреть список образов ([ссылка](https://docs.docker.com/engine/reference/commandline/images/), [ссылка](https://docs.docker.com/engine/reference/commandline/image_ls/))

**docker rmi <образ> [образ...]** или docker image rm <образ> [образ...] — удалить образ(ы) ([ссылка](https://docs.docker.com/engine/reference/commandline/rmi/), [ссылка](https://docs.docker.com/engine/reference/commandline/image_rm/))

---

## Работа с контейнерами

**docker run <образ>** — поднять контейнер на основе образа ([ссылка](https://docs.docker.com/engine/reference/commandline/run/))

      docker run **--name <имя>** <образ> — при поднятии присвоить имя контейнеру ([ссылка](https://docs.docker.com/engine/reference/run/#name---name))

      docker run **--rm** <образ> — удалять контейнер после завершения его работы ([ссылка](https://docs.docker.com/engine/reference/run/#clean-up---rm))

      docker run **-it** <образ> — позволяет «войти» в контейнер во время его создания ([ссылка](https://docs.docker.com/engine/reference/commandline/run/#assign-name-and-allocate-pseudo-tty---name--it), [ссылка](https://docs.docker.com/engine/reference/run/#foreground))

      docker run **-d** <образ> — поднять контейнер в фоновом режиме ([ссылка](https://docs.docker.com/engine/reference/run/#detached--d))

**docker ps** — список активных (работающих) контейнеров ([ссылка](https://docs.docker.com/engine/reference/commandline/ps/))

      docker ps **-a** — список всех контейнеров ([ссылка](https://docs.docker.com/engine/reference/commandline/ps/#show-both-running-and-stopped-containers))

**docker stop <контейнер> [контейнер...]** — остановить работающий(ие) контейнер(ы) ([ссылка](https://docs.docker.com/engine/reference/commandline/stop/))

**docker start <контейнер> [контейнер...]** — запустить остановленный(ые) контейнер(ы) ([ссылка](https://docs.docker.com/engine/reference/commandline/start/))

**docker rm <контейнер> [контейнер...]** — удалить контейнер(ы) ([ссылка](https://docs.docker.com/engine/reference/commandline/rm/))

**docker exec <контейнер> команда** — запустить команду в работающем контейнер ([ссылка](https://docs.docker.com/engine/reference/commandline/exec/))

      docker exec **-it** <контейнер> **bash** — запустить bash процесс и «войти» в контейнер ([ссылка](https://docs.docker.com/engine/reference/commandline/exec/#run-docker-exec-on-a-running-container))

Команды: https://docs.docker.com/reference/dockerfile/

Несмотря на то, что и `ENTRYPOINT`, и `CMD` отвечают за запуск программы в контейнере, они используются в разных ситуациях. Особенно это касается случая, когда в одном докерфайле используются обе инструкции одновременно.  

Предлагаю ознакомиться с этим абзацем из документации — [ссылка](https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact).

Также полезно будет заглянуть [сюда](https://stackoverflow.com/questions/21553353/what-is-the-difference-between-cmd-and-entrypoint-in-a-dockerfile).  

|                                |                            |                                    |                                                |
| ------------------------------ | -------------------------- | ---------------------------------- | ---------------------------------------------- |
|                                | **No ENTRYPOINT**          | **ENTRYPOINT exec_entry p1_entry** | **ENTRYPOINT [“exec_entry”, “p1_entry”]**      |
| **No CMD**                     | error, not allowed         | /bin/sh -c exec_entry p1_entry     | exec_entry p1_entry                            |
| **CMD [“exec_cmd”, “p1_cmd”]** | exec_cmd p1_cmd            | /bin/sh -c exec_entry p1_entry     | exec_entry p1_entry exec_cmd p1_cmd            |
| **CMD [“p1_cmd”, “p2_cmd”]**   | p1_cmd p2_cmd              | /bin/sh -c exec_entry p1_entry     | exec_entry p1_entry p1_cmd p2_cmd              |
| **CMD exec_cmd p1_cmd**        | /bin/sh -c exec_cmd p1_cmd | /bin/sh -c exec_entry p1_entry     | exec_entry p1_entry /bin/sh -c exec_cmd p1_cmd |

