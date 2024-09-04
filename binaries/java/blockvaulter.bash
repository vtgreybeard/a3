#!/bin/bash
set -f

# Determine A2 image OS version
vers=`lsb_release -a 2> /dev/null| grep Codename | awk '{print $2}'`


# COMMENT THIS IN IN ORDER TO DEBUG
#JDEBUG=true

# Strangle arena memory
export MALLOC_ARENA_MAX=2
MEM=`/usr/local/sbin/javaMem`
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
BASEDIR=$(dirname "$SCRIPT")

JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64




DOPTS1="log4j.configurationFile=$BASEDIR/log4j2.xml"
DOPTS2="user.home=/home/alike/Alike/logs"
DEBUGOPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=1044"
if [ -z "$JDEBUG" ]; then
	DEBUGOPTS=
else 
	echo "Debug mode engaged";
fi
${JAVA_HOME}/bin/java -server -Xmx${MEM} -cp ${BASEDIR}/* $DEBUGOPTS -D${DOPTS1} -D${DOPTS2} quadric.blockvaulter.BlockVaulter $@
