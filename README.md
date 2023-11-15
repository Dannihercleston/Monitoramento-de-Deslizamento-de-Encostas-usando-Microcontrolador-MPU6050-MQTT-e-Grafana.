# Monitoramento de Deslizamento de Encostas usando Microcontrolador,MPU6050,MQTT e Grafana.

![Captura de tela 2023-11-15 114113](https://github.com/Dannihercleston/Monitoramento-de-Deslizamento-de-Encostas-usando-Microcontrolador-MPU6050-MQTT-e-Grafana./assets/129909554/75592211-a2f0-4617-b009-0a91bb060de0)



Resumo da proposta 

Este projeto tem como objetivo a implementação de um Sistema de Monitoramento de Encostas baseado em dispositivos IoT (Internet das Coisas), que visa coletar dados de oscilação de encostas, para a prevenção de desastres naturais e a segurança de áreas vulneráveis através de alertas.

Entrega Final do MVP (Mínimo Produto Viável) 
A fase culminante deste projeto será a apresentação do Mínimo Produto Viável (MVP) por meio de uma maquete, simulação de um ambiente real. O sistema adotará o ESP32 como data logger, responsável por coletar dados dos sensores GY-521/MPU6050. Esses sensores registrarão informações relevantes sobre a oscilação e variação do solo. O ESP32, atuando como meio de transmissão sem fio, encarregar-se-á de transmitir esses dados para uma estação de monitoramento.

A transmissão dos dados será realizada até um servidor MQTT (broker Mosquitto) por meio do protocolo MQTT, proporcionando uma estrutura eficiente e segura. A visualização dos dados será apresentada de forma amigável em um dashboard criado no Grafana, permitindo o acompanhamento em tempo real das condições da encosta. Caso os dados ultrapassem as medidas estabelecidas como normais, o sistema gerará alertas, fornecendo assim informações cruciais para que clientes específicos, como a Defesa Civil, possam tomar iniciativas preventivas e mitigar possíveis desastres.
Essa abordagem integrada visa oferecer não apenas uma solução técnica eficaz, mas também uma interface de monitoramento intuitiva e proativa, facilitando a interpretação dos dados e a tomada de decisões por parte dos usuários finais.

O projeto se destina a clientes como defesa civil , empresas de monitoramento ambiental, CEMADEN, empresas que podem usar esses dados para agregá-lo aos seu sistemas como a Mesotech entre outros.
Em resumo, este projeto apresenta uma solução inovadora das que já existem no mercado, e relevante que combina tecnologia IoT, para melhorar a segurança e prevenir desastres em áreas de encosta, conectando-se a várias disciplinas do curso de Redes de Computadores.

Introdução

Segundo O Centro Nacional de Monitoramento e Alerta de Desastres Naturais – CEMADEN, deslizamento de massas é: movimentos de descida de solos ou rochas sob o efeito da gravidade que pode ser intensificado pela ação da Água. 

O Brasil é considerado muito suscetível aos movimentos de massa devido às condições climáticas marcadas por verões de chuvas intensas em regiões de grandes maciços montanhosos. Nos centros urbanos os movimentos de massa têm tomado proporções catastróficas. Atividades humanas como cortes em talude, aterros, depósitos de lixo, modificações na drenagem, desmatamentos, entre outras, têm aumentado a vulnerabilidade das encostas para a formação desses processos. Essa condição é agravada, principalmente, quando ocorrem ocupações irregulares, sem a infraestrutura adequada, em áreas de relevo íngreme. (Centro Nacional de Monitoramento e Alertas de Desastres Naturais - CEMADEN, 2023)

Neste contexto, este projeto tem como objetivo analisar uma aplicação de Redes de Sensores Sem Fio para a detecção de 'movimentos de massa'. Inspirado no estudo de Kim (2016), tem como fundamento os deslizamentos de massas que aconteceram na Coréia do Sul. Foi realizado a implementação de uma rede de sensores usando o acelerômetro biaxial. Cada unidade de sensoriamento contém o sensor, o transdutor, a conversão de sinal, processamento, memória, comunicação em rádio frequência e suprimento de energia via bateria.

No mercado brasileiro, a empresa que se destaca atualmente é a JRC Brasil. Entre as soluções oferecidas por ela, destaca-se o Sistema de Monitoramento de Encostas. A diferença notável entre o sistema proposto e o da concorrência reside no uso de um sistema de monitoramento open source, como o Grafana. Uma característica distintiva é que o sistema da JRC Brasil utiliza exclusivamente o sensor de acelerômetro para as medições. Em comparação com a solução almejada, adotaremos não apenas o sensor de acelerômetro, mas também um sensor de umidade, visando proporcionar maior exatidão nos dados. Essa ampliação do escopo torna o projeto ainda mais atrativo.

Justificativa

A importância da pesquisa e desenvolvimento de sistemas de monitoramento de deslizamento de massas não pode ser ignorada, pois podem causar sérios danos às infraestruturas e colocar vidas em risco. Nesse contexto, a proposta deste projeto se mostra relevante e oportuna para a antecipação e redução de casos com o monitoramento em tempo real, e no âmbito das redes de computadores por utilizar dispositivos de computação interconectados que podem trocar dados e compartilhar recursos entre si.

O projeto se destaca por integrar conhecimentos de várias disciplinas da graduação de redes de computadores, abordando tópicos da disciplina de Organização de Computadores de acordo com a ementa da disciplina, 1. Introdução à Organização de Computadores: Este tópico da ementa dá uma visão geral dos princípios fundamentais da arquitetura de computadores. É valioso para entender como os vários componentes do sistema se encaixam e interagem, fornecendo de alicerce para o projeto. 4. Sistema de Interconexão: Barramentos. Entender a estrutura de interconexão e a interconexão de barramentos é vital para garantir a comunicação eficaz entre os componentes o ESP32, o sensor MPU6050 .

O uso do ESP32 se encaixa na disciplina de Redes Sem Fio. abordando tópicos da disciplina de redes sem fio de acordo com a ementa da disciplina, 1 Introdução as Comunicações sem Fio:  O ESP32 é um módulo de comunicação sem fio, e conhecer as bases das comunicações sem fio ajuda a contextualizar o seu papel no projeto. 2 Fundamentos Básicos de Antenas: O conhecimento sobre ganho, sentido de antenas é valioso para maximizar a eficiência da comunicação sem fio.3 Propagação das Ondas Eletromagnéticas: O entendimento da propagação de ondas eletromagnéticas é essencial para prever como os sinais sem fio agem em um ambiente real. Isso é importante para a transmissão de dados em região de encostas, pois as condições geográficas podem afetar a propagação do sinal. 7 Principais Padrões de Redes sem Fio: O conhecimento dos padrões, é importante para entender as especificações técnicas e os protocolos que podem ser relevantes para o projeto. 8 Projeto e Implantação de Redes sem Fio:  Este tópico é se encaixa pois envolve o projeto e a implementação de redes sem fio.  enriquecendo o aprendizado com a aplicação real desses conceitos na transmissão dos dados coletados pelos sensores.

A disciplina Comunicação de dados é atrelada de acordo com a ementa da disciplina: 8 Fundamentos da Transmissão Digital: conhecimento dos critérios de Nyquist e a modulação PSK ou FSK é aplicável para transmissão digital. Isso é importante para evitar interferência inter-simbólica e garantir uma transmissão de dados eficaz. 10 Multiplexação e Acesso Múltiplo: Compreender os princípios de multiplexação por divisão de frequência (FDMA), por divisão de tempo (TDMA) e por divisão de códigos (CDMA) é relevante para otimizar o uso do espectro de frequência na comunicação sem fio.
Portanto, este projeto tem relevância interdisciplinar, que promove o entendimento dos conceitos abordados em Organização de Computadores, Redes Sem Fio, comunicação de dados, mas também fornece condições de criar uma solução tangível para um problema do mundo real. Com isso, a aplicação prática do sistema de monitoramento de encostas pode ter resultados positivos na prevenção de desastres naturais e na proteção de vidas e patrimônio.

Objetivo Geral

O propósito central deste projeto é desenvolver um produto que gere dados e monitore deslizamentos de encostas. O embasamento teórico será fundamentado nos conhecimentos adquiridos ao longo do curso de Redes de Computadores no IFRN, integrando as disciplinas de Organização de Computadores, Redes Sem Fio, Comunicação de Dados. A implementação do MVP (Minimum Viable Product) será conduzida através do microcontrolador ESP32, do sensor GY-521/MPU6050, do Broker Mosquitto utilizando o Protocolo MQTT (Message Queuing Telemetry Transport) e da plataforma Grafana.
O enfoque principal será atender a clientes que buscam prevenção para a população e estruturas públicas localizadas em áreas de risco de deslizamento de encostas. Esses potenciais clientes incluem órgãos de defesa civil, empresas especializadas em monitoramento ambiental, CEMADEN, e outras entidades que podem integrar esses dados aos seus sistemas, como a Mesotech, entre outros.
A materialização do projeto ocorrerá por meio de uma maquete, proporcionando uma representação visual e tangível do sistema proposto. A apresentação da solução em maquete visa facilitar a compreensão do funcionamento do protótipo, tornando a exposição do projeto mais acessível e elucidativa para públicos técnicos e não técnicos.

Objetivo Específico

Este projeto tem como objetivo principal desenvolver um protótipo para o monitoramento de encostas, viabilizando a coleta e processamento em tempo real de dados relativos aos deslocamentos em ambientes críticos. Com isso, delineamos os seguintes objetivos específicos:

1: Seleção de Sensores Adequados: Realizar uma seleção criteriosa de sensores, como o GY-521/MPU6050, capazes de efetuar medições precisas e confiáveis dos parâmetros relevantes para o monitoramento de encostas.

2: Configuração do ESP32 e GY-521/MPU6050: Programar o ESP32 para adquirir dados do sensor GY-521/MPU6050, processar as informações e efetuar o envio seguro e confiável dos dados obtidos.

3: Implementação da Comunicação MQTT: Configurar o protocolo MQTT no ESP32, estabelecendo uma comunicação eficiente com o servidor MQTT (broker Mosquitto), possibilitando o monitoramento em tempo real das oscilações em encostas.

4: Instalação e Configuração do Grafana: Realizar a instalação e configuração do software Grafana, estabelecendo alertas em caso de ultrapassagem dos níveis considerados seguros. Desenvolver uma interface de visualização de dados que permita a apresentação acessível e compreensível das informações coletadas, facilitando o acompanhamento das condições da encosta em tempo real.

5: Simulação e Análise de Resultados via Maquete: Construir uma maquete para simular as condições de deslocamento de encostas, analisando os resultados e gerando insights que possam ser usados para embasar decisões informadas relacionadas à segurança e prevenção de desastres naturais.

6: Relatório Final: Consolidar todas as etapas anteriores em um relatório abrangente, documentando o desenvolvimento do protótipo, os resultados obtidos e as conclusões alcançadas ao longo do projeto.

SPRINTS

Sprint 1: Planejamento e Seleção de Sensores 
Levantamento de requisitos e especificações para a seleção de sensores, com foco no GY-521/MPU6050.
Análise de mercado para identificação de sensores adequados às necessidades do monitoramento de encostas.
Documentação dos critérios de seleção e justificativas para a escolha do sensor.

Sprint 2: Desenvolvimento do Módulo de Aquisição de Dados 
Configuração do ambiente de desenvolvimento, incluindo a instalação do ESP32 e setup do GY-521/MPU6050.
Programação do ESP32 para aquisição e processamento preliminar de dados do sensor.
Implementação de testes unitários para garantir a confiabilidade da aquisição de dados.

Sprint 3: Configuração da Comunicação MQTT 
Configuração do protocolo MQTT no ESP32 para estabelecer a comunicação eficiente com o broker Mosquitto.
Desenvolvimento de mecanismos de segurança para a transmissão de dados.
Testes de comunicação e documentação das configurações realizadas.

Sprint 4: Instalação e Configuração do Grafana 
Instalação do software Grafana e configuração do ambiente para a integração com o ESP32.
Estabelecimento de alertas no Grafana para notificar em caso de ultrapassagem de níveis seguros.
Desenvolvimento da interface de visualização de dados de acordo com as necessidades do monitoramento de encostas.

Sprint 5: Construção da Maquete e Simulação 
Planejamento e aquisição de materiais para a construção da maquete.
Implementação da maquete para simular condições de deslocamento de encostas.
Integração do protótipo desenvolvido nas fases anteriores à maquete para análise dos resultados.

Sprint 6: Elaboração do Relatório Final 
Documentação detalhada de todas as etapas do projeto, incluindo requisitos, implementações, testes e resultados.
Análise crítica dos dados coletados na simulação via maquete.
Preparação do relatório final, destacando conclusões, insights e sugestões para melhorias futuras.

Referências utilizadas *
ARAÚJO, Gabriel Raykson Matos Brasil de, et al. A Transformação Digital no Contexto do Monitoramento de Encostas: Uma Visão Geral Sobre o Tema a Partir de uma Revisão. Revista COBRAE, VIII Conferência Brasileira sobre Estabilidade de Encostas, 2022.
BRITO, Gilmar Gonçalves de. Modelo de monitoramento de deslizamento de encostas por meio de sensor multiparamétrico. 2013. 146 páginas.
Centro Nacional de Monitoramento e Alertas de Desastres Naturais - CEMADEN. Deslizamentos de Terra no Brasil. Disponível em: http://www2.cemaden.gov.br/deslizamentos/. Acessado em: 21 de outubro de 2023.
KIM, H. W. Development of wireless sensor node for landslide detection, Proceedings of the Asia-Pacific advanced network, vol. 42, 2016. 
JRCBRASIL. Sistema de Monitoramento de Encostas. JRC Brasil. Disponível em: https://jrcbrasil.com/solucao/sistema-de-monitoramento-de-encostas/. Acesso em: 27 out. 2023. 
LEÃO, Júlio Cesar; SOUZA, Paulo Henrique de. Sistema Inteligente de Monitoramento de Deslizamento de Solos. Revista Gestão e Sustentabilidade Ambiental, Florianópolis, v. 7, p. 508-524, 2018. 
SEMIONE, Arthur; HOFFMANN, Kleyton; et al. Desenvolvimento de Módulos para Monitoramento de Encostas com o Uso de Sensoriamento Wireless. In: XX Congresso Brasileiro de Mecânica dos Solos e Engenharia Geotécnica, IX Simpósio Brasileiro de Mecânica das Rochas, IX Simpósio Brasileiro de Engenheiros Geotécnicos Jovens, VI Conferência Sul Americana de Engenheiros Geotécnicos Jovens, 2020. Páginas 831-837.

