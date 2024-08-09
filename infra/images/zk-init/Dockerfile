FROM matterlabs/zksync-build-base:latest

ARG ZKSYNC_TAG=core-v24.12.0

# Install dependencies
RUN apt-get update && apt-get install -y git wget jq

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN mv ./kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# Install node and yarn
ENV NODE_MAJOR=18
RUN mkdir -p /etc/apt/keyrings && \
    wget -c -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install nodejs -y && \
    npm install -g yarn

# Download zksync
RUN git clone -b $ZKSYNC_TAG https://github.com/matter-labs/zksync-era /zksync

WORKDIR /zksync

RUN git submodule update --init

RUN cargo build --release -p zksync_server

COPY init.sh .

ENTRYPOINT ["bash", "init.sh"]
