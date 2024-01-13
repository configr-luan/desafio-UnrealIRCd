# Desafio UnrealIRCd
O IRC (Internet Relay Chat) é um protocolo de comunicação em tempo real baseado em texto, desenvolvido na década de 1980. Ele permite a comunicação entre usuários por meio de salas de bate-papo (chamadas de canais) e mensagens diretas (privado).

No IRC, os usuários se conectam a servidores específicos usando um cliente de IRC (software) e podem participar de diferentes canais de conversa ou criar os seus próprios. Cada canal tem um nome único e pode ter moderadores que ajudam a manter a ordem e aplicam regras específicas.

O desafio consiste na criação de um servidor de IRC, utilizando o UnrealIRCd, e se dará da seguinte forma:

## Rodando o UnrealIRCd em um cloud da Configr

O processo será da seguinte forma:

1) Faça um fork desse repositório e mande o link do repositório para Rodrigo e Gio no gchat;
2) Documente todo o processo, o passo a passo executado, no README;
3) Provisione um novo Cloud usando sua conta da empresa, mas se tiver algum cloud ativo, pode usar;
4) Entregue o IRCd funcional e acessível na porta 6667 no IP do cloud; (Nós iremos acessar através de um cliente de IRC para validar)
5) Com base na configuração de exemplo, o arquivo: ```example.conf```, que consta no repositório, você deverá deixar a rede de IRC com o nome de Configr.

## Diferencial: Criar um  Dockerfile, buildar a imagem sem falhas e executar o UnrealIRCd localhost
Há um arquivo do Dockerfile, porém declarado apenas a imagem do Ubuntu. Será necessário adicionar todas as outras linhas para que o Dockerfile se torne funcional.
Você deverá editar esse Dockerfile para que ele fique válido e builde a imagem do IRCd corretamente em localhost, ou seja, em sua máquina local, e que o IRCd rode localmente na porta 6667. (Você irá apresentar o Dockerfile e seu funcionamento em uma call).

