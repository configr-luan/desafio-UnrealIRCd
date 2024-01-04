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