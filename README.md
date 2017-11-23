# PUNK API

## Este projeto foi feito com:
- ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
- rbenv 1.1.1-6-g2d7cefe
- Rails 5.1.4

## Diagram ER
https://imgur.com/a/FPZ3H

## Testes
- Utilizei FactoryBot (antigo FactoryGirl) para substituir as fixtures
- Foram feitos testes unitários e de integração (request specs).
- Escolhi trabalhar com requests specs em vez de controllers specs devido a recomendação dos criadores do Rails e do RSpec, pois é um tipo de teste mais abrangente, evitando granularização desnecessária. 
- A randomização dos testes está ativada a afim de garantir a robustez das specs. Caso deseje testar na ordem original, basta comentar a linha `config.order = :random` no arquivo spec_helper.rb.
- Foi utilizada a gem spring-commands-rspec a fim de aumentar a velocidade em que são carregados e executados os testes.

### Como rodar os testes
Para rodar os testes execute sempre adicionado 'bundle exec' no início do comando. Exemplo: `bundle exec spring rspec`. Após isto, um output semelhante a este deverá ser mostrado: 

Finished in 2.28 seconds (files took 0.26843 seconds to load)
129 examples, 0 failures

Randomized with seed 49082

## Instruções para rodar a aplicação localmente
- Clonar este repositório
- `bundle install`
- `bundle exec rake db:create`
- `bundle exec rake db:migrate`
- Configurar variáveis no arquivo .env
- Recomenda-se configurar seu arquivo /etc/hosts adicionando o seguinte códgio `0.0.0.0 punkapi.com`
- `rails s`
- `redis-server`

## Banco de dados
- Foi utilizado o PostgreSQL. Lembre-se de alterar as configurações para o banco no arquivo .env
- Se desejar, existem seeds preparadas para popular o banco no arquivo seeds.rb

## Requisições para a API
- A URL base é http://punkapi.com:3000/v2
- É preciso enviar o cabeçalho Accept com o seguinte valor: application/fractal.punk.v2 (esta foi um pequena medida de segurança para não deixar a API tão aberta a qualquer um)

## Redis
- Implementei, como exemplo, cada action index dos controllers utilizando Redis.
- Após rodar o bundle install para instalar as gems referentes ao Redis, startar o servidor do redis numa outra aba do terminal através do comando `redis-server`

## Observações
- API está versionada
- CORS está ativado
- Rate Limiting e Throttling foi configurado