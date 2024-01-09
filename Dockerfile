FROM ubuntu:latest

#definir a instalação sem interação
ENV DEBIAN_FRONTEND noninteractive

#atualizar, instalar os pacotes necessários e limpar o apt após as instalações
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential pkg-config gdb libssl-dev libpcre2-dev \
    libargon2-dev libsodium-dev libc-ares-dev libcurl4-openssl-dev wget tar ca-certificates && \
    apt-get clean

#criar usuário (recomendação não utilizar root), diretório para baixar a instalação e define as permissões
RUN useradd -m -s /bin/bash ircd && \
    mkdir -p /home/ircd/core && \
    chown ircd:ircd /home/ircd/core

#define o usuário e diretório
WORKDIR /home/ircd/core
USER ircd

#baixa o pacote do UnrealIRCd, configura o ambiente, compila e instala
RUN wget --trust-server-names https://www.unrealircd.org/downloads/unrealircd-6.1.4.tar.gz && \
    tar xvzf unrealircd-6.1.4.tar.gz && cd unrealircd-6.1.4 && \
	./Config && make -j$(nproc) && make install

#copia os arquivos de configuração do irc e openssl (para gerar o certificado)
COPY example.conf /home/ircd/unrealircd/conf/unrealircd.conf
COPY openssl.cnf /home/ircd/unrealircd/openssl.cnf

#gera o certificado ssl
RUN /usr/bin/openssl ecparam -out /home/ircd/unrealircd/conf/tls/server.key.pem -name secp384r1 -genkey && \
    /usr/bin/openssl req -new -batch \
        -config /home/ircd/unrealircd/openssl.cnf \
        -sha256 -out /home/ircd/unrealircd/conf/tls/server.req.pem \
        -key /home/ircd/unrealircd/conf/tls/server.key.pem -nodes && \
    /usr/bin/openssl x509 -req -days 3650 \
        -in /home/ircd/unrealircd/conf/tls/server.req.pem \
        -signkey /home/ircd/unrealircd/conf/tls/server.key.pem \
        -out /home/ircd/unrealircd/conf/tls/server.cert.pem

#define o diretório de execução do irc
WORKDIR /home/ircd/unrealircd/

#portas utilizadas para o container
EXPOSE 6667
EXPOSE 6697
EXPOSE 7000

#executa o UnrealIRCd, indica o arquivo de configuração e o sleep é para o container permanecer ativo mesmo que não tenha processo aberto
CMD ["/bin/sh", "-c", "/home/ircd/unrealircd/unrealircd start -F -f /home/ircd/unrealircd/conf/unrealircd.conf -d -foreground && sleep infinity"]