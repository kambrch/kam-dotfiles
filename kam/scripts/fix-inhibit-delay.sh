#!/bin/bash
# Run this once with: sudo bash ~/.config/hypr/custom/scripts/fix-inhibit-delay.sh
# Increases logind's InhibitDelayMaxSec so the lock screen has time to render
# before the system suspends.
set -euo pipefail
mkdir -p /etc/systemd/logind.conf.d
printf '[Login]\nInhibitDelayMaxSec=10\n' > /etc/systemd/logind.conf.d/99-inhibit-delay.conf
echo "Created /etc/systemd/logind.conf.conf.d/99-inhibit-delay.conf"
echo "Run 'systemctl restart systemd-logind' to apply (will kill your session!) or reboot."
