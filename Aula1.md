# Aula de Introdução ao Docker

Esse projeto objetiva ajudar no processo de configuração do ambiente de desenvolvimento que iremos utilizar durante nossa aula sobre Docker.

# Configuração do Ambiente

## Instalação da base para Trabalho

```
$ sudo apt-get install git build-essential
```

## Instalação do Docker

Como o docker de sua distribuição pode estar restrito a uma versão antiga devido à politica de atualização da mesma (e.g. Ubuntu 16.04), vamos atualizar o repositório para que o mesmo aponte para a versão do docker mais recente.
```
$ sudo apt-get -y install curl apt-transport-https ca-certificates software-properties-common

$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

$ sudo apt-get update

$ sudo apt-get install docker-compose docker docker-ce
```

## Executando o docker sem sudo

Para evitar que você tenha que utilizar o comando sudo toda a vez que deseje rodar o docker, vamos adicionar seu usuário ao grupo que tem permissão de execução: 
```
$ sudo groupadd docker

$ sudo usermod -aG docker $USER
```

## Verificando se tudo correu bem com o Grupo

Para que as permissões sejam efetivamente aplicadas, você deve deslogar do sistema e logar novamente. Uma outra possibilidade é forçar essa atualização rodando: 


    $ su - ${USER}

Sua senha de acesso será solicitada. Você pode verificar se o seu usuário foi corretamente adicionado ao grupo "docker", basta digitar:


    $ id -nG


Para saber se tudo está funcionando, rode o comando abaixo sem utilizar "sudo":

    $ docker run hello-world
`


## Testando a instalação

Para verificar a versão corrente do docker:


    $ docker --version


Para mais informações sobre a instalação:


    $ docker info


## Executando o Hello World

O comando abaixo irá baixar a imagem do hello-world:


    $ docker run hello-world



Para listar as imagens existentes:

    $ docker image ls



## List de Docker CLI commands


    $ docker
    $ docker container --help


## Display Docker version and info

    $ docker --version
    $ docker version
    $ docker info


## Execute Docker image

    $ docker run hello-world


## List Docker images
    

    $ docker image ls


## List Docker containers (running, all, all in quiet mode)


    $ docker container ls
    $ docker container ls --all
    $ docker container ls -aq


## Definindo o Dockerfile

Crie um arquivo chamado Dockerfile e adicione o seguinte conteúdo a ele:

```docker
    # Use an official Python runtime as a parent image
    FROM python:2.7-slim

    # Set the working directory to /app
    WORKDIR /app

    # Copy the current directory contents into the container at /app
    COPY . /app

    # Install any needed packages specified in requirements.txt
    RUN pip install --trusted-host pypi.python.org -r requirements.txt

    # Make port 80 available to the world outside this container
    EXPOSE 80

    # Define environment variable
    ENV NAME World

    # Run app.py when the container launches
    CMD ["python", "app.py"]
```

## Criando arquivos de apoio desse exemplo

Crie dois arquivos: requirements.txt e app.py e os coloque no mesmo diretório onde está o Dockerfile. Quando nosso Dockerfile for utilizado para construir uma imagem, esses dois arquivos irão levantar nossa aplicação de exemplo.

Altere o conteúdo dos arquivos e coloque:

### app.py
```python
    from flask import Flask
    from redis import Redis, RedisError
    import os
    import socket

    # Connect to Redis
    redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)

    app = Flask(__name__)

    @app.route("/")
    def hello():
        try:
            visits = redis.incr("counter")
        except RedisError:
            visits = "<i>cannot connect to Redis, counter disabled</i>"

        html = "<h3>Hello {name}!</h3>" \
            "<b>Hostname:</b> {hostname}<br/>" \
            "<b>Visits:</b> {visits}"
        return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)

    if __name__ == "__main__":
        app.run(host='0.0.0.0', port=80)
```

### requirements.txt

    Flask
    Redis



## Build da imagem

Agora que estamos prontos para construirmos nossa imagem, rode o seguinte comando dentro do diretório onde está o Dockerfile:


    $ docker build -t auladocker .


## Rodando a aplicação


    $ docker run -p 4000:80 auladocker


## Vendo os containers que estão rodando e controlando a execução

Para parar a execução você pode dar CTRL+C no terminal onde você rodou o comando de execução ou utilizar o comando Stop do Docker, mas, para isso, você precisa do CONTAINER ID. Abra outro terminal e digite:

    $ docker container ls
    
    CONTAINER ID        IMAGE               COMMAND             CREATED
    1fa4ab2cf395        auladocker       "python app.py"     28 seconds ago

    $ docker container stop 1fa4ab2cf395





