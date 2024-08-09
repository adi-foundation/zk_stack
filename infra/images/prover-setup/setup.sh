#!/bin/sh

ls /setup_data/.ready >/dev/null 2>&1
if [ "$?" == "0" ]
then
	echo "Files already exists"
	exit 0
fi

gcloud storage cp gs://prover-setup-data/setup_data.tar.gz /data.tar.gz || exit 1

cd /setup_data
tar -xvzf /data.tar.gz
touch .ready
