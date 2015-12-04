#/usr/bin/env bash
# surrogate
# installer

# hey bro, are you root?
if [ "$(whoami)" != "root" ]; then
  if [ -f `which sudo` ]; then
    # no dude, need to sudo this ma
    sudo $0 "$@"
    exit $?
  else
    # oh snap, dont gots the sudo powa
    usage
    exit 1
  fi
fi

function prompt_user(){
  variable=$1
  prompt=$2
  default_value=$3

  if [ -z "$variable" ]; then
    echo "Variable name was not given!" && exit 1
  fi

  read -p "$prompt [$default_value]: " $variable

  if [ -z "${!variable}" ]; then
    eval "$variable=$default_value"
  fi

}

prompt_user mysql_user_system 'MySQL System User' 'mysql'
prompt_user mysql_user_db 'MySQL Database User' 'root'
prompt_user datadir 'Directory to store data' '/data'
prompt_user confdir 'Directory to store configs' '/etc/surrogate'
prompt_user libdir 'Directory to store libs' '/usr/local/lib/surrogate'
prompt_user logdir 'Directory to store surrogate logs' '/var/log/surrogate' 
prompt_user cron_h 'Hour to run full backups at' '8'
prompt_user cron_m 'Minute to run full backups at' '0'
prompt_user install_qpress 'Should qpress be installed? [Y/N]' 'N'

# describe use
function usage() { 
  cat <<-EOF

    Need to run as root please! 

EOF
exit 1
}

/bin/echo -ne "Installing Surrogate\t\t[          ] 00%\r" 

# Create required directories, if needed
for dir in "$confdir $libdir"; do
  if ! [ -d "$dir" ]; then
    mkdir -p $dir
  fi

done

/bin/echo -ne "Installing Surrogate\t\t[##        ] 25%\r" 

# install the software
rsync -a ./files/ $libdir/

/bin/echo -ne "Installing Surrogate\t\t[####      ] 50%\r"

# configure it
cp -R $libdir/conf/* $confdir/
chmod 600 $confdir/surrogate.conf
sed -i "s|/data|$datadir|" $confdir/surrogate.conf
sed -i "s|=root|=$mysql_user_db|" $confdir/surrogate.conf
sed -i "s|/data|$datadir|" $libdir/lib/surrogate
sed -i "s|/var/log/surrogate|$logdir|" $confdir/surrogate.conf
sed -i "s|/var/log/surrogate|$logdir|" $libdir/surrogate 
sed -i "s|/usr/local/lib/surrogate|$libdir|" $confdir/surrogate.conf
sed -i "s|/usr/local/lib/surrogate|$libdir|" $libdir/surrogate

/bin/echo -ne "Installing Surrogate\t\t[######    ] 75%\r"

# symlink to include in path
if [[ -h /usr/local/bin/surrogate ]];
  then
    rm /usr/local/bin/surrogate
fi

ln -s /usr/local/lib/surrogate/surrogate /usr/local/bin/surrogate

mkdir -p $datadir/backups/monthly
mkdir -p $datadir/backups/weekly
mkdir -p $datadir/backups/daily
mkdir -p $datadir/backups/daily/{Mon,Tue,Wed,Thu,Fri,Sat,Sun}
mkdir -p $datadir/log
mkdir -p $datadir/tmp
mkdir -p $logdir 
chown -R $mysql_user_system:$mysql_user_system $datadir
touch $datadir/backups/.digest

if [ "$install_qpress" == "Y" ]; then
  echo installing qpress
  wget http://www.quicklz.com/qpress-11-linux-x64.tar
  tar xf qpress-11-linux-x64.tar
  mv qpress /usr/local/bin/
fi

echo adding cron entry
(crontab -l ; echo "$cron_m $cron_h * * * /usr/local/bin/surrogate -b full") | sort - | uniq - | crontab -

/bin/echo -ne "Installing Surrogate\t\t[##########] 100%\r"

cat <<-EOF

Installation complete!

    "Bring back life form. Priority One. All other priorities rescinded."

    Make sure to update your MySQL credentials in $confdir/surrogate.conf

EOF

# fin
