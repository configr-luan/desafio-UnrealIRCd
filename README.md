# Desafio UnrealIRCd
O IRC (Internet Relay Chat) é um protocolo de comunicação em tempo real baseado em texto, desenvolvido na década de 1980. Ele permite a comunicação entre usuários por meio de salas de bate-papo (chamadas de canais) e mensagens diretas (privado).

No IRC, os usuários se conectam a servidores específicos usando um cliente de IRC (software) e podem participar de diferentes canais de conversa ou criar os seus próprios. Cada canal tem um nome único e pode ter moderadores que ajudam a manter a ordem e aplicam regras específicas.

O desafio consiste na criação de um servidor de IRC, utilizando o UnrealIRCd, e se dará da seguinte forma:

## Rodando o UnrealIRCd em um cloud da Configr

Nesta etapa  você deverá seguir os passos:

1) Provisionar um Cloud em seu e-mail para fazer o processo;
2) Entregar o IRCd funcional e acessível na porta 6667 no IP do cloud; (Nós iremos acessar através de um cliente de IRC)
2) Com base na configuração de exemplo que consta no repositório, você deverá deixar a rede de IRC com o nome de Configr.

## Criando um Dockerfile para o UnrealIRCd

Nesta segunda etapa, você deverá fazer seguir os passos:

1) Fazer um fork do projeto em seu GIT;
2) Você deverá criar um Dockerfile válido que builde a imagem do IRCd corretamente em localhost, ou seja, em sua máquina local, e que o IRCd rode localmente na porta 6667. (Você irá apresentar o Dockerfile e seu funcionamento em uma call).

## Documentações
- [Instalação do UnrealIRCd] https://www.unrealircd.org/docs/Installing_from_source
- [Site do UnrealIRCd] https://www.unrealircd.org 
- [Cliente de IRC Linux] https://sempreupdate.com.br/como-instalar-o-irssi-um-cliente-irc-no-ubuntu-linux-mint-fedora-debian/
- [Cliente de IRC Windows] https://www.tlscript.com.br/