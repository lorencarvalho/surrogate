#/usr/bin/env bash

# Default var values
confdir="/etc/surrogate"
libdir=/usr/local/lib/surrogate
logdir=/var/log/surrogate


prompt_user() {
  variable=$1
  prompt=$2
  default_value=$3
  test $# -eq 3 || exit 
  read -p "$prompt [$default_value]: " $variable
  test -z "${!variable}" && eval "$variable=$default_value" 
}

# make sure ran as root and check prereqa
test `whoami` == "root" || { echo "Neet to run as root!"; exit 1; }
{ which innobackupex && which rsync; } &>/dev/null || { echo "Prereqs not met! Make sure you have rsync and percona-xtrabackup installed."; exit 1; }

# guess mysql configs
mysql_socket=`mysql -e "status" | grep 'UNIX socket:' |awk '{print $3}'`
mysql_user_system=`stat -c %U $mysql_socket`
mysql_user_db=`grep user ~/.my.cnf | awk '{print $3}'`
mysql_pass_db=`grep pass  ~/.my.cnf | awk '{print $3}'`
datadir=`mysqladmin variables | grep datadir | awk '{print $4}'`

prompt_user mysql_user_db 'MySQL Database User' $mysql_user_db
prompt_user mysql_pass_db "MySQL Database Password for $mysql_user_db" $mysql_pass_db
prompt_user mysql_socket 'MySQL Socket' $mysql_socket
prompt_user datadir 'MySQL datadir' $datadir
prompt_user mysql_user_system "MySQL System User (owner of $datadir)" $mysql_user_system
prompt_user backup_directory 'Directory to store backups' '/backup/mysql'
prompt_user cron_h 'Hour to run full backups at' '8'
prompt_user cron_m 'Minute to run full backups at' '0'
prompt_user install_qpress 'Should qpress be installed? [Y/N]' 'N'

echo "Installing Surrogate..."

# Create required directories, if needed
mkdir -vp $confdir $libdir

# install the software
rsync -a ./files/lib $libdir/
rsync -a ./files/surrogate /usr/local/bin

# configure and preserve existing config files in confdir
rsync -ab --suffix=.bak  ./files/conf/ $confdir/

# not sure if needed.
chmod 600 $confdir/surrogate.conf

sed -i "s|<mysql_socket>|$mysql_socket|" $confdir/surrogate.conf
sed -i "s|<mysql_user_db>|$mysql_user_db|" $confdir/surrogate.conf
sed -i "s|<mysql_pass_db>|$mysql_pass_db|" $confdir/surrogate.conf

sed -i "s|<datadir>|$datadir|" $confdir/surrogate.conf
sed -i "s|<mysql_user_db>|$mysql_user_db|" $confdir/surrogate.conf
sed -i "s|<backup_directory>|$backup_directory|" $confdir/surrogate.conf
sed -i "s|<logdir>|$logdir|" $confdir/surrogate.conf
sed -i "s|<libdir>|$libdir|" $confdir/surrogate.conf
sed -i "s|<libdir>|$libdir|" /usr/local/bin/surrogate

# these should be created during backup runs
#mkdir -p $datadir/backups/monthly
#mkdir -p $datadir/backups/weekly
#mkdir -p $datadir/backups/daily/Mon
#mkdir -p $datadir/backups/daily/Tue
#mkdir -p $datadir/backups/daily/Wed
#mkdir -p $datadir/backups/daily/Thu
#mkdir -p $datadir/backups/daily/Fri
#mkdir -p $datadir/backups/daily/Sat
#mkdir -p $datadir/backups/daily/Sun
#mkdir -p $datadir/log
#mkdir -p $datadir/tmp
#mkdir -p $logdir 
#can break mysql during installation
#chown -R $mysql_user_system:$mysql_user_system $datadir
mkdir -p $backup_directory
touch $backup_directory/.digest

if [ "$install_qpress" == "Y" ]; then
  echo installing qpress
  wget http://www.quicklz.com/qpress-11-linux-x64.tar
  tar xf qpress-11-linux-x64.tar
  mv qpress /usr/local/bin/
fi

echo >> /var/spool/cron/root
echo "$cron_m $cron_h * * * /usr/local/bin/surrogate -b full" >> /var/spool/cron/root

cat <<-EOF

Installation complete!

    "Bring back life form. Priority One. All other priorities rescinded."

    Make sure to update your MySQL credentials in $confdir/surrogate.conf

EOF
