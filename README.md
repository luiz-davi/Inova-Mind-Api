# 📰  Api Quotes  📰
> Status: **Finalizado**✅<br>

## Sobre o projeto 📑
Projeto proposto pela [Inova Mind](https://inovamind.com.br) para que eu pudesse demonstrar minhas habilidades. O projeto é uma API que faz um web Crawler da página [Quotes to Scrape](http://quotes.toscrape.com)(site esse que disponibiliza frases) e extrai as informações necessárias e retorna em formato json. 

## Objetivo ✅
O objetivo principal da API é buscar e armazenar em cache as frases. Retorna as informações de cada frase em formato Json. Ele tanto retorna as informações diretamente do site, como também armazena em cache caso a busca já tenha sido feita anteriormente. Essas buscas são feitas através de parâmetros indicados na URL. Atualmente existem 2 buscas (endpoints) na api: buscar pela *tag* e pelo *author*

## Implementação 🛠
+ A Frase se divide em *texto da frase*, *autor*, *link de perfil do autor* e as *tags* que referenciam a frase. Esse model foi dividido em dois: frase e tag. Para fazer a junção dos dois com o relacionamento de muitos pra muitos foi usado o has_many_through:

  ![image](https://user-images.githubusercontent.com/55983920/146430609-266d42ec-b54e-4b3b-85ad-514410af1b27.png)

  ![image](https://user-images.githubusercontent.com/55983920/146430792-3e443cce-1553-43c7-8c01-be25bd5e6a2c.png)

  ![image](https://user-images.githubusercontent.com/55983920/146430646-e3425428-a1d2-4ac3-bda4-28a48c751082.png)

+ Para obter as informações das frases, foi feito o web crawler da página [Quotes to Scrape](http://quotes.toscrape.com), utilizando a gem [Nokogiri](https://rubygems.org/gems/nokogiri/versions/1.6.8?locale=pt-BR).

+ O armazenamento em cache se comporta de duas formas: se a tag *não foi* pesquisada ainda, ela é salva no banco com o atributo 'pesquisada' marcado como verdadeiro
, isso faz com que não seja mais preciso voltar no site e 'minerar' as informações.

+ Como cada frase pode ter várias tags, as tags secundárias são salvas, mas marcadas como 'não' pesquisadas, ou seja, todas as frases dessa tag não estão em cache, apenas as frases em comum com a tag que está sendo de fato pesquisada. Quando uma tag que foi salva como secundária é pesquisada, é feita mais uma pesquisa na página, dessa vez pesquisando apenas as frases que faltam. E logicamente essa tag agora muda o status pra pesquisada igual a verdadeiro.

## Buscas 🔍
+ Buscas por *tag*:   /quotes/{TAG}
+ Busca por *author*:   /buscar_frase_author/{AUTHOR}

## Informações Adicionais ➕
O usuário padrão é criado no AplicationController<br>
Email: *teste-api@gmail.com*<br>
Senha: *123456*
