"""
 Arquivo   : preprocessamento_de_dados.py
 Autor     : Gabriel Henrique Riqueti
 E-mail    : gabrielhriqueti@gmail.com
 Data      : 17/05/2021
 Descrição : Realiza um pré-processamento dos dados de Covid-19 nos municípios do Estado de São Paulo.

 Pré-processamento do banco de dados gerais de Covid-19 por município:
    - Formata data no formato YYYY-MM-DD que ficam em ordem cronológica se ordenar a tabela em ordem crescente
    - Renomeia as colunas 'nome_munic', 'datahora' para 'municipio' e 'data'

 Pré-processamento do banco de dados de isolamento de Covid-19 por município:
    - Remove dia da semana
    - Adiciona o ano
    - Formata data no formato YYYY-MM-DD que ficam em ordem cronológica se ordenar a tabela em ordem crescente
    - Renomeia as colunas 'Município1', 'Data' para 'municipio' e 'data'

"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# Importação de dados
isolation_sp = pd.read_csv('../data/20210516_isolamento.csv', sep=';', decimal=',')
cases_sp = pd.read_csv('../data/20210516_dados_covid_municipios_sp.csv', sep=';', decimal=',')


# Renomeando colunas
isolation_sp = isolation_sp.rename(columns={'Data': 'data',
                                            'Média de Índice De Isolamento': 'indice_isolamento',
                                            'Município1': 'municipio'})
cases_sp = cases_sp.rename(columns={'datahora': 'data', 'nome_munic': 'municipio'})


# Remove dia da semana
isolation_sp['data'] = isolation_sp['data'].map(lambda x: x.split(', ')[1])


# Adiciona ano
n_days_per_city = isolation_sp.groupby('municipio').size()

isolation_sp_31_12 = isolation_sp[isolation_sp['data'] == '31/12'].copy()
isolation_sp_31_12['index_31/12'] = (isolation_sp[isolation_sp['data'] == '31/12']).index

isolation_sp_31_12_np = isolation_sp_31_12.to_numpy()
isolation_sp_31_12_broadcast = pd.DataFrame(
    data=np.repeat(isolation_sp_31_12_np, n_days_per_city[isolation_sp_31_12['municipio']], axis=0),
    columns=isolation_sp_31_12.columns
)

isolation_sp_index_2020 = isolation_sp.index >= isolation_sp_31_12_broadcast['index_31/12']
isolation_sp_index_2021 = isolation_sp.index < isolation_sp_31_12_broadcast['index_31/12']

isolation_sp.loc[isolation_sp_index_2020, 'data'] = isolation_sp[isolation_sp_index_2020]['data'] + '/2020'
isolation_sp.loc[isolation_sp_index_2021, 'data'] = isolation_sp[isolation_sp_index_2021]['data'] + '/2021'


# Muda formato da data
cases_sp['data'] = pd.to_datetime(cases_sp['data'], format="%d/%m/%Y")

try:
    isolation_sp['data'] = pd.to_datetime(isolation_sp['data'], format="%d/%m/%Y")
except ValueError:
    for data in isolation_sp['data']:
        data_parts = data.split('/')
        if int(data_parts[1]) in {1, 3, 5, 7, 8, 10, 12}:
            if int(data_parts[0]) > 31:
                print(data)
        elif int(data_parts[1]) == 2:
            if int(data_parts[0]) > 29 and int(data_parts[2]) % 4 == 0:
                print(data)
            elif int(data_parts[0]) > 28 and int(data_parts[2]) % 4 != 0:
                print(data)
        else:
            if int(data_parts[0]) > 30:
                print(data)


# Seleciona dados de São Paulo
cases_sao_paulo = cases_sp[cases_sp['municipio'] == 'São Paulo'][['data', 'casos_novos']]
isolation_sao_paulo = isolation_sp[isolation_sp['municipio'] == 'SÃO PAULO'][['data', 'indice_isolamento']]

cases_sao_paulo = cases_sao_paulo.set_index('data')
isolation_sao_paulo = isolation_sao_paulo.set_index('data')


# Réune dados de São Paulo
data_sao_paulo = cases_sao_paulo.copy()
data_sao_paulo = data_sao_paulo.join(isolation_sao_paulo)


# Lida com dados ausentes do Município de São Paulo
if data_sao_paulo['casos_novos'].hasnans:
    print(f"data_sao_paulo['casos_novos'] has {len(data_sao_paulo['casos_novos'].isna())} NaN")
    data_sao_paulo['casos_novos'].fillna(0, inplace=True)
if data_sao_paulo['indice_isolamento'].hasnans:
    print(f"data_sao_paulo['indice_isolamento'] has {len(data_sao_paulo[data_sao_paulo['indice_isolamento'].isna()])} NaN")
    data_sao_paulo['indice_isolamento'].fillna(data_sao_paulo['indice_isolamento'].median(), inplace=True)


# Inspeção visual
print(data_sao_paulo.head(3))
print(data_sao_paulo.tail(3))

isolation_sao_paulo.plot()
plt.grid()
cases_sao_paulo.plot()
plt.grid()
plt.show()


# Salva dados pré-processados
cases_sp.to_csv('../data/dados_covid_sp_preprocessado_py.csv')
isolation_sp.to_csv('../data/isolamento_sp_preprocessado_py.csv')
data_sao_paulo.to_csv('../data/dados_sao_paulo.csv')
