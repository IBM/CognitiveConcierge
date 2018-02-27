![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)
<!-- ![Bluemix Deployments](https://deployment-tracker.mybluemix.net/stats/f4ae263f304ffe32cbb17f3238c3ac86/badge.svg) -->

# CognitiveConcierge 

O CognitiveConcierge é uma amostra de aplicativo Swift de ponta a ponta com front-end de iOS e backend de estrutura da web Kitura. Esse aplicativo também demonstra como reunir vários serviços diferentes do Watson nos seus aplicativos Swift no lado do cliente e do servidor por meio dos SDKs de iOS do Watson Developer Cloud, incluindo os serviços Assistant for Business, Text to Speech, Speech to Text e Natural Language Understanding. 

<img src="images/CC1.png" width="250" /><img src="images/CC2.png" width="250" /><img src="images/CC7.png" width="250" /> 

## Componentes inclusos:

Serviço Bluemix Watson Assistant for Business 
- Serviço Bluemix Watson Text to Speech 
- Serviço Bluemix Watson Speech to Text 
- Serviço Bluemix Watson Natural Language Understanding 
- API Google Places 

## Diagrama do fluxo de trabalho do aplicativo 
![Application Workflow](images/archi.png) 

1. O usuário implementa o aplicativo do servidor no Bluemix. 
2. O usuário interage com o aplicativo de iOS. 
3. Quando o usuário realiza qualquer ação, o aplicativo de iOS chama a API do aplicativo do servidor, que usa o serviço Watson Natural Language Understanding e a API Google Places para oferecer recomendações ao usuário. 

## Pré-requisito

* **Obter uma chave da API Google Places para a web:** Para este projeto, você precisará de uma chave da API do Google Places; assim, o aplicativo pode ter acesso ao texto da revisão que será enviado ao serviço Natural Language Understanding para análise. As instruções para obter uma chave estão disponíveis [aqui](https://developers.google.com/places/web-service/get-api-key). Quando tiver uma chave da API, acesse o [Console do Google Developer](https://console.developers.google.com/flows/enableapi?apiid=places_backend&amp;reusekey=true), crie um projeto, inclua sua chave da API e habilite a API Google Places também para iOS. Anote a chave da API para uso futuro nos aplicativos de iOS e no servidor. 

    Você também precisará fazer o download e instalar os itens a seguir, caso ainda não tenha feito isso: 

    * [Carthage Dependency Manager](https://github.com/Carthage/Carthage/releases) 
    * [CocoaPods](https://cocoapods.org/?q=cvxv) 

## Etapas

Siga as etapas abaixo para implementar o aplicativo
- Implementar o aplicativo do servidor 
- Atualizar o serviço de conversação 
- Executar o aplicativo de iOS

## 1. Implementar o aplicativo do servidor 
Estas são as maneiras de implementar o aplicativo do servidor:
- Botão Deploy to Bluemix 
- IBM Cloud Application Tools (ICAT) 
- Linha de comando do Bluemix 

### a) Usar o botão Deploy to Bluemix

Ao clicar no botão abaixo, é criada uma cadeia de ferramentas do Bluemix DevOps e esse aplicativo é implementado no Bluemix. O arquivo `manifest.yml` [incluso no repositório] passa por análise sintática para obter o nome do aplicativo, detalhes da configuração e a lista de serviços que devem ser fornecidos. Para ver mais detalhes sobre a estrutura do arquivo `manifest.yml`, consulte a [documentação do Cloud Foundry](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html#minimal-manifest). 

[![Deploy to Bluemix](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://github.com/IBM/CognitiveConcierge.git) 
Após a conclusão da implementação no Bluemix, é possível visualizar o aplicativo e os serviços implementados na sua conta do Bluemix. 

### b) Usar IBM Cloud Application Tools (ICAT) 

1. Instale [IBM Cloud Application Tools](http://cloudtools.bluemix.net/) para MacOS. 
2. Depois de instalar o aplicativo, você pode abri-lo para começar. 
3. Clique no botão **Create (+)** para configurar um novo projeto e, em seguida, selecione o aplicativo de amostra Cognitive Concierge. 
4. Clique em **Save Files to Local Computer** para clonar o projeto. 
5. Após a clonagem do projeto, abra o arquivo .xcodeproj que foi criado para você na ICAT em Local Server Repository. Edite a estrutura Constants do arquivo Sources/restaurant-recommendations/main.swift com sua própria chave da API do Google para a web. 

<img src="images/xcodeproj.png" width="500" />

6. Por fim, é possível usar a ICAT para implementar o servidor atualizado no Bluemix. Clique em **Provision and Deploy Sample Server on Bluemix** em Cloud Runtimes. 

<img src="images/provision.png" width="500" /> 

7. Atribua um nome exclusivo ao Cloud Runtime e clique em **Next**. Essa implementação no Bluemix poderá demorar alguns minutos. 
8. Na ICAT, verifique se o campo Connected to: no aplicativo cliente aponta para sua instância do servidor em execução no Bluemix. Também é possível apontar para o host local para teste local, mas uma instância local do aplicativo do servidor precisa estar em execução para isso funcionar. 

### c) Usar a linha de comando do Bluemix 

Você também pode implementar manualmente o aplicativo do servidor no Bluemix. Apesar de não ser tão mágica quanto usar o botão do Bluemix acima, a implementação manual do aplicativo oferece algumas informações a respeito do que está acontecendo nos bastidores. 
Lembre-se de que é necessário ter a [linha de comando](http://clis.ng.bluemix.net/ui/home.html) do Bluemix instalada no seu sistema para implementar o aplicativo no Bluemix. 
Execute o comando a seguir para clonar o repositório Git: 
```bash 
git clone https://github.com/IBM/CognitiveConcierge.git 
``` 
Acesse a pasta raiz do projeto no seu sistema e execute o script `Cloud-Scripts/services/services.sh` para criar os serviços dos quais o CognitiveConcierge depende.
É necessário efetuar login no Bluemix antes de tentar executar esse script. Para obter informações a respeito de como efetuar login, consulte a [documentação](https://console.ng.bluemix.net/docs/starters/install_cli.html) do Bluemix. 

Executando o script 
`Cloud-Scripts/services/services.sh`: 
```bash 
$ Cloud-Scripts/cloud-foundry/services.sh Creating services... 
Invoking 'cf create-service conversation free CognitiveConcierge-Assistant for Business'... 
Creating service instance CognitiveConcierge-Assistant for Business in org ishan.gulhane@ibm.com / space dev as ishan.gulhane@ibm.com... 
OK 
Invoking 'cf create-service speech_to_text standard CognitiveConcierge-Speech-To-Text'... 
Creating service instance CognitiveConcierge-Speech-To-Text in org ishan.gulhane@ibm.com / space dev as ishan.gulhane@ibm.com... 
OK
Attention: The plan `standard` of service `speech_to_text` is not free. The instance `CognitiveConcierge-Speech-To-Text` will incur a cost. Contact your administrator if you think this is in error. 
Invoking 'cf create-service text_to_speech standard CognitiveConcierge-Text-To-Speech'... 
Creating service instance CognitiveConcierge-Text-To-Speech in org ishan.gulhane@ibm.com / space dev as ishan.gulhane@ibm.com... 
OK 
Attention: The plan `standard` of service `text_to_speech` is not free. The instance `CognitiveConcierge-Text-To-Speech` will incur a cost. Contact your administrator if you think this is in error. 
Invoking 'cf create-service natural-language-understanding free CognitiveConcierge-NLU'... 
Creating service instance CognitiveConcierge-NLU in org ishan.gulhane@ibm.com / space dev as ishan.gulhane@ibm.com... 
OK 
Services created. 
```
Após a criação dos serviços, é possível emitir o comando `bx app push` na pasta raiz do projeto para implementar o aplicativo do servidor no Bluemix. 

Quando o aplicativo estiver em execução no Bluemix, você poderá acessar a URL atribuída a ele (ou seja, rota). Para encontrar a rota, é possível efetuar login na sua [conta do Bluemix](https://console.ng.bluemix.net) ou inspecionar a saída da execução dos comandos `bluemix app push` ou `bx app show <application name>`. O valor da cadeia de caractere exibido ao lado do campo `urls` contém a rota atribuída. Utilize essa rota como a URL para acessar o servidor de amostra com o navegador de sua escolha. 
```bash 
$ bx app show CognitiveConcierge 
Invoking 'cf app CognitiveConcierge'... 

Showing health and status for app CognitiveConcierge in org ishan.gulhane@ibm.com / space dev as ishan.gulhane@ibm.com... 
OK 

requested state: started 
instances: 1/1 
usage: 512M x 1 
instances urls: cognitiveconcierge-lazarlike-archaizer.mybluemix.net 
last uploaded: Mon Jun 5 18:01:42 UTC 2017 
stack: cflinuxfs2 
buildpack: swift_buildpack 

        state       since                   cpu     memory          disk            details
 #0     running     2017-06-05 11:05:41 AM  0.3%    6.4M of 512M    269.8M of 1G
``` 

## 2. Atualizar o serviço de conversação 
- Com o serviço de conversação, é possível incluir uma interface de linguagem natural nos seus aplicativos. Embora seja possível criar uma árvore de conversação manualmente, a ICAT executa alguns scripts de configuração (encontrados na pasta `Cloud-Scripts/conversation`) para incluir uma área de trabalho preenchida no seu serviço de conversação. 
- Se você não estiver usando a ICAT, acesse o painel do Bluemix e acione o serviço de conversação. Agora, preencha a área de trabalho manualmente fazendo upload do JSON encontrado em `Resources/conversationWorkspace.json`. Anote o ID da área de trabalho para uso futuro na execução do aplicativo de iOS. 

## 3. Executar o aplicativo de iOS

### Instale as dependências necessárias 
- No terminal, altere os diretórios na pasta YourProjectName/CognitiveConcierge-iOS e execute o comando a seguir para instalar as dependências necessárias (Isso poderá demorar um pouco): 

```bash 
carthage update --platform iOS pod install 
```

### Atualize a configuração para o aplicativo de iOS 
- Abra o arquivo CognitiveConcierge.xcworkspace no Xcode 8.3 a partir da ICAT ou do seu terminal usando `open CognitiveConcierge.xcworkspace` 
- **Atualize o arquivo CognitiveConcierge.plist:** Uma forma de persistir dados no Swift é por meio da lista de propriedade ou do arquivo .plist. A ICAT executou alguns scripts configurados para gerar e preencher o arquivo `CognitiveConcierge-iOS/CognitiveConcierge/CognitiveConcierge.plist`. Você precisará abrir esse arquivo e incluir sua chave da API do Google. Caso não esteja usando a ICAT, atualize manualmente as credenciais para todos os serviços. As credenciais para os serviços podem ser obtidas na seção de variáveis do ambiente presente na guia Runtime do painel do Bluemix ou usando o comando `bx app env CognitiveConcierge`. Assistant for BusinessWorkspaceID é o ID da área de trabalho do serviço de conversação. 
- **Atualize o arquivo bluemix.plist:** 
- Você deverá definir o valor isLocal como YES se quiser usar um servidor de execução local; se o valor for definido como NO, você acessará a instância do servidor em execução no Bluemix. 
- Para obter o valor appRouteRemote, acesse a página do seu aplicativo no Bluemix. Lá, haverá um botão View App perto do canto superior direito. Ao clicar nele, seu aplicativo será aberto em uma nova guia. A URL dessa página é a rota que leva até a chave appRouteRemote na plist. Não se esqueça de incluir o protocolo http:// na appRouteRemote e de excluir uma barra invertida no final da URL. 
- Também é possível usar o comando “bx app env CognitiveConcierge” em que appRouteRemote é uris, bluemixAppGUID é application_id e bluemixAppRegion é a região do Bluemix para eg: us-south. 

```bash 
{ 
    "VCAP_APPLICATION": { 
        "application_id": "3d06c0e7-1fff-4dbf-b0cb-b289770eccfe",
        "application_name": "CognitiveConcierge",
        "application_uris": [ 
            "cognitiveconcierge-lazarlike-archaizer.mybluemix.net" 
        ], 
        "application_version": "3ef63168-35f5-4517-84e9-e8f19c8f34b4", 
        "limits": { 
            "disk": 1024,
            "fds": 16384,
            "mem": 512 
        },
        "name": "CognitiveConcierge", 
        "space_id": "2b3083b9-7ef9-4d55-9741-34433be4cea1", 
        "space_name": "dev", 
        "uris": [ 
            "cognitiveconcierge-lazarlike-archaizer.mybluemix.net" 
        ], 
        "users": null, 
        "version": "3ef63168-35f5-4517-84e9-e8f19c8f34b4" 
    } 
} 
Running Environment Variable Groups: 
BLUEMIX_REGION: ibm:yp:us-south 
Staging Environment Variable Groups: 
BLUEMIX_REGION: ibm:yp:us-south 
``` 

- Precisamos obter o valor para `bluemixAppRegion`, que, no momento, pode ser uma dentre três opções: 

REGION US SOUTH | REGION UK | REGION SYDNEY 
--- | --- | --- 
`.ng.bluemix.net` | `.eu-gb.bluemix.net` | `.au-syd.bluemix.net` 

### Executar o aplicativo
Pressione o botão Play no Xcode para desenvolver e executar o projeto no simulador ou no seu iPhone! ![](images/playbutton.png) 

## Executar o servidor baseado em Kitura localmente
Para desenvolver o CognitiveConcierge-Server, acesse o diretório `CognitiveConcierge-Server` do repositório clonado e execute `swift build`. 
Para iniciar o servidor baseado em Kitura para o aplicativo CognitiveConcierge no seu sistema local, acesse o diretório `CognitiveConcierge-Server` do repositório clonado e execute `.build/debug/CognitiveConcierge`. 
Você também deve atualizar os arquivos `bluemix.plist` e `CognitiveConcierge.plist` no projeto do Xcode para o aplicativo de iOS se conectar com o servidor local. Consulte a seção [Atualizar a configuração para o aplicativo de iOS](#update-configuration-for-ios-app) para ver detalhes. 

## Aviso de Privacidade
Este aplicativo do Swift inclui um código para acompanhar as implementações no [IBM Bluemix](https://www.bluemix.net/) e em outras plataformas do Cloud Foundry. 
As informações a seguir são enviadas para um serviço de [Rastreador da Implementação](https://github.com/IBM-Bluemix/cf-deployment-tracker-service) em cada implementação: 
* Versão do código do projeto do Swift (se for fornecido) 
* URL do repositório do projeto do Swift * Nome do Aplicativo (`application_name`) 
* ID do Espaço (`space_id`) 
* Versão do Aplicativo (`application_version`) 
* URIs do Aplicativo (`application_uris`) 
* Etiquetas de serviços de limite 
* Número de instâncias para cada serviço de limite e informações do plano associado 

Esses dados são coletados a partir dos parâmetros do `CloudFoundryDeploymentTracker` e das variáveis de ambiente `VCAP_APPLICATION` e `VCAP_SERVICES` no IBM Bluemix e em outras plataformas do Cloud Foundry. Esses dados são utilizados pela IBM para o acompanhamento de métricas a respeito de implementações dos mesmos aplicativos no IBM Bluemix. O objetivo é determinar a utilidade dos nossos exemplos para podermos melhorar continuamente o conteúdo que oferecemos a você. Somente implementações de aplicativos de amostra que incluem código para fazer ping do serviço de Rastreador da Implementação serão acompanhadas. 

### Desativando o Acompanhamento da Implementação 
Para desativar o acompanhamento da implementação, remova esta linha de main.swift: 

```
CloudFoundryDeploymentTracker(repositoryURL: "https://github.com/IBM-MIL/CognitiveConcierge/", codeVersion: nil).track() 
``` 

## Vídeo do aplicativo CognitiveConcierge
[![cognitive concierge video](http://i.imgur.com/hsFxooD.png)](http://vimeo.com/222564546 "Cognitive Concierge Overview") 

## Resolução de Problemas 
- Em caso de falha na implementação da fase do aplicativo do servidor, implemente novamente a fase do canal. 
- Se o aplicativo de iOS não conseguir se conectar com os Serviços do Watson, verifique novamente os valores das credenciais nos arquivos CognitiveConcierge.plist e bluemix.plist. 

## Licença 

[Apache 2.0](LICENSE) 