## Documentações
- [Instalação do UnrealIRCd] https://www.unrealircd.org/docs/Installing_from_source
- [Site do UnrealIRCd] https://www.unrealircd.org 
- [Cliente de IRC Linux] https://sempreupdate.com.br/como-instalar-o-irssi-um-cliente-irc-no-ubuntu-linux-mint-fedora-debian/
- [Cliente de IRC Windows] https://www.tlscript.com.br/
- [Dockerfile References] https://docs.docker.com/engine/reference/builder/
---
- **UnrealIRCd**
    - *[Arquivos de Configuração](#arquivos-de-configuração)*
    - *[Instalação no Docker](#instalação-do-unrealircd-via-dockerfile)*
    - *[Instalação no Ubuntu](#instalação-do-unrealircd-no-ubuntu)*
    - *[Obs.](#obs)*
    - *[Demonstração](#demonstração-unrealircd)*


- **UnrealIRCd - WebPanel**
   - *[Sobre](#unrealircd-webpanel)*
   - *[Instalação no Docker](#instalação-do-unrealircd-webpanel-via-dockerfile)*
   - *[Instalação no Ubuntu + Nginx](#instalação-do-unrealircd-webpanel-no-ubuntu-e-nginx)*
   - *[Demonstração](#demonstração-unrealircd-webpanel)*
---
# Arquivos de configuração



-- openssl.cnf (informações do certificado - usado apenas para instalação via Dockerfile):
```
countryName_default            = BR
stateOrProvinceName_default    = DF
localityName_default           = Brasilia
0.organizationName_default     = configr
organizationalUnitName_default = Configr
commonName_default             = irc.confi.gr
emailAddress_default           = luan.mykel@confi.gr
```

- Configurações para o funcionamento básico

-- example.conf (informações e configurações do servidor irc)

nome do servidor, info e id
```
me {
	name "irc.confi.gr";
	info "CONFIGR IRQ Server";
	sid "001";
}
```

admin: nome, usuário e e-mail
```
admin {
	"Luan Mykel";
	"luan";
	"luanmykel@confi.gr";
}
```

Adicionar no bloco 'allow', match *, para permitir o acesso global, e a senha
```
allow {	
    /*mask 192.0.2.1;*/
	match { ip *; }
	class clients;
	password "SWGAmQhT9908BJZS";
	maxperip 20;
}
```

em oper, o usuário com permissão de operador
```
oper luanmykel {
	class opers;
	mask *@*;
	password "$argon2i$v=19$m=16,t=2,p=1$TFk1cUQ5RGJIWEJZTk1yRg$JnhO3FGonmB8JOmrqP2E5g";
	operclass netadmin;
	swhois "is a Network Administrator";
	vhost irc.confi.gr;
}
```
=> Gerar hash argon2 - https://argon2.online/


dados da Rede IRC e cloak-keys combinação de 80 caracteres (0-9 + A-Z + a-z)
```
    network-name 		"ConfiGR";
	default-server 		"irc.confi.gr";
	services-server 	"services.confi.gr";
	stats-server 		"stats.confi.gr";


cloak-keys {
		"Oozahho1raezoh0iMee4ohvegaifahv5xaepeitaich9tahdiquaid0geecipahdauVaij3zieph4ahi";
		"NbcFsNorzulKu3AjEx1uuEfajWAd8ks7jpFWO3MZHFQRZDXloTO3ijh79PZsql1Aes9rwZpiO8vWSMD7";
		"W6dcOQoiwZzKPiyfNoSyAA8Mj1aHPlydLeIPn3LfJpQl48b1UBJqzOQDVXmZO0Ad1Lz7MFDhX8GwOPUV";
	}
```

e-mail ou URL exibido quando um usuário é banido
```
kline-address 'set.this.to.email.address'; 
```

- conexão por api usando rpc (WebPanel):
```
include "rpc.modules.default.conf";

/* HTTPS on port 8600 for the JSON-RPC API */
listen {
        ip *;
        port 8600;
        options { rpc; }
}

/* API user */
rpc-user adminpanel {
        match { ip *; }
        password "Xf3hBmeiFkaHa5";
}
```



# Instalação do UnrealIRCd via Dockerfile

- Instalar o Docker:
```
sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io
```

- Clonar o repositório e acessar diretório
```
git clone https://github.com/configr-luan/desafio-UnrealIRCd && cd desafio-UnrealIRCd
```
- Criar a imagem do Docker
```
sudo docker build -t unrealircd .
```
Para usar com o WebPanel, criar uma rede para os dois containers se comunicarem
```
sudo docker network create irc
```
- Criar / Iniciar o container (--network=irc adiciona o container na rede, --restart always 
inicia/reinicia o container automaticamente)
```
sudo docker run -p 6667:6667 -d --network=irc --restart always unrealircd:latest

ou

sudo docker run -p 6667:6667 -d --network=irc unrealircd:latest
```
- Conectar com o irssi ou outro cliente utilizando o ip/host do container

# Instalação do UnrealIRCd no Ubuntu

- Instalar os pacotes necessários
```
sudo apt-get install build-essential pkg-config gdb libssl-dev libpcre2-dev libargon2-dev libsodium-dev libc-ares-dev libcurl4-openssl-dev
```
Utilizar um usuário normal (não usar root) para compilar e executar o IRCd.

Caso a instalação seja em uma Cloud, criar um usuário 'ircd'.

```
sudo adduser ircd 

sudo usermod -aG sudo ircd

su - ircd
```
- Obter os arquivos de instalação, compilar e instalar o UnrealIRCd
```
mkdir ircdSource && cd ircdSource

wget --trust-server-names https://www.unrealircd.org/downloads/unrealircd-6.1.4.tar.gz

tar xzvf unrealircd-6.1.4.tar.gz && cd unrealircd-6.1.4

./Config 

make && make install

cd ~/unrealircd
```
- Criar o arquivo de configuração e adicionar o conteúdo do arquivo example.conf
```
touch conf/unrealircd.conf && vim conf/unrealircd.conf
```
- Iniciar o IRCd
```
cd ~/unrealircd
./unrealircd start
```

![Unreal Service](https://i.imgur.com/YLedp0v.png)

- Conectar com o irssi ou outro cliente utilizando localhost, 127.0.0.1 ou ip



# Obs

- Em produção, abrir a porta do Firewall. Exemplo:
```
vim /etc/firewall.d/03_custom
```
Adicionar a regra:
```
$IPTABLES -A INPUT -p tcp --dport 6667 -j ACCEPT
$IP6TABLES -A INPUT -p tcp --dport 6667 -j ACCEPT
```
Reiniciar o firewall:
```
systemctl restart firewall
```



# Demonstração UnrealIRCd

Host irc (porta 6667)
```
ip-45-56-109-129.cloudezapp.io
```
![UnrealIRCd](https://i.imgur.com/Q0SD507.png)

![UnrealIRCd](https://i.imgur.com/TfPWnyX.png)

![UnrealIRCd](https://i.imgur.com/MD7r4t2.png)


---
# UnrealIRCd WebPanel


O Painel Web usa o recurso JSON-RPC do UnrealIRCd, e fornece uma visão geral da rede IRC, 
com informações detalhadas sobre servidores, usuários e canais. Onde é possível adicionar 
e remover facilmente banimentos de servidores, filtros de spam e realizar outras 
tarefas administrativas, diretamente no navegador. 

[UnrealIRCd WebPanel](https://www.unrealircd.org/docs/UnrealIRCd_webpanel)

# Instalação do UnrealIRCd WebPanel via Dockerfile

- Criar a imagem do Docker
```
cd webpanel

sudo docker build -t unrealircd-webpanel .
```

- Criar / Iniciar o container
```
sudo docker run -p 85:80 -d --network=irc --restart always unrealircd-webpanel:latest
```

- Acessar utilizando o ip/host + porta 85, as credenciais serão criadas no primeiro acesso


# Instalação do UnrealIRCd WebPanel no Ubuntu e Nginx

- Instalar os pacotes necessários (Ubuntu 20 ou superior)
```
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update && sudo apt-get install -y ca-certificates apt-transport-https software-properties-common nginx git php8.3 php8.3-fpm php8.3-mbstring php8.3-curl php8.3-zip composer 
```

- Limpar o arquivo de configuração e adicionar o conteúdo do arquivo webpanel/nginx.conf

```
sudo su
echo > /etc/nginx/sites-available/default && vim /etc/nginx/sites-available/default
```
- Clonar o repositório do WebPanel, instalar usando o composer e definir o owner
```
service nginx restart
cd /var/www/html
git clone https://github.com/unrealircd/unrealircd-webpanel
cd /var/www/html/unrealircd-webpanel
composer install
chown -R www-data:www-data /var/www/html/unrealircd-webpanel
exit
```

- Acessar utilizando o localhost, 127.0.0.1 ou ip, as credenciais serão criadas no primeiro acesso


### Conectar o servidor no Webpanel utilizando os dados configurados no example.conf:
```
rpc-user adminpanel {
        match { ip *; }
        password "Xf3hBmeiFkaHa5";
}
```


# Demonstração UnrealIRCd WebPanel

- Aplicação do tipo Custom (81) no painel com a PORTA CUSTOMIZADA ajustada para 85

```
http://webapp372061.ip-45-56-109-129.cloudezapp.io
```

Usuário: configr

Senha: ZeQmeiZzBH8L@

![WebPanel](https://i.imgur.com/6iwM5mh.png)

