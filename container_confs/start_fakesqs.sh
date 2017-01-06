#!/bin/sh
# ----------------------------------------------------------------------------
# start script for fakesqs
# ----------------------------------------------------------------------------
set -e
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

