#!/bin/bash

# ===============================
# System Health Monitoring Script
# ===============================

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90

# Log file
LOG_FILE="/var/log/system_health.log"

# Get current metrics
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')
MEM_USAGE=$(free | awk '/Mem/ {print int($3/$2 * 100)}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print int($5)}')
PROCESS_COUNT=$(ps aux --no-header | wc -l)

# Function to log alerts
log_alert() {
    local MESSAGE=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') ALERT: $MESSAGE" | tee -a $LOG_FILE
}

# Check CPU
if [ $CPU_USAGE -gt $CPU_THRESHOLD ]; then
    log_alert "High CPU usage detected: ${CPU_USAGE}%"
fi

# Check Memory
if [ $MEM_USAGE -gt $MEM_THRESHOLD ]; then
    log_alert "High Memory usage detected: ${MEM_USAGE}%"
fi

# Check Disk
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
    log_alert "High Disk usage detected: ${DISK_USAGE}%"
fi

# Check Running Processes
if [ $PROCESS_COUNT -gt 300 ]; then
    log_alert "High number of running processes: ${PROCESS_COUNT}"
fi

# Print summary
echo "System Health Check Completed. CPU: ${CPU_USAGE}%, Memory: ${MEM_USAGE}%, Disk: ${DISK_USAGE}%, Processes: ${PROCESS_COUNT}"
