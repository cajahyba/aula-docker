# Aula 2

## Compartilhando uma imagem

Para demonstrar a portabilidade do que criamos na aula passada, vamos carregar nossa imagem construída e executá-la em outro lugar. Afinal, você precisa saber como fazer push para registros quando você deseja implantar contêineres em produção.

Um registro é uma coleção de repositórios e este é uma coleção de imagens — uma espécie de repositório como o GitHub, exceto que o código já foi criado. Uma conta em um registro pode criar muitos repositórios. A CLI do Docker usa o registro público do Docker por padrão.

**Nota: usamos o registro público do Docker aqui apenas porque ele é gratuito e pré-configurado, mas há muitos públicos para escolher e você pode até mesmo configurar seu próprio registro privado usando o Docker Trusted Registry.**


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
    cajahyba/auladocker     aula2               d9e555c53008        3 minutes ago       195MB
    python                  2.7-slim            1c7128a655f6        5 days ago          183MB
    

## Publicando a imagem

Para fazer o upload da imagem para o repositório:

    $ docker push username/repository:tag

Uma vez concluído, os resultados deste upload estão disponíveis publicamente. Se você fizer logon no Hub do Docker, verá a nova imagem lá, com seu comando pull.


Exemplo:

    $ docker push cajahyba/auladocker:aula2
    Unable to find image 'cajahyba/auladocker:aula2' locally
    aula2: Pulling from cajahyba/auladocker
    10a267c67f42: Already exists
    f68a39a6a5e4: Already exists
    9beaffc0cf19: Already exists
    3c1fe835fb6b: Already exists
    4c9f1fa8fcb8: Already exists
    ee7d8f576a14: Already exists
    fbccdcced46e: Already exists
    Digest: sha256:0601c866aab2adcc6498200efd0f754037e909e5fd42069adeff72d1e2439068
    Status: Downloaded newer image for gordon/get-started:aula2
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
    image: username/repo:tag ## e.g. image: cajahyba/auladocker:aula2 
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

Esse arquivo docker-compose.yml diz ao Docker para fazer o seguinte:

* Puxe a imagem que nós subimos para o registro.

* Executar 5 instâncias dessa imagem como um serviço chamado Web, limitando cada um para usar, no máximo, 10% de um único núcleo de tempo de CPU (isso também poderia ser, por exemplo, "1.5" para significar 1 e meio núcleo para cada), e 50MB de RAM.

* Reinicie imediatamente os recipientes se um falhar.

* Mapeie a porta 4000 no host para a porta da Web 80.

* Instrua os contêineres Web para compartilhar a porta 80 por meio de uma rede com balanceamento de carga chamada Webnet. (Internamente, os próprios contêineres publicam na porta da Web 80 em uma porta efêmera.)

* Defina a rede Webnet com as configurações padrão (que é uma rede de sobreposição com balanceamento de carga).


## Executando nosso novo balanceador de carga

Antes de usarmos o comando "docker stack deploy", precisamos executar o seguinte comando abaixo:

    $ docker swarm init
    Swarm initialized: current node (lzx0kievd2wdn3j5t9yacmx47) is now a manager.

    To add a worker to this swarm, run the following command:

        docker swarm join --token SWMTKN-1-1t8veonmo8w17ua667p65dpmi45qlonyzxpih3mk4fno2m4dgf-bizim15dywvd8fdaewgsxq64i 192.168.87.20:2377

    To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.


**Nota: Nós aprenderemos mais sobre esse comando em uma aula futura. Apenas saiba que se você não executar "docker swarm init" você receberá um erro que "“this node is not a swarm manager.”**

Agora vamos executá-lo. Você precisa dar um nome ao seu aplicativo. Aqui, ele está definido para laboratorio-docker:

    $ docker stack deploy -c docker-compose.yml laboratorio-docker
    Creating network laboratorio-docker_webnet
    Creating service laboratorio-docker_web


Pronto, nosso service stack está está executando 5 instâncias de contêiner de nossa imagem implantada em um host. Vamos investigar. 

Vamos obter o Service ID referente ao serviço em nossa aplicação:

    $ docker service ls

Procure a saída para o serviço Web, anexado com o nome do aplicativo. Se você nomeou o mesmo como mostrado neste exemplo, o nome é laboratorio-docker_web. O ID de serviço também é listado, juntamente com o número de réplicas, o nome da imagem e as portas expostas.

