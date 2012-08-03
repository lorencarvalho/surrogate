#!/bin/bash
# prepares proper directories and permissions

if [ `whoami` != root ]; then
    echo Please run this script as root or using sudo
    exit
fi


[[ ! -d $backup_directory  ]] && { mkdir -p $backup_directory ; }
[[ ! -d $mysql_sanity_path  ]] && { mkdir -p $mysql_sanity_path ; }
[[ ! -d $mysql_log_path  ]] && { mkdir -p $mysql_log_path ; }
[[ ! -d $mysql_data_path  ]] && { mkdir -p $mysql_data_path ; }

chown -R mysql:mysql $backup_directory
chown -R mysql:mysql $mysql_sanity_path
chown -R mysql:mysql $mysql_log_path
chown -R mysql:mysql $mysql_data_path
