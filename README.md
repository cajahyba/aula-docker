# Aula de Introdução ao Docker

Esse projeto objetiva ajudar no processo de configuração do ambiente de desenvolvimento que iremos utilizar durante nossa aula sobre Docker.

# Configuração do Ambiente

## Instalação da base para Trabalho

    sudo apt-get install git build-essential

## Instalação do Docker

Como o docker de sua distribuição pode estar restrito a uma versão antiga devido à politica de atualização da mesma (e.g. Ubuntu 16.04), vamos atualizar o repositório para que o mesmo aponte para a versão do docker mais recente.

    sudo apt-get -y install curl apt-transport-https ca-certificates software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    sudo apt-get update

    sudo apt-get install docker-compose docker docker-ce


## Executando o docker sem sudo

Para evitar que você tenha que utilizar o comando sudo toda a vez que deseje rodar o docker, vamos adicionar seu usuário ao grupo que tem permissão de execução: 

    sudo groupadd docker

    sudo usermod -aG docker $USER


## Verificando se tudo correu bem com o Grupo

Para que as permissões sejam efetivamente aplicadas, você deve deslogar do sistema e logar novamente. Uma outra possibilidade é forçar essa atualização rodando: 

    su - ${USER}

Sua senha de acesso será solicitada. Você pode verificar se o seu usuário foi corretamente adicionado ao grupo "docker", basta digitar:

    id -nG

Para saber se tudo está funcionando, rode o comando abaixo sem utilizar "sudo":

    docker run hello-world



## Testando a instalação

Para verificar a versão corrente do docker:

    docker --version

Para mais informações sobre a instalação:

    docker info


## Executando o Hello World

O comando abaixo irá baixar a imagem do hello-world:

    docker run hello-world


Para listar as imagens existentes:

    docker image ls


## List de Docker CLI commands

    docker
    docker container --help

## Display Docker version and info
    
    docker --version
    docker version
    docker info

## Execute Docker image
    
    docker run hello-world

## List Docker images
    
    docker image ls

## List Docker containers (running, all, all in quiet mode)
    
    docker container ls
    docker container ls --all
    docker container ls -aq



## Build da imagem

Após a instalação do Docker, copie a pasta Drive_Downloads disponível em um dos HDs externos e cole na pasta NVIDIA existente no diretório que você clonou o repositório. Posteriormente, rode o script:

    ./build_driveworks.sh


# Acessando a máquina

Para acessar o ambiente criado, basta rodar o script abaixo:

    ./access_driveworks.sh


<!-- # Instalação do Nvidia-Docker (opcional)

### If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers:

    docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f

    sudo apt-get purge -y nvidia-docker

### Add the package repositories

    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -

    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

    sudo apt-get update

### Install nvidia-docker2 and reload the Docker daemon configuration
    
    sudo apt-get install -y nvidia-docker2
    
    sudo pkill -SIGHUP dockerd

### Test nvidia-smi with the latest official CUDA image

    docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi -->


