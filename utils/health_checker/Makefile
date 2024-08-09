.PHONY: deps install start stop reload restart uninstall

BUN_BIN := $(shell command -v bun 2> /dev/null)
SERVICE := health_checker

deps: 
	@if [ ! $(BUN_BIN) ]; then \
			echo "bun is not installed. Please install it first."; \
			exit 1; \
	fi
	@echo "Installing project dependencies with bun...";
	bun install

install:
	@echo "Loading and enabling ${SERVICE} to system services..."
	sudo cp ${SERVICE}.service /lib/systemd/system/
	sudo systemctl enable ${SERVICE}

start:
	sudo systemctl start ${SERVICE}

stop: 
	sudo systemctl stop ${SERVICE}

print: 
	journalctl -q -f -u health_checker.service

reload:
	sudo systemctl daemon-reload

restart:
	sudo systemctl restart ${SERVICE}

uninstall:
	@echo "Removing ${SERVICE} from system services..."
	sudo systemctl stop ${SERVICE} || true
	sudo systemctl disable ${SERVICE} || true
	sudo rm -f /lib/systemd/system/${SERVICE}.service
	sudo systemctl daemon-reload

