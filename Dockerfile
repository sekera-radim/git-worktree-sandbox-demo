FROM debian:stable-slim
RUN apt-get update -qq && apt-get install -y -qq git bubblewrap >/dev/null && rm -rf /var/lib/apt/lists/*
RUN useradd -m dev
USER dev
WORKDIR /home/dev
RUN git config --global user.name "Demo" && git config --global user.email "demo@example.com" && git config --global init.defaultBranch main
COPY --chown=dev scripts /home/dev/scripts
CMD ["bash", "scripts/test.sh"]
