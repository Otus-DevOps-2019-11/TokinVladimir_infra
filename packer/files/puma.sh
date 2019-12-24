#!/bin/bash
#копируем файл
cp /home/appuser/puma.service /etc/systemd/system/puma.service
#рестартим systemd
systemctl daemon-reload
systemctl enable puma.service
