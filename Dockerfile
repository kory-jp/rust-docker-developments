FROM rust:latest
WORKDIR /workspace
RUN rustup component add rustfmt
