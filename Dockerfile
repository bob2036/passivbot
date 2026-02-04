# Étape 1: Builder Rust
FROM rust:1.76-bookworm AS builder

WORKDIR /app

# Copier tout le code
COPY . .

# Compiler les extensions Rust
RUN cd passivbot-rust && cargo build --release

# Étape 2: Image finale Python avec les binaires Rust
FROM python:3.12-slim

WORKDIR /app

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copier tout le code source
COPY . .

# Copier les binaires Rust compilés
COPY --from=builder /app/passivbot-rust/target/release /app/passivbot-rust/target/release

# Installer les dépendances Python pour live trading
RUN pip install --no-cache-dir -r requirements-live.txt

# Le CMD est défini dans docker-compose.yml
CMD ["python3", "src/passivbot_multi.py", "configs/live/multi.hjson"]
