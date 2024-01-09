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

## Instalação
- Abrir as portas no firewall (6667, opcional 6697 e 7000):

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

- Clonar o repositório
```
git clone https://github.com/configr-luan/desafio-UnrealIRCd

cd desafio-UnrealIRCd
```


- Algumas configurações para o funcionamento básico nos arquivos: openssl.cnf e example.conf

-- openssl.cnf (informações do certificado):
```
countryName_default            = BR
stateOrProvinceName_default    = DF
localityName_default           = Brasilia
0.organizationName_default     = configr
organizationalUnitName_default = Configr
commonName_default             = irc.confi.gr
emailAddress_default           = luan.mykel@confi.gr
```

-- example.conf

nome do servidor, info e id
```
me {
	name "irc.confi.gr";
	info "CONFIGR IRQ Server";
	sid "001";
}
```

admin: nome, usuario e e-mail
```
admin {
	"Luan Mykel";
	"luan";
	"luanmykel@confi.gr";
}
```

Na sessão 'allow', ip *, para permitir o acesso global, e a senha
```
allow {
	/*mask 192.0.2.1;*/
	ip *;
	class clients;
	password "SWGAmQhT9908BJZS";
	maxperip 20;
}
```

em oper, o usuario com permissao de operador
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


adicionar mais duas cloak-keys combinação de 80 caracteres (0-9 + A-Z + a-z) 
```
cloak-keys {
		"Oozahho1raezoh0iMee4ohvegaifahv5xaepeitaich9tahdiquaid0geecipahdauVaij3zieph4ahi";
		"NbcFsNorzulKu3AjEx1uuEfajWAd8ks7jpFWO3MZHFQRZDXloTO3ijh79PZsql1Aes9rwZpiO8vWSMD7";
		"W6dcOQoiwZzKPiyfNoSyAA8Mj1aHPlydLeIPn3LfJpQl48b1UBJqzOQDVXmZO0Ad1Lz7MFDhX8GwOPUV";
	}
```

e-mail ou URL mostrado quando um usuário é banido
```
kline-address 'set.this.to.email.address'; 
```


- Compilar a imagem do Docker:

```
sudo docker build -t unrealircd .
```

- Criar / Iniciar o container
  (acesso local às portas padrões)
```
sudo docker run -d unrealircd:latest
```
  ( com as portas expostas publicamente )

```
sudo docker run -p 6667:6667 -p 6697:6697 -p 7000;7000 -d unrealircd:latest

ou

sudo docker run -p 6667:6667 -d unrealircd:latest
```
