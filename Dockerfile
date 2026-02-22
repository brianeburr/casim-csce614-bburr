FROM debian:bookworm-slim

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y build-essential gcc-11 g++-11 python3 python3-venv python3-pip zip unzip && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 \
                        --slave /usr/bin/g++ g++ /usr/bin/g++-11 && \
    ln -s /usr/include/asm-generic /usr/include/asm && \
    rm -rf /var/lib/apt/lists/*

RUN echo '[ -f /app/venv/bin/activate ] && source /app/venv/bin/activate' >> /root/.bashrc && \
    echo '[ -f /app/setup_env ] && source /app/setup_env' >> /root/.bashrc

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sleep", "infinity"]
