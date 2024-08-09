# Use an official Rust image as the base
FROM rust:1.78-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    pkg-config \
    libssl-dev \
    build-essential \
    ca-certificates \
    curl \
    docker.io \
    vim \
    gnupg  \
    postgresql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Docker Compose 
RUN DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker} && \
    mkdir -p $DOCKER_CONFIG/cli-plugins && \
    curl -SL https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose && \
    chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose && \
    docker compose version

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash && \
    /root/.foundry/bin/foundryup


WORKDIR /usr/src/app
RUN git clone https://github.com/lambdaclass/zksync-era.git

WORKDIR /usr/src/app/zksync-era
RUN git checkout dockerize-toolbox

WORKDIR /usr/src/app/zksync-era/zk_toolbox
RUN cargo install --path ./crates/zk_inception --force --locked

WORKDIR /root
COPY custom-wallets.yaml /root/custom-wallets.yaml
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
# ENTRYPOINT ["/root/entrypoint.sh"]
