# Étape 1: Builder Rust (GARDER cette partie)
FROM rust:1.76-bookworm AS builder
WORKDIR /app
COPY . .
RUN cargo build --release --manifest-path=passivbot-rust/Cargo.toml

# Étape 2: Image finale avec Python ET Rust binaries
FROM python:3.12-slim

WORKDIR /app

# Copier le binaire Rust compilé
COPY --from=builder /app/target/release/passivbot /app/passivbot

# Installer les dépendances système
RUN apt-get update && apt-get install -y gcc g++ && rm -rf /var/lib/apt/lists/*

# Copier TOUT le code source Python
COPY . .

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Le CMD est dans docker-compose.yml
CMD ["python3", "src/passivbot_multi.py", "configs/live/multi.hjson"]
