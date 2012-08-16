#/usr/bin/env bash
# surrogate
# installer

# vars
confdir=/etc/surrogate/
libdir=/usr/local/share/surrogate

# describe use
function usage() { 
  cat <<-EOF

    sudo please! 

EOF
exit 1
}

function fakeprog() {
  /bin/echo -n "---" && sleep 1
}

echo "installing surrogate"

# hey bro, are you root?
if [ "$(whoami)" != "root" ]; then
  usage
  exit 1
fi

/bin/echo -n "["

if ! [ -d "$confdir" ]; then
  mkdir -p $confdir
fi

fakeprog

if ! [ -d "$libdir" ]; then
  mkdir -p $libdir
fi

fakeprog

# install the software
rsync -a ./files/ $libdir/

fakeprog

# configure it
cp -R $libdir/conf/* $confdir/

fakeprog

# symlink to include in path
if [[ -h /usr/local/bin/surrogate ]];
  then
    rm /usr/local/bin/surrogate
fi

ln -s /usr/local/share/surrogate/surrogate /usr/local/bin/surrogate

/bin/echo -n "]"

echo "installation complete!"

cat <<-EOF

    "Bring back life form. Priority One. All other priorities rescinded."

    Make sure to update your MySQL credentials in /etc/surrogate/surrogate.conf

EOF

# fin