Como alternativa, você pode executar os serviços de pilha do Docker, seguidos pelo nome da pilha. O comando de exemplo a seguir permite exibir todos os serviços associados à pilha laboratoriodocker:
    
    ID                  NAME                     MODE                REPLICAS            IMAGE                       PORTS
    5a6qvora0joi        laboratorio-docker_web   replicated          5/5                 cajahyba/auladocker:aula2   *:4000->80/tcp


Um único contêiner em execução em um serviço é chamado de uma tarefa. As tarefas recebem IDs exclusivas que incrementam numericamente, até o número de réplicas definidas no arquivo docker-compose.yml. Para listar as tarefas do seu serviço:

    $ docker service ps laboratorio-docker_web
    ID                  NAME                       IMAGE                       NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
    wxq4m0zt354x        laboratorio-docker_web.1   cajahyba/auladocker:aula2   cajah-note          Running             Running 14 minutes ago                       
    26s0woctmgvt        laboratorio-docker_web.2   cajahyba/auladocker:aula2   cajah-note          Running             Running 14 minutes ago                       
    677kwdi7tgly        laboratorio-docker_web.3   cajahyba/auladocker:aula2   cajah-note          Running             Running 14 minutes ago                       
    upvbzcqk68x4        laboratorio-docker_web.4   cajahyba/auladocker:aula2   cajah-note          Running             Running 14 minutes ago                       
    35szddi1xgn4        laboratorio-docker_web.5   cajahyba/auladocker:aula2   cajah-note          Running             Running 14 minutes ago 

As tarefas (Tasks) também são demonstradas se você listar todos os contêineres no seu sistema, embora isso não permita filtro por serviço:

    $ docker container ls -q
    a38ae8683dda
    e321a1a00cbd
    c289d334bd36
    16e0effebb09
    f96956363963

Você pode acessar http://localhost:4000 várias vezes seguidas e ver se o tudo está funcionando corretamente.


De qualquer forma, o ID do contêiner é alterado, demonstrando o balanceamento de carga; com cada pedido, uma das 5 tarefas é escolhida, em uma forma Round-Robin, para responder. Os IDs de contêiner correspondem à saída do comando anterior (docker container ls -q).

Para exibir todas as tarefas de uma pilha (stack), você pode executar o "docker stack ps " seguido pelo nome do aplicativo, conforme mostrado no exemplo a seguir:

    $ docker stack ps laboratorio-docker
    ID                  NAME                       IMAGE                       NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
    wxq4m0zt354x        laboratorio-docker_web.1   cajahyba/auladocker:aula2   cajah-note          Running             Running 25 minutes ago                       
    26s0woctmgvt        laboratorio-docker_web.2   cajahyba/auladocker:aula2   cajah-note          Running             Running 25 minutes ago                       
    677kwdi7tgly        laboratorio-docker_web.3   cajahyba/auladocker:aula2   cajah-note          Running             Running 25 minutes ago                       
    upvbzcqk68x4        laboratorio-docker_web.4   cajahyba/auladocker:aula2   cajah-note          Running             Running 25 minutes ago                       
    35szddi1xgn4        laboratorio-docker_web.5   cajahyba/auladocker:aula2   cajah-note          Running             Running 25 minutes ago    
        
## Escalonando a aplicação

Você pode dimensionar o aplicativo alterando o valor da variável *replicas* no docker-compose.yml, salvando a alteração e reexecutando o comando Docker Stack Deploy:

    $ docker stack deploy -c docker-compose.yml laboratorio-docker

O Docker executa uma atualização in-loco (in-place update), não há necessidade de destruir todo o stack primeiro ou matar todos os contêineres.

Agora, execute novamente o comando *docker container ls -q* para ver se as instâncias implantadas foram reconfiguradas. Se você ampliou as réplicas, mais tarefas e, portanto, mais contêineres, são iniciados.

## Destruindo tudo

Para derrubar a aplicação basta você executar:

    $ docker stack rm laboratorio-docker

Para derrubar o swarm:

    $ docker swarm leave --force

Assim, é possível perceber o quão fácil é levantar e dimensionar seu aplicativo com o Docker. Você tomou um grande passo para aprender a executar contêineres em produção. Em seguida, você aprenderá a executar este aplicativo como um enxame de bonafide em um cluster de máquinas do Docker.

**Nota: arquivos do Compose são usados para definir aplicativos no Docker e podem ser carregados para provedores de nuvem usando o Docker Cloud ou em qualquer provedor de hardware ou nuvem**
