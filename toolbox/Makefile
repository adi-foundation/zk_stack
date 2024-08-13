# Define the directory where the Makefile is located
BASE_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Define the home directory variable
HOME_DIR := $(shell echo $$HOME)

# Define the Docker image name and container name
DOCKER_IMAGE := zksync-ecosystem
DOCKER_CONTAINER := zksync-ecosystem-container

# Build the Docker image
build:
	@echo "Building the Docker image..."
	@docker build -t $(DOCKER_IMAGE) $(BASE_DIR)
	@echo "Docker image built."

# Build the Docker image
build-no-cache:
	@echo "Building the Docker image..."
	@docker build --no-cache -t $(DOCKER_IMAGE) $(BASE_DIR)
	@echo "Docker image built."

# Run the Docker container
run:
	@echo "Running the Docker container..."
	@echo "To exit [Ctrl + P + Q]"
	@docker run -it --name $(DOCKER_CONTAINER) \
		$(DOCKER_IMAGE)
attach:
	@echo "Attaching to the Docker container..."
	@docker exec -it $(DOCKER_CONTAINER) /bin/bash

# Clean up the Docker container, image, and associated images
clean:
	@echo "Stopping and removing the Docker container..."
	@docker stop $(DOCKER_CONTAINER) || true
	@docker rm $(DOCKER_CONTAINER) || true
	@echo "Removing the Docker image..."
	@docker rmi $(DOCKER_IMAGE) || true
	@echo "Removing dangling Docker images..."
	@docker image prune -f || true
	@echo "Removing unused Docker volumes..."
	@docker volume prune -f || true
	@echo "Removing all Docker networks..."
	@docker network prune -f || true
	@echo "Cleanup complete."

# Default target to create directories, build and run the Docker container
all: clean build-no-cache run 

.PHONY: build run clean all attach
