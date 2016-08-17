#!/bin/sh

NGC_PLATFORM_SYSTEM=`uname -s 2>/dev/null`
NGC_PLATFORM_RELEASE=`uname -r 2>/dev/null`
NGC_PLATFORM_MACHINE=`uname -m 2>/dev/null`

BASEDIR=$(dirname "$0")

CONF_BASE_DIRECTORY_DEFAULT=
CONF_VHOSTS_DIRECTORY_DEFAULT=

case "$NGC_PLATFORM_SYSTEM" in
    Linux)
        CONF_BASE_DIRECTORY_DEFAULT="/etc"
        CONF_VHOSTS_DIRECTORY_DEFAULT="/srv"
        ;;
    FreeBSD)
        CONF_BASE_DIRECTORY_DEFAULT="/usr/local/etc"
        CONF_VHOSTS_DIRECTORY_DEFAULT="/usr/local/srv"
        ;;
esac

printf "Enter configuration base directory [$CONF_BASE_DIRECTORY_DEFAULT]: "
read CONF_BASE_DIRECTORY
if [ -z "$CONF_BASE_DIRECTORY" ]; then
    CONF_BASE_DIRECTORY="$CONF_BASE_DIRECTORY_DEFAULT"
fi

if [ -d "$CONF_BASE_DIRECTORY/nginx" ]; then
    BACKUP_FILENAME="$(date +'%Y-%m-%d_%H-%M').nginx.tar.gz"
    echo "Backup current configuration to $CONF_BASE_DIRECTORY/$BACKUP_FILENAME"
    tar -C $CONF_BASE_DIRECTORY -czf $CONF_BASE_DIRECTORY/$BACKUP_FILENAME nginx
    rm -fr $CONF_BASE_DIRECTORY/nginx
fi

printf "Enter virtual hosts location [$CONF_VHOSTS_DIRECTORY_DEFAULT]: "
read CONF_VHOSTS_DIRECTORY
if [ -z "$CONF_VHOSTS_DIRECTORY" ]; then
    CONF_VHOSTS_DIRECTORY="$CONF_VHOSTS_DIRECTORY_DEFAULT"
fi

echo "Copying configuration to $CONF_BASE_DIRECTORY/nginx"
cp -R $BASEDIR/nginx $CONF_BASE_DIRECTORY/nginx

sed -i "s~/usr/local/srv~$CONF_VHOSTS_DIRECTORY~g" $CONF_BASE_DIRECTORY/nginx/nginx.conf
