# Monitoramento de Deslizamento de Encostas, usando Microcontrolador, MPU6050, MQTT, Docker, InfluxDB e Grafana.

![Arquitetura do projeto](https://github.com/user-attachments/assets/b9516024-a8bf-4c9f-a6cb-0c6d3c58cb77)



Resumo da proposta

O projeto aborda a problemática dos deslizamentos de terras, identificados como uma das principais ameaças naturais em diversas regiões do Brasil, especialmente em áreas suscetíveis a chuvas intensas, como é o caso de muitas cidades. O objetivo primordial consiste na implementação de um Sistema de Monitoramento de Encostas fundamentado em dispositivos IoT (Internet das Coisas), cujo propósito é a coleta de dados referentes à oscilação de encostas. Tal sistema é concebido com o intuito de prevenir desastres naturais e salvaguardar áreas vulneráveis por meio da emissão de alertas adequados. O sistema visa apresentar soluções de código aberto que, além de reduzirem custos, proporcionarão maior escalabilidade e eficiência. Utilizando o sensor MPU6050 para análise de vibrações e oscilações, juntamente com o microcontrolador ESP32, que possui comunicação sem fio, este será responsável por transmitir os dados do sensor usando o protocolo MQTT (Message Queuing Telemetry Transport). Além disso, o sistema de software de código aberto Telegraf, conhecido por sua eficiência na coleta e processamento de dados de monitoramento, será responsável por encaminhar os dados obtidos do protocolo MQTT e enviá-los para um servidor, o InfluxDB, outra solução de código aberto que será usada para armazenar os dados recebidos do sensor, esses dados permitiram análises futuras para identificar padrões, tendências e anomalias ao longo do tempo. Ademais, o software Grafana será implementado para visualização em tempo real dos dados obtidos e para o envio de alertas para o cliente. Essa abordagem integrada visa oferecer não apenas uma solução técnica eficaz, mas também uma interface de monitoramento intuitiva e proativa, facilitando a interpretação dos dados e a tomada de decisões por parte dos usuários finais. Dessa forma, por se tratar de um sistema simples e de baixo custo devido ao uso de soluções open source, o projeto se torna atrativo para clientes que procuram uma solução mais econômica. Comparado a outras empresas que oferecem o mesmo serviço com custos mais elevados, nosso projeto oferece uma alternativa acessível sem comprometer a qualidade. Outro ponto relevante é o embasamento em disciplinas do curso de Redes de Computadores para este estudo, incluindo organização de computadores, que proporciona orientação na escolha dos sensores, redes sem fio e comunicação de dados, que em conjunto oferecem um direcionamento eficaz para estabelecer uma comunicação eficiente entre os dispositivos e resolver possíveis problemas relacionados ao ambiente. A fase final deste projeto será a apresentação do Mínimo Produto Viável (MVP), que será feito por meio de uma maquete, esta maquete será dimensionada para suportar uma carga, como areia ou terra, e terá proporções semelhantes às de um recipiente retangular. Na extremidade, haverá um suporte com o sensor, permitindo que o sensor detecte qualquer movimento de terra e gere os dados no sistema Grafana. Diante do exposto, este projeto busca apresentar uma solução de baixo custo, mas, que é atrativa e relevante para empresas que lidam com problemas relacionado a deslizamento de massas, assim, combinando tecnologia IoT e sistemas de código aberto será possível oferecer segurança e prevenir desastres em áreas propícias a sofrer com algum tipo de deslizamento de terra.

Introdução

Os deslizamentos de massa são uma das principais ameaças naturais em várias partes do mundo, caracterizados pelo movimento descendente de solos ou rochas, impulsionados pela gravidade e frequentemente exacerbados pela água. Segundo o Centro Nacional de Monitoramento e Alerta de Desastres Naturais (CEMADEN), o monitoramento de encostas tornou-se crucial para a comunidade científica. O uso de sensores adequados é essencial para compreender os aspectos dinâmicos dos deslizamentos, permitindo análises precisas e identificação oportuna de alerta (Mendes et al., 2020).
Yan et al. (2021), em seu estudo “Application of Internet of Things technology in landslide monitoring”, destacam que a Internet das Coisas (IoT) tem sido amplamente explorada para fortalecer a capacidade e precisão dos quadros de alerta precoce e monitoramento de deslizamentos de terra. A IoT facilita a interconexão de objetos inteligentes, conhecidos como “coisas”, permitindo comunicação inteligente com serviços na nuvem e promovendo uma melhor compreensão do ambiente circundante. Isso é crucial para abordar questões sociais, incluindo o monitoramento de desastres e alerta precoce (Zhang et al., 2022, p. 396).
Diante disso, o uso de dispositivos IoT para monitoramento de encostas como medida preventiva contra desastres naturais torna-se evidente. Este projeto propõe a implementação de um sistema de monitoramento de encostas utilizando sensores com acelerômetros. Estes sensores estão conectados a um microcontrolador de baixo custo, o ESP32, responsável pela transmissão sem fio das informações. Para garantir eficiência na transmissão de dados, será adotado o protocolo MQTT, conhecido por sua leveza e eficiência. O sistema open source Telegraf atuará como agente, coletando dados do Broker Mosquitto (servidor MQTT) e encaminhando-os ao banco de dados InfluxDB. O Grafana será integrado ao banco de dados para visualização dos dados coletados e alerta, tudo hospedado em um container Docker para flexibilidade e escalabilidade sem custos adicionais. Além de desenvolver um sistema de monitoramento, nossa proposta inclui flexibilidade, baixo custo e escalabilidade através do uso de aplicações open source, tornando nosso produto ainda mais atrativo para clientes comuns, empresas e órgãos governamentais.

Justificativa

A importância da pesquisa e desenvolvimento do sistema de monitoramento de deslizamento de encostas não pode ser subestimada, já que esses eventos podem acarretar danos sérios às infraestruturas e colocar vidas em risco. Nesse contexto, a proposta deste projeto se mostra relevante e oportuna para a antecipação e redução de tais ocorrências, por meio do monitoramento em tempo real. O projeto se destaca por utilizar dispositivos de computação interconectados, capazes de trocar dados e compartilhar recursos entre si. Além disso, o projeto integra conhecimentos de várias disciplinas da graduação em Redes de Computadores do IFRN, que são essenciais para sua implementação. Por exemplo, a disciplina de Organização de Computadores, especialmente o tópico 2 - Organização de Processadores, ensina os princípios fundamentais de como os processadores funcionam. Compreender a organização dos processadores é crucial para programar e interagir com microcontroladores, pois estes possuem processadores embutidos que executam instruções para controlar o comportamento do sistema. Tópico 3 - Sistema de Memória. Este conteúdo explora os tipos de memórias, como RAM, ROM, cache e memória externa. No contexto de microcontroladores, o conhecimento sobre sistemas de memória é crucial para o armazenamento temporário de dados e instruções de programa, bem como para entender como acessar e manipular esses dados eficientemente. Para utilizar efetivamente o ESP32 em conjunto com o acelerômetro MPU-6050, é essencial compreender os fundamentos das comunicações sem fio e a disciplina de Redes Sem Fio oferece uma base sólida para explorar os conceitos-chave relacionados a essa comunicação. O conteúdo “1 - Introdução às Comunicações sem Fio” fornece uma visão geral dos princípios básicos das comunicações sem fio, incluindo conceitos como modulação, propagação de ondas e protocolos de comunicação. Compreender esses fundamentos é crucial para entender como o ESP32 transmite e recebe dados. Além disso, “3 - Propagação das Ondas Eletromagnéticas”, ensina o fenômeno pelo qual as ondas eletromagnéticas se espalham ou se movem mediante um meio, como o ar ou o vácuo. Compreender esse processo é fundamental para antecipar o comportamento dos sinais sem fio em ambientes reais. Esse conhecimento é crucial especialmente para a transmissão de dados em regiões de encostas, uma vez que as condições geográficas podem influenciar diretamente na propagação do sinal, afetando sua eficácia e alcance. Ademais, “7 - Principais Padrões de Redes sem Fio”. O conhecimento dos padrões é importante para entender as especificações técnicas e os protocolos que podem ser relevantes para o projeto. Por fim, a última disciplina que usaremos como base nesse projeto será Comunicação de Dados. Que nos traz em sua ementa ensinamentos essenciais para dominar a comunicação básica de um sistema. Assim, no tópico “8 - Fundamentos da Transmissão Digital”, é abordado os critérios de Nyquist e a modulação PSK ou FSK importante para transmissão digital, se torna importante para evitar interferência inter-simbólica e garantir uma transmissão de dados eficaz, em analogia é o que busca este estudo. Outrossim, “10-Multiplexação e Acesso Múltiplo”. Compreender os princípios de FDMA, TDMA e CDMA é crucial para otimizar o uso do espectro de frequência na comunicação sem fio. Isso permite programar microcontroladores para operar em diferentes faixas de frequência e multiplexar sensores com FDMA, evitando interferências e maximizando a largura de banda disponível. Portanto, este projeto possui uma relevância interdisciplinar, promovendo o entendimento dos conceitos abordados em Organização de Computadores, Redes Sem Fio e Comunicação de Dados. Além disso, oferece a oportunidade de criar uma solução tangível para um problema real. Dessa forma, a aplicação prática do sistema de monitoramento de encostas pode resultar em melhorias significativas na prevenção de desastres naturais e na proteção de vidas e patrimônios.

Objetivo Geral

O objetivo primordial deste projeto é desenvolver um protótipo IoT que realize o monitoramento contínuo de deslizamentos de encostas. O embasamento teórico será sustentado pelos conhecimentos adquiridos ao longo do curso de Redes de Computadores no IFRN, integrando as disciplinas de Organização de Computadores, Redes Sem Fio e Comunicação de Dados. A implementação do MVP (Minimum Viable Product) será realizada utilizando o microcontrolador ESP32, o sensor MPU6050, o Broker Mosquitto com o Protocolo MQTT (Message Queuing Telemetry Transport) e o Docker para criar containers do Telegraf, InfluxDB e da plataforma Grafana. Assim, o foco principal será atender clientes que buscam prevenir deslizamentos de encostas e proteger a população e as estruturas públicas localizadas em áreas de risco. Esses potenciais clientes incluem órgãos de defesa civil, empresas especializadas em monitoramento ambiental, CEMADEN, entre outros. A materialização do projeto será apresentada por meio de uma maquete, oferecendo uma representação visual e tangível do sistema proposto. Isso facilitará a compreensão do seu funcionamento, tornando a exposição do projeto mais acessível e elucidativa para públicos técnicos e não técnicos.


Objetivo Específico

O objetivo principal deste projeto é desenvolver um protótipo para o monitoramento de encostas, permitindo a coleta e o processamento em tempo real de dados sobre deslocamentos em ambientes críticos. Com essa meta, delineamos os seguintes objetivos específicos:
1.	Seleção de Sensores Adequados: Realizar uma seleção criteriosa de sensores, como por exemplo: o ESP32, que consiga realizar medições precisas e confiáveis de parâmetros importantes para o monitoramento de encostas.
2.	Configuração dos Sensores: Programar o ESP32 para adquirir dados do sensor MPU6050, processar as informações e enviar os dados obtidos ao Broker Mosquitto através do protocolo MQTT.
3.	Instalação e Configuração dos Containers: Configurar um ambiente que permita o Telegraf coletar dados do Mosquitto, armazená-los no banco de dados InfluxDB e configurar o Grafana para acessar e visualizar esses dados.
4.	Grafana: configurar a plataforma grafana para receber os dados no InfluxDB e criar uma interface de visualização que seja acessível e compreensível.
5.	Testes, Simulação e Análise de Resultados via Maquete: Construir uma maquete para simular as condições de deslocamento de encostas, analisar os resultados e gerar insights que possam embasar decisões informadas relacionadas à segurança e prevenção de desastres naturais.
6.	Relatório Final: Consolidar todas as etapas anteriores em um relatório abrangente, documentando o desenvolvimento do protótipo, os resultados obtidos e as conclusões alcançadas ao longo do projeto.

Sprints:

Sprint 1: Seleção de Sensores Adequados

Tarefa para Dann: Pesquisar e avaliar diferentes tipos de sensores adequados para o monitoramento de encostas.

Tarefa para Ana Lívia: Apresentar um relatório comparativo com suas características, precisão e custo.

Sprint 2: Configuração do ESP32 e MPU6050

Tarefa para Dann: Programar o ESP32 para adquirir dados do sensor MPU6050.

Tarefa para Ana Lívia: Configurar o envio dos dados ao Broker Mosquitto utilizando o protocolo MQTT.

Sprint 3: Instalação e Configuração do Docker e dos containers telegraf, influxdb e Grafana

Tarefa para Dann: Instalar e configurar o Docker, bem como os containers do telegraf, influxdb e Grafana, 

Tarefa para Ana Lívia: Garantir que o telegraf consiga capturar os dados do Mosquitto e transmiti-los para o InfluxDB.

Sprint 4: Configuração do Grafana

Tarefa para Dann: Configurar o Grafana para buscar os dados armazenados no InfluxDB.

Tarefa para Ana Lívia: Desenvolver as visualizações e a definição de alertas em caso de eventos críticos. Além de obter materiais para a criação da maquete.


Sprint 5: Testes, Simulação e Análise de Resultados via Maquete

Tarefa para Dann: Construir uma maquete que simula as condições de deslocamento de encostas e realizar testes para verificar a eficácia do sistema de monitoramento, registrando os resultados obtidos.

Tarefa para Ana Lívia: Ajudar na construção da maquete, testes, e documentação.

Sprint 6: Relatório Final

Tarefa para Dann: Consolidar todas as informações coletadas ao longo do projeto em um relatório final, incluindo a descrição detalhada do protótipo desenvolvido, os resultados dos testes realizados e as conclusões alcançadas.

Tarefa para Ana Lívia: Revisar e editar o relatório final preparado por Dann, garantindo que todas as informações estejam claras, coesas e bem documentadas, e contribuir com insights adicionais para as conclusões do projeto.

Referências

DIATINF. Plano de Curso do Curso Superior de Tecnologia em Redes de Computadores. Natal: IFRN, 2013. Disponível em: https://diatinf.ifrn.edu.br/wp-content/uploads/2024/03/PPC__Tecnologia_em_Redes_de_Computadores_2013.pdf. Acesso em: 07 de Abril de 2024.

 

Mendes, R. M., et al. Proposição de limiares críticos ambientais para uso em

sistema de alertas de deslizamentos. Revista do Departamento de Geografia,

São Paulo, v. 40, ISSN 2236-2878, p.61-77, 2020. Disponível em:

https://www.revistas.usp.br/rdg/article/view/165390/166516. Acesso em: 07 abri. 2024

 

Ministério da Ciência, Tecnologia e Inovações. Centro Nacional de Monitoramento e Alertas de Desastres Naturais (CEMADEN). Deslizamentos. Disponível em: http://www2.cemaden.gov.br/deslizamentos/. Acesso em: 07 de abril de 2024.

 

Yan, T., Wu, Y., Li, Z., Xu, Z., & Geng, Y. (2021). Application of Internet of Things technology in landslide monitoring. In 2021 IEEE International Conference on Big Data and Smart Computing (BigComp) (pp. 1-5). IEEE.

 

Zhang, Y., Zhang, J., Qiu, Z., & Zhu, W. (2022). A Review of Landslide Monitoring Methods Based on Sensor Technology. In 2022 International Conference on Sensing, Diagnostics, Prognostics, and Control (SDPC) (pp. 396-399). IEEE. 
