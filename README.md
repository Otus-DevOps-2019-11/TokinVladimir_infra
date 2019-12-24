# TokinVladimir_infra
TokinVladimir Infra repository

#Домашнее задание ssh

ssh-add -L             #ругается Could not open a connection to your authentication agent.
eval $(ssh-agent -s)   #запускаем агента, получаем The agent has no identities.

#автопроброс ключа
nano ~/.ssh/config
Host *
ForwardAgent yes

ssh -t -A appuser@35.210.117.166 ssh appuser@10.132.0.3   #Одной командой заходим через bastion на someinternalhost

Дополнительное задание

#Чтобы можно было зайти на someinternalhost командной sss someinternalhost
nano ~/.ssh/config
Host someinternalhost
        HostName 35.210.117.166
        Port 22
        User appuser
        RequestTTY force
        RemoteCommand ssh appuser@10.132.0.3
        ForwardAgent yes

#Конфигурация cloud-bastion.vpn

bastion_IP = 35.210.117.166
someinternalhost_IP = 10.132.0.3


#Домашнее задание 4 - скрипты

testapp_IP = 34.76.209.235
testapp_port = 9292

#Задание со звездочкой

gcloud compute instances create reddit-app-test-startup\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=startup_script.sh # тут подключаем наш скрипт

#Создать правило фаервола

gcloud compute firewall-rules create default-puma-server \
    --network default \
    --action allow \
    --direction ingress \
    --rules tcp:9292 \
    --source-ranges 0.0.0.0/0 \
    --priority 1000 \
    --target-tags puma-server

# Домашнее задание 5

Добавили переменные variables.json, добавили этот файл в .gitignore

Создали immutable.json который создает готовый образ с задеплоеным приложением, image_family reddit-full


Использовали file который копирует файл с настройками systemd unit

        {
            "type": "file",
            "source": "files/puma.service",
            "destination": "/home/appuser/puma.service"
        }
И далее скрипт который копирует файл, перезапускает systemctl daemon-reload и добавляет в автозапуск

Создали shell-скрипт с названием create-redditvm.sh в директории config-scripts. Который запускает инстанс из нашего образа.

Для проверки сразу проходим в браузере ip:порт и видим что приложение отвечает
