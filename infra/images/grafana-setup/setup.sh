#!/bin/sh

ls /grafana/.ready >/dev/null 2>&1
if [ "$?" == "0" ]
then
	echo "Files already exists"
	exit 0
fi

rm -rf /tmp/dockprom && git clone https://github.com/stefanprodan/dockprom.git /tmp/dockprom
rm -rf /tmp/era-observability && git clone https://github.com/matter-labs/era-observability.git /tmp/era-observability
cp /tmp/era-observability/dashboards/* /tmp/dockprom/grafana/provisioning/dashboards

yq '.scrape_configs += [{"job_name": "zksync", "scrape_interval": "5s", "honor_labels": true, "static_configs": [{"targets": ["server:3312"]}]}]' \
	/tmp/dockprom/prometheus/prometheus.yml | sponge /tmp/dockprom/prometheus/prometheus.yml

mkdir /grafana/grafana
cp -r /tmp/dockprom/grafana/provisioning/* /grafana/grafana
cp -r /tmp/dockprom/prometheus /grafana
touch /grafana/.ready
