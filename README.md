# Estudo da influência do isolamento social nos casos diários de COVID-19 no Estado de São Paulo

Este projeto almeja estudar a influência do isolamento social na quantidade de novos casos diários de COVID-19 no Estado de São Paulo. Para isso, coletamos o índice de isolamento social médio e número de novos casos diários de COVID-19 em três municípios do Estado de São Paulo: Botucatu, Campinas e São Paulo.

Estes dados foram filtrados com filtros média móvel de 3, 5 e 7 dias, com filtros Gaussianos e com um filtro do tipo *notch* para eliminar interferências semanais nos dados seguido de um filtro passa-baixa.

# Resultados

Os melhores resultados da filtragem foram obtidos com um filtro Gaussiano de 3 dias de desvio-padrão e filtro notch associados em série. Como mostrado na figura a seguir:

![Grafico de novos casos pop 100 milhoes e isolamento social para as 3 cidades](/images/comparao_novos_casos_isolamento.png)

Para avaliar a existência de uma correlação entre os dados de novos casos diários e de índice de isolamento social, foi traçado um correlograma entre as duas variáveis em função da diferença de dias na coleta de dados entre as grandezas. O resultado para o município de São Paulo consta abaixo:

![Correlograma entre novos casos e isolamento social por atraso](/images/sao_paulo_correlograma_novos_casos.png)

A partir do correlograma acima, nota-se que é não se pode afirmar que há uma correlação linear entre o índice de isolamento social dias antes da medida de novos casos diários com p-valor inferior a 0,05. Assim, a relação de causalidade entre as medidas não pode ser verificada por esta abordagem. Todavia, é possível afirmar que há uma correlação linear significativa e negativa entre o número de casos diários antes do índice de isolamento social.

Segundo o artigo (FERREIRA et al., 2021), não há uma relação simples entre o índice de isolamento social e a incidência de novos casos diários, o que está de acordo com a correlação encontrada em São Paulo. Para (FERREIRA et al., 2021) a incidência é na verdade resultado de uma combinação de fatores, como isolamento social, hierarquia urbana, índice de desenvolvimento humano e mobilidade humana e do comércio.

## Fontes

### Números de casos e óbitos

 - Secretaria de Estado da Saúde:  https://www.saopaulo.sp.gov.br/planosp/simi/dados-abertos/
 
### Índice de isolamento social

 - Associação Brasileira de Recursos em Telecomunicação (ABR Telecom):  https://www.saopaulo.sp.gov.br/planosp/simi/dados-abertos/

FERREIRA, C. P. et al. A snapshot of a pandemic: the interplay between social isolation and covid-19 dynamics in brazil. 04 2021
