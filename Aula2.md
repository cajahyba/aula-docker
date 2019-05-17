# Aula 2

## Compartilhando uma imagem

Para demonstrar a portabilidade do que criamos na aula passada, vamos carregar nossa imagem construída e executá-la em outro lugar. Afinal, você precisa saber como fazer push para registros quando você deseja implantar contêineres em produção.

Um registro é uma coleção de repositórios e este é uma coleção de imagens — uma espécie de repositório como o GitHub, exceto que o código já foi criado. Uma conta em um registro pode criar muitos repositórios. A CLI do Docker usa o registro público do Docker por padrão.

    Nota: usamos o registro público do Docker aqui apenas porque ele é gratuito e pré-configurado, mas há muitos públicos para escolher e você pode até mesmo configurar seu próprio registro privado usando o Docker Trusted Registry.


## Faça login com sua ID do Docker

Se você não tiver uma conta do Docker, crie uma em https://hub.docker.com.

Efetue login no registro público do Docker em seu computador local.

    $ docker login


A notação para associar uma imagem local a um repositório em um registro é nome de usuário/repositório:tag. A tag é opcional, mas recomendada, pois é o mecanismo que os registros usam para dar às imagens do Docker uma versão. Dê ao repositório e marque nomes significativos para o contexto, como auladocker:aula2. Isso coloca a imagem no repositório auladocker e a marca como aula2.

Agora, coloque tudo junto para marcar a imagem. Execute a imagem da tag do Docker com seu nome de usuário, repositório e nomes de Tags para que a imagem carregue no destino desejado. A sintaxe do comando é:
docker tag image username/repository:tag

    $ docker tag image username/repository:tag

Por exemplo:

    $ docker tag auladocker cajahyba/auladocker:aula2

Vamos ver como ficou:

    $ docker image ls

    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    auladocker              latest              d9e555c53008        3 minutes ago       195MB
    cajahyba/auladocker     part2               d9e555c53008        3 minutes ago       195MB
    python                  2.7-slim            1c7128a655f6        5 days ago          183MB
    

## Publicando a imagem

Para fazer o upload da imagem para o repositório:

    $ docker push username/repository:tag

Uma vez concluído, os resultados deste upload estão disponíveis publicamente. Se você fizer logon no Hub do Docker, verá a nova imagem lá, com seu comando pull.


Exemplo:

    $ docker push cajahyba/auladocker:aula2
    Unable to find image 'cajahyba/auladocker:aula2' locally
    part2: Pulling from cajahyba/auladocker
    10a267c67f42: Already exists
    f68a39a6a5e4: Already exists
    9beaffc0cf19: Already exists
    3c1fe835fb6b: Already exists
    4c9f1fa8fcb8: Already exists
    ee7d8f576a14: Already exists
    fbccdcced46e: Already exists
    Digest: sha256:0601c866aab2adcc6498200efd0f754037e909e5fd42069adeff72d1e2439068
    Status: Downloaded newer image for gordon/get-started:part2
    * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)


Não importa onde o "docker run" está sendo executado, ele puxa sua imagem, juntamente com Python e todas as dependências de requirements.txt, e executa o seu código. Tudo viaja juntos em um pacote conciso e você não precisa instalar nada na máquina host para que o Docker o execute.




## Fazendo Pull e executando a Imagem a partir do repositório remoto

A partir de agora, você pode usar o "docker run" e executar seu aplicativo em qualquer computador com este comando:

    $ docker run -p 4000:80 username/repository:tag

Exemplo:

    $ docker run -p 4000:80 cajahyba/auladocker:aula2

Se a imagem não estiver disponível localmente na máquina, o docker a puxa do repositório.



## Docker Compose

Docker Compose é uma ferramenta para definir e executar aplicativos Docker de vários contêineres. Com o Compose, você usa um arquivo YAML para configurar os serviços do seu aplicativo. Em seguida, com um único comando, você cria e inicia todos os serviços de sua configuração. Para saber mais sobre todos os recursos do Compose, veja a lista de recursos.

Compor trabalhos em todos os ambientes: produção, preparo, desenvolvimento, testes, bem como fluxos de trabalho de CI. 

Usar compor é basicamente um processo de três etapas:

* Defina o ambiente do seu aplicativo com um Dockerfile para que ele possa ser reproduzido em qualquer lugar.

* Defina os serviços que compõem seu aplicativo em Docker-Compose. yml para que possam ser executados juntos em um ambiente isolado.

* Execute Docker-Compose up e Compose inicia e executa todo o seu aplicativo.

Um arquivo *docker-compose.yml* normalmente se parece com:
```yml
    version: '3' 
    services:
    web:
        build: .
        ports:
        - "5000:5000"
        volumes:
        - .:/code
        - logvolume01:/var/log
        links:
        - redis
    redis:
        image: redis
    volumes:
    logvolume01: {}
```

O Compose tem comandos para gerenciar todo o ciclo de vida do seu aplicativo:

* Iniciar, parar e reconstruir serviços
* Exibir o status dos serviços em execução
* Transmitir a saída de log dos serviços em execução
* Executar um comando único em um serviço


## Instalação

    sudo apt install docker-compose


## Aprendendo sobre serviços

Agora aprenderemos como dimensionar nosso aplicativo e habilitar o balanceamento de carga. Para fazer isso, devemos ir um nível acima na hierarquia de um aplicativo distribuído: o serviço.

Em um aplicativo distribuído, diferentes partes do aplicativo são chamados de "serviços". Por exemplo, se você imaginar um site de compartilhamento de vídeo, ele provavelmente inclui um serviço para armazenar dados de aplicativos em um banco de dados, um serviço de transcodificação de vídeo em segundo plano depois que um usuário carrega algo, um serviço para o front-end e assim por diante.

Os serviços são realmente apenas "conteineres em produção." Um serviço só executa uma imagem, mas codifica a maneira como a imagem é executada — quais portas devem ser usadas, quantas réplicas do contêiner devem ser executadas para que o serviço tenha a capacidade necessária e assim por diante. Dimensionar um serviço altera o número de instâncias de contêiner que executam essa parte do software, atribuindo mais recursos de computação ao serviço no processo.

Felizmente, é muito fácil definir, executar e dimensionar serviços com a plataforma Docker--basta escrever um arquivo docker-compose.yml.

## Montando seu primeiro arquivo docker-compose.yml

Um arquivo docker-compose.yml é um arquivo YAML que define como os contêineres do Docker devem se comportar nem ambientes de produção.

Salve os dados abaixo em um arquivo chamado docker-compose.yml. Certifique-se de que você empurrou a imagem que você criou na parte 2 para um registro e atualize this. yml substituindo username/repo:tag ($docker image ls) com seus detalhes de imagem.

```yml
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: username/repo:tag ## e.g. image: cajahyba/auladocker:latest 
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "4000:80"
    networks:
      - webnet
networks:
  webnet:
```

