# Waywall Setups Archive

[![GitHub last commit](https://img.shields.io/github/last-commit/gustavogordoni/waywall-setups?color=purple)](https://github.com/gustavogordoni/waywall-setups/commits/)
[![License](https://img.shields.io/github/license/gustavogordoni/waywall-setups)](https://github.com/gustavogordoni/waywall-setups/blob/main/LICENSE)

[English Version](README.en.md)

Coleção dos setups de Waywall que utilizei ao longo do tempo.

Este repositório tem como proposta organizar minhas configurações antigas. Antes disso, costumava criar cópias das pastas sempre que fazia alterações significativas, o que acabou resultando em diversos backups espalhados e sem um histórico claro das diferenças entre cada versão.

Ao transformar essas configurações em um repositório, passei a registrar cada setup separadamente, preservando tanto as configurações originais quanto as adaptações que fui desenvolvendo ao longo do tempo.

O objetivo deste projeto não é servir como minha configuração atual de Waywall, mas sim funcionar como um arquivo histórico dos diferentes setups que utilizei durante minha experiência com Linux MCSR.

---

## Histórico dos Setups

### arjuncgore

Baseado em:

* https://github.com/arjuncgore/waywall_generic_config

Foi uma das configurações que utilizei por mais tempo.

Além das adaptações visuais e ajustes pessoais, implementei uma versão personalizada do overlay para o Ninjabrain Bot utilizando:

* https://github.com/arjuncgore/waywall_ninbot_overlay

Nessa implementação, modifiquei a forma como as informações são exibidas na tela, reorganizando o layout e priorizando apenas os dados que considero mais relevantes durante as runs.

---

### arjuncgore-1366x768

Adaptação da configuração anterior voltada para monitores com resolução 1366x768.

* https://github.com/gustavogordoni/waywall-setups

Foi utilizada durante o período em que eu jogava em resolução menor e exigiu diversos ajustes de posicionamento, overlays e elementos da interface.

---

### NotE4sy

Baseado em:

* https://github.com/NotE4sy/fray-s-waywall-config

Foi uma das primeiras configurações que experimentei.

Apesar de simples, serviu como uma ótima introdução ao funcionamento do Waywall. Como possuía poucos componentes e uma estrutura relativamente fácil de entender, foi útil para aprender como diferentes configurações eram organizadas e quais elementos podiam ser personalizados.

Utilizei esse setup por pouco tempo, principalmente para experimentação.

---

### ethan-davies

Baseado em:

* https://github.com/ethan-davies/waywall-config

Embora essa configuração seja derivada do setup do Soup, foi a primeira versão mais avançada que consegui adaptar com sucesso para meu ambiente.

Por algum motivo, na época tive mais facilidade para fazer essa configuração funcionar do que a versão original do Soup.

Ela serviu como ponte entre os setups mais simples e as configurações mais complexas que utilizo atualmente.

---

### soup12h

Baseado em:

* https://github.com/soup12h/waywall-config

É a configuração que utilizo atualmente.

Apesar de eu já conhecer esse setup há bastante tempo, inicialmente tive dificuldades para fazê-lo funcionar corretamente.

Depois de utilizar a configuração do Ethan Davies por um período e entender melhor sua estrutura interna, consegui finalmente adaptar o setup original do Soup às minhas necessidades.

Atualmente também estou desenvolvendo uma integração com:

* https://github.com/qMaxXen/NBTrackr

A ideia é substituir meu antigo overlay personalizado do Ninjabrain Bot por uma solução baseada no NBTrackr.

Em vez de desenhar manualmente os elementos da interface, o Waywall passa a exibir diretamente a imagem gerada pelo NBTrackr, permitindo utilizar todos os recursos e personalizações oferecidos pelo projeto original.

Essa abordagem permite exibir dentro do Waywall exatamente a imagem produzida pelo NBTrackr, mantendo sincronização automática com as informações do Ninjabrain Bot.

---

## Demais projetos utilizados (direta ou indiretamente)

### Waywall

https://github.com/tesselslate/waywall

### Ninjabrain Bot

https://github.com/Ninjabrain1/Ninjabrain-Bot

### NBTrackr

https://github.com/qMaxXen/NBTrackr

### waywall_ninbot_overlay

https://github.com/arjuncgore/waywall_ninbot_overlay

### Waywork

https://github.com/Esensats/waywork

### plug.waywall

https://github.com/its-saanvi/plug.waywall

---

## Observação

Este repositório existe principalmente para fins de documentação e preservação dos setups que utilizei ao longo do tempo.

As configurações armazenadas aqui representam diferentes momentos da minha experiência com Waywall e Linux MCSR, podendo conter adaptações pessoais, experimentos, integrações incompletas ou recursos que não refletem necessariamente meu setup atual.
