#!/bin/sh
# ----------------------------------------------------------------------------
# entrypoint for container
# ----------------------------------------------------------------------------
set -e

HOST_IP=`/bin/grep $HOSTNAME /etc/hosts | /usr/bin/cut -f1`
echo
echo "container started with ip: ${HOST_IP}..."
echo
for script in /docker-init.d/*; do
	case "$script" in
		*.sh)     echo "... running $script"; . "$script" ;;
		*)        echo "... ignoring $script" ;;
	esac
	echo
done

if [ "$1" == "fakesqs" ]; then
	echo "starting fakesqs with...."
	if [ "${SQS_SHOW_LOGS}" == 1 ]; then
		EXTLOGS="--verbose --log /proc/self/fd/1"
		EXTEND=""
		echo /usr/bin/fake_sqs -o $HOST_IP -p 4568 --database /var/data/sqs/queues $EXTLOGS --no-daemonize
		/usr/bin/fake_sqs -o $HOST_IP -p 4568 --database /var/data/sqs/queues $EXTLOGS --no-daemonize
	else
		EXTLOGS="--no-verbose --log /dev/null"
		EXTEND=">/dev/null 2>&1"
		echo /usr/bin/fake_sqs -o $HOST_IP -p 4568 --database /var/data/sqs/queues $EXTLOGS --no-daemonize
		/usr/bin/fake_sqs -o $HOST_IP -p 4568 --database /var/data/sqs/queues $EXTLOGS --no-daemonize >/dev/null 2>&1
	fi
elif [ "$1" == "bash" ] || [ "$1" == "shell" ]; then
	echo "starting /bin/bash with /etc/profile..."
	/bin/bash --rcfile /etc/profile
else
	echo "Running something else"
	exec "$@"
fi
