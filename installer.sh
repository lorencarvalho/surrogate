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

echo "installing surrogate"

# check and create dirs
if [ "$(whoami)" != "root" ]; then
  usage
  exit 1
fi

if ! [ -d "$confdir" ]; then
  mkdir -p $confdir
fi

if ! [ -d "$libdir" ]; then
  mkdir -p $libdir
fi

# install the software
rsync -a ./files/ $libdir/

# configure it
cp -R $libdir/conf/* $confdir/

# symlink to include in path
rm /usr/local/bin/surrogate
ln -s /usr/local/share/surrogate/surrogate /usr/local/bin/surrogate

echo "installation complete!"
