#!/bin/bash

# SYSTEM SECURITY & HEALTH AUDITOR
# Author: Student Project
# Description: Performs system health and security checks

REPORT="audit_report_$(date +%F_%T).txt"

echo "==========================================" > $REPORT
echo " SYSTEM SECURITY & HEALTH AUDIT REPORT" >> $REPORT
echo " Generated on: $(date)" >> $REPORT
echo "==========================================" >> $REPORT


# FUNCTION: Print Section Header

print_section() {
    echo "" >> $REPORT
    echo "==========================================" >> $REPORT
    echo "$1" >> $REPORT
    echo "==========================================" >> $REPORT
}


# SYSTEM INFORMATION

system_info() {
    print_section "SYSTEM INFORMATION"

    echo "Hostname: $(hostname)" >> $REPORT
    echo "OS: $(lsb_release -d | cut -f2)" >> $REPORT
    echo "Kernel: $(uname -r)" >> $REPORT
    echo "Uptime: $(uptime -p)" >> $REPORT
}

# CPU CHECK

cpu_check() {
    print_section "CPU USAGE"

    top -bn1 | grep "Cpu(s)" >> $REPORT
}


# MEMORY CHECK

memory_check() {
    print_section "MEMORY USAGE"

    free -h >> $REPORT
}


# DISK USAGE

disk_check() {
    print_section "DISK USAGE"

    df -h >> $REPORT
}


# NETWORK INFORMATION

network_info() {
    print_section "NETWORK INFORMATION"

    ip a >> $REPORT
}


# OPEN PORTS

open_ports() {
    print_section "OPEN PORTS"

    ss -tuln >> $REPORT
}


# RUNNING SERVICES

services_check() {
    print_section "RUNNING SERVICES"

    systemctl list-units --type=service --state=running >> $REPORT
}


# FAILED LOGIN ATTEMPTS

failed_logins() {
    print_section "FAILED LOGIN ATTEMPTS"

    grep "Failed password" /var/log/auth.log >> $REPORT 2>/dev/null
}


# USER ACCOUNTS

user_accounts() {
    print_section "USER ACCOUNTS"

    cut -d: -f1 /etc/passwd >> $REPORT
}


# SUDO USERS
sudo_users() {
    print_section "SUDO USERS"

    getent group sudo >> $REPORT
}


# FIREWALL STATUS

firewall_status() {
    print_section "FIREWALL STATUS"

    ufw status >> $REPORT
}


# INSTALLED PACKAGES

installed_packages() {
    print_section "INSTALLED PACKAGES"

    dpkg -l >> $REPORT
}

# CHECK FOR UPDATES

updates_check() {
    print_section "SYSTEM UPDATES"

    apt list --upgradable >> $REPORT 2>/dev/null
}


# PROCESS MONITORING

process_monitor() {
    print_section "TOP PROCESSES"

    ps aux --sort=-%cpu | head -n 10 >> $REPORT
}

# CRON JOBS

cron_jobs() {
    print_section "CRON JOBS"

    crontab -l >> $REPORT 2>/dev/null
}


# LOG FILE ANALYSIS

log_analysis() {
    print_section "SYSTEM LOG ANALYSIS"

    tail -n 50 /var/log/syslog >> $REPORT
}

# ROOT LOGIN CHECK

root_login_check() {
    print_section "ROOT LOGIN CHECK"

    grep PermitRootLogin /etc/ssh/sshd_config >> $REPORT
}


# PASSWORD POLICY

password_policy() {
    print_section "PASSWORD POLICY"

    grep PASS_MAX_DAYS /etc/login.defs >> $REPORT
    grep PASS_MIN_DAYS /etc/login.defs >> $REPORT
}

# FILE PERMISSIONS CHECK

file_permissions() {
    print_section "SENSITIVE FILE PERMISSIONS"

    ls -l /etc/passwd >> $REPORT
    ls -l /etc/shadow >> $REPORT
}


# USB DEVICES
usb_devices() {
    print_section "USB DEVICES"

    lsusb >> $REPORT
}


# KERNEL MODULES

kernel_modules() {
    print_section "LOADED KERNEL MODULES"

    lsmod >> $REPORT
}


# ENVIRONMENT VARIABLES

env_variables() {
    print_section "ENVIRONMENT VARIABLES"

    printenv >> $REPORT
}


# SYSTEM TEMPERATURE (if available)

temperature_check() {
    print_section "SYSTEM TEMPERATURE"

    sensors >> $REPORT 2>/dev/null
}


# DISK ERRORS

disk_errors() {
    print_section "DISK ERRORS"

    dmesg | grep -i error >> $REPORT
}


# HIDDEN FILES

hidden_files() {
    print_section "HIDDEN FILES IN HOME"

    ls -la ~ >> $REPORT
}


# SUSPICIOUS FILES

suspicious_files() {
    print_section "SUSPICIOUS FILES"

    find /tmp -type f >> $REPORT
}


# NETWORK CONNECTIONS

network_connections() {
    print_section "ACTIVE NETWORK CONNECTIONS"

    netstat -antp >> $REPORT 2>/dev/null
}


# SYSTEM LOAD

system_load() {
    print_section "SYSTEM LOAD"

    uptime >> $REPORT
}


# BATTERY STATUS'

battery_status() {
    print_section "BATTERY STATUS"

    acpi -V >> $REPORT 2>/dev/null
}

#EXECUTION

echo "Running system audit..."

system_info
cpu_check
memory_check
disk_check
network_info
open_ports
services_check
failed_logins
user_accounts
sudo_users
firewall_status
installed_packages
updates_check
process_monitor
cron_jobs
log_analysis
root_login_check
password_policy
file_permissions
usb_devices
kernel_modules
env_variables
temperature_check
disk_errors
hidden_files
suspicious_files
network_connections
system_load
battery_status

echo ""
echo "Audit completed!"
echo "Report saved as: $REPORT"

