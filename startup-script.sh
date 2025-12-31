#!/bin/bash
# Скрипт запуска программы и загрузки cron-заданий
# Startup script for running program and loading cron jobs
# /home/roux/startup-script.sh

set -e  # Прерывать выполнение при ошибках / Exit on error

# Логирование / Logging
LOG_FILE="/home/roux/startup-script.log"
echo "[$(date)] Запуск startup-script.sh / Starting startup-script.sh" >> "$LOG_FILE"

# 1. Запускаем программу mbr_write.py / Run mbr_write.py program
echo "[$(date)] Запуск mbr_write.py... / Running mbr_write.py..." >> "$LOG_FILE"
if [ -f "/home/roux/MBR/mbr_write.py" ]; then
    cd /home/roux/MBR/
    nohup python3 mbr_write.py >> "$LOG_FILE" 2>&1 & # Запуск в фоне с перенаправлением вывода в лог
    echo "[$(date)] mbr_write.py выполнен успешно / mbr_write.py completed successfully" >> "$LOG_FILE"
else
    echo "[$(date)] ОШИБКА: Файл mbr_write.py не найден / ERROR: mbr_write.py file not found" >> "$LOG_FILE"
fi

# 2. Загружаем задания в crontab пользователя roux / Load jobs into roux user's crontab
echo "[$(date)] Загрузка crontab... / Loading crontab..." >> "$LOG_FILE"
if [ -f "/home/roux/crontab" ]; then
    # Загружаем задания в crontab пользователя roux / Load jobs into roux user's crontab
    crontab -u roux /home/roux/crontab
    echo "[$(date)] Crontab загружен успешно / Crontab loaded successfully" >> "$LOG_FILE"
    echo "[$(date)] Текущие задания cron: / Current cron jobs:" >> "$LOG_FILE"
    crontab -u roux -l >> "$LOG_FILE" 2>/dev/null || echo "Нет заданий cron / No cron jobs" >> "$LOG_FILE"
else
    echo "[$(date)] ОШИБКА: Файл crontab не найден / ERROR: crontab file not found" >> "$LOG_FILE"
fi

echo "[$(date)] Скрипт завершен / Script completed" >> "$LOG_FILE"
