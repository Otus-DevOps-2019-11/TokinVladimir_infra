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

# Домашнее задание 6 Terraform

#Установка terraform
wget https://releases.hashicorp.com/terraform/0.12.8/terraform_0.12.8_linux_amd64.zip
unzip terraform_0.12.8_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -v

#Основные команды

terraform plan  "предварительный просмотр изменений"
terraform apply "применить настройки и запустить инстанс"
terraform show | grep nat_ip "поиск артрибутов по state файлу"
terraform taint google_compute_instance.app "Пересоздать ресурс при следующем применении изменений"
terraform destroy "удалить все созданные ресурсы"
terraform fmt "отформатировать все конфиг. файлы"

#Самостоятельное задание
Определил input переменную для приватного ключа для подключения в провижин (connection)
Определил input переменную для задания зоны в ресурсе "google_compute_instance" "app". У нее значение по умолчанию
Отформатировал все конфигурационные файлы используя команду terraform fmt
создал  terraform.tfvars.example

Опишите в коде терраформа добавление ssh ключа пользователя appuser1 в метаданные проекта. Выполните terraform apply и
проверьте результат (публичный ключ можно брать пользователя appuser)

Применяется только последний ключ из списка, тераформ ничего не знает про ключ добавленый через вэб интерфейс.

Создал файл lb.tf и описал создание балансировщика, приложение отвечает по ip балансировщика. ip балансировщика добавлен как переменная в output

reddit-app2 - много копировать кода, не удобно читать конфиг файл.

Использована переменная count для задания количества инстансов

Домашнее задание 7. Принципы организации инфраструктурного кода и работа над
инфраструктурой в команде на примере Terraform.

Создали новые образы дисков с помощью Packer: reddit-app-base и reddit-db-base

Создали модуль vps, где описали правила фаервола

Настроили хранение стейт файла в удаленном бекенде

При переносе файлов тераформа в другую директорию, Terraform видит текущее состояние

При попытке запустить применение конфигураций stage и prod срабатывает блокировка.

1. Добавили необходимые provisioner в модули для деплоя приложения.
2. Опционально можете реализовать отключение provisioner в зависимости от значения переменной - не делал

Приложение получает адресс БД из переменной окружения DATABASE_URL

  provisioner "remote-exec" {
    inline = [
      "sudo bash -c 'echo DATABASE_URL=${var.db_ip} >> /etc/environments'"
    ]
  }


Домашнее задание 8. Управление конфигурацией. Основные DevOps инструменты. Знакомство с Ansible

ansible app -m command -a 'rm -rf ~/reddit'

удаляет каталог reddit, поэтому после повторного запуска ansible-playbook clone.yml
ok=2  changed=1

Установили ansible, настроили, познакомились с модулями и написали простой плейбук.

Задание со звездочкой не делал


Домашнее задание 9. Деплой и управление конфигурацией с Ansible

Разбили плэйбуки по хостам и задачам.

Изменили провижн образов Packer , вместо скриптов использовали ansible

Использовал модуль gce.py.

ansible.cfg
[defaults]
inventory = ./inventory.compute.gcp.yml
remote_user = appuser
private_key_file = ~/.ssh/appuser
host_key_checking = False
retry_files_enabled = False
deprecation_warnings = False

[inventory]
enable_plugins = gcp_compute


inventory.compute.gcp.yml
---
plugin: gcp_compute
projects:
  - infra-262323
zones:
  - europe-west1-b
groups:
  app: "'-app' in name"
  db: "'-db' in name"
filters: []

hostnames:
  - name
compose:
   ansible_host: networkInterfaces[0].accessConfigs[0].natIP


файл с ключами сервисного пользователя добавил в гитигнор


Домашнее задание 10. Ansible: работа с ролями и окружениями

-Переносим созданные плейбуки в раздельные роли
-Описываем два окружения
-Используем коммьюнити роль nginx
-Используем Ansible Vault для наших окружений

Самостоятельное задание.
* Добавьте в конфигурацию Terraform открытие 80 порта для инстанса приложения
    ports    = ["9292","80"]

* Добавьте вызов роли jdauphant.nginx в плейбук app.yml
---
- name: Configure App
  hosts: app
  become: true
  roles:
   - app
   - jdauphant.nginx

* Примените плейбук site.yml для окружения stage и проверьте,
что приложение теперь доступно на 80 порту - ДОСТУПНО

Подготовим плейбук для создания пользователей, пароль
пользователей будем хранить в зашифрованном виде в файле
credentials.yml

плэйбук отработал, проверил что польщзователи появились cat /etc/passwd

Задание со ⭐: Работа с динамическиминвентори

Иcпользую gce

Kлюч сервисного пользователя infra-.....json добавил в gitignor по маске infra-*.json

Задание со ** не делал
