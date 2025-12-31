#!/bin/bash
# Скрипт установки автозапуска / Autostart installation script

echo "Создание службы systemd.../Creating systemd service..."

# Создаем unit-файл
sudo tee /etc/systemd/system/startup.service > /dev/null << 'EOF'
[Unit] 
Description=Startup script for roux
After=local-fs.target  # Только после монтирования локальных файловых систем/ Only after mounting of local file systems

[Service]
Type=oneshot
ExecStart=/home/roux/startup-script.sh
RemainAfterExit=yes
User=roux

StandardOutput=journal
StandardError=journal
TimeoutStartSec=300
TimeoutStopSec=30
Restart=no

[Install]
WantedBy=multi-user.target
EOF

echo "Настройка прав..."
sudo chmod 644 /etc/systemd/system/startup.service
sudo chown root:root /etc/systemd/system/startup.service

echo "Активация службы..."
sudo systemctl daemon-reload
sudo systemctl enable startup.service

echo "Готово! Для запуска: sudo systemctl start startup.service"

# instructions for manual systemd service writing:
# place the script: 
# sudo cp startup.service /etc/systemd/system/
# Set permissions (only root can modify)
# sudo chmod 644 /etc/systemd/system/startup.service
# Set owner to root:root
# sudo chown root:root /etc/systemd/system/startup.service
# After creating the file, run:
# Reload systemd to load new service
# sudo systemctl daemon-reload
# Enable autostart at system boot
# sudo systemctl enable startup.service
# Start service immediately (for testing)
# sudo systemctl start startup.service
# Check service status:
# sudo systemctl status startup.service
# View service logs:
# sudo journalctl -u startup.service -f
