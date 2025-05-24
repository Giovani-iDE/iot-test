# Etapa de build
FROM rust:1.87 AS builder

RUN apt-get update && \
    apt-get install -y \
    pkg-config \
    libssl-dev \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY Cargo.toml Cargo.lock .
COPY src ./src
COPY bin ./bin

RUN cargo build --release

# Etapa final
FROM debian:bookworm-slim

# Instalar dependencias y ngrok versión 3.x+
RUN apt-get update && \
    apt-get install -y curl ca-certificates libssl3 && \
    curl -s https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz \
    | tar -xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/ngrok && \
    rm -rf /var/lib/apt/lists/*

# Copiar el binario compilado
COPY --from=builder /usr/src/app/target/release/rust /usr/local/bin/rust

# Copiar certificados TLS
COPY --from=builder /usr/src/app/bin/server.crt /etc/ssl/certs/
COPY --from=builder /usr/src/app/bin/ca.crt /etc/ssl/certs/
COPY --from=builder /usr/src/app/bin/server.key /etc/ssl/private/
RUN chmod 600 /etc/ssl/private/server.key && \
    chown root:root /etc/ssl/private/server.key

# Copiar script de inicio
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8883

CMD ["/start.sh"]
