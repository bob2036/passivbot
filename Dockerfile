FROM python:3.12-slim

WORKDIR /app

# Installer Rust et dépendances système
RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    g++ \
    build-essential \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && rm -rf /var/lib/apt/lists/*

# Ajouter Rust au PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Copier tout le code source
COPY . .

# Installer TOUTES les dépendances Python (backtest + optimize + live)
RUN pip install --no-cache-dir -r requirements.txt

# Compiler les extensions Rust
RUN cd passivbot-rust && cargo build --release

# CMD par défaut (peut être overridé dans docker-compose.yml)
CMD ["python3", "src/main.py", "configs/template.json"]
