"""
 Arquivo   : preprocessamento_de_dados.py
 Autor     : Gabriel Henrique Riqueti
 E-mail    : gabrielhriqueti@gmail.com
 Data      : 17/05/2021
 Descrição : Realiza um pré-processamento dos dados de Covid-19 nos municípios do Estado de São Paulo.

 Pré-processamento do banco de dados gerais de Covid-19 por município:
    - Formata data no formato YYYY-MM-DD que ficam em ordem cronológica se ordenar a tabela em ordem crescente
    - Renomeia as colunas 'nome_munic', 'datahora' para 'municipio' e 'data'
    - Muda o separador de colunas de ';' para ','
    - Muda o separador decimal de ',' para '.'

 Pré-processamento do banco de dados de isolamento de Covid-19 por município:
    - Remove dia da semana
    - Adiciona o ano
    - Formata data no formato YYYY-MM-DD que ficam em ordem cronológica se ordenar a tabela em ordem crescente
    - Muda o separador de colunas de ';' para ','
    - Muda o separador decimal de ',' para '.'
    - Renomeia as colunas :
        - 'Média de Índice De Isolamento': 'indice_isolamento'
        - 'Município1': 'municipio'
        - 'Código Município IBGE': 'codigo_ibge'
        - 'População estimada (2020)': 'pop'
        - 'UF1': 'uf'

"""

import re
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def save_data_from_city(city):
    """
    Salva e exibe o gráfico de novos casos de Covid-19 e o índice de isolamento social em um município do Estado de São Paulo.

    Params:
    _______
    - city: str
                 Nome do município do Estado de São Paulo a ser salvo
    """
    cases_city = cases_sp[cases_sp['municipio'] == city][['data', 'casos_novos', 'pop']]
    isolation_city = isolation_sp[isolation_sp['municipio'] == city.upper()][['data', 'indice_isolamento']]

    cases_city = cases_city.set_index('data')
    isolation_city = isolation_city.set_index('data')

    # Réune dados de São Paulo
    data_city = cases_city.copy()
    data_city = data_city.join(isolation_city)

    # Lida com dados ausentes do Município de São Paulo
    if data_city['casos_novos'].hasnans:
        print(f"data_city['casos_novos'] has {len(data_city['casos_novos'].isna())} NaN que serão corrigidos")
        data_city['casos_novos'].fillna(0, inplace=True)
    if data_city['pop'].hasnans:
        print(f"data_city['pop'] has {len(data_city['pop'].isna())} NaN que serão corrigidos")
        data_city['pop'].fillna(data_city['pop'].median(), inplace=True)

    if data_city['indice_isolamento'].hasnans:
        print(
            f"data_city['indice_isolamento'] has {len(data_city[data_city['indice_isolamento'].isna()])} NaN que serão corrigidos")
        data_city['indice_isolamento'].fillna(data_city['indice_isolamento'].median(), inplace=True)

    data_city['casos_novos_por_pop'] = data_city['casos_novos'] / data_city['pop']

    # Inspeção
    print()
    print('Descrição data_city')
    print(data_city.describe())

    print()
    print('Quantidade de dados')
    print(f"Dados de {city:<15} : {sum(cases_sp[cases_sp['municipio'] == city]['casos_novos']):>7}")
    print(f"Dados ignorados       : {sum(cases_sp[cases_sp['municipio'] == 'Ignorado']['casos_novos']):>7}")

    isolation_city.plot()
    plt.grid()
    plt.title(f'Índice de isolamento social médio diário no Município de {city}')
    plt.xlabel('data')

    plt.figure()
    cases_city['casos_novos'].plot()
    plt.title(f'Número de novos casos diários de COVID-19 no Município de {city}')
    plt.xlabel('data')
    plt.grid()
    plt.show()

    city_fmt = re.sub(r"[âãàá]",  "a", city.lower())
    city_fmt = re.sub(r" ",  "_", city_fmt)
    city_fmt = re.sub(r"[^a-zA-Z0-9_]", "", city_fmt)

    # Salva dados pré-processados
    data_city.to_csv(f'../data/dados_{city_fmt}.csv')


# Importação de dados
isolation_sp = pd.read_csv('../data/20210516_isolamento.csv', sep=';', decimal=',')
cases_sp = pd.read_csv('../data/20210516_dados_covid_municipios_sp.csv', sep=';', decimal=',')


# Renomeia colunas
isolation_sp = isolation_sp.rename(columns={'Data': 'data',
                                            'Média de Índice De Isolamento': 'indice_isolamento',
                                            'Município1': 'municipio',
                                            'Código Município IBGE': 'codigo_ibge',
                                            'População estimada (2020)': 'pop',
                                            'UF1': 'uf'})
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


# Salva dados de Botucatu, Campinas e São Paulo,
save_data_from_city('Botucatu')
save_data_from_city('Campinas')
save_data_from_city('São Paulo')

print()
# Inspeção
print('Descrição cases_sp')
print(cases_sp.describe())
print('Descrição isolation_sp')
print(isolation_sp.describe())
print('Descrição data_city')

print()
print('Quantidade de dados')
print(f"Dados de Botucatu  : {sum(cases_sp[cases_sp['municipio'] == 'Botucatu']['casos_novos']):>7}")
print(f"Dados de Campinas  : {sum(cases_sp[cases_sp['municipio'] == 'Campinas']['casos_novos']):>7}")
print(f"Dados de São Paulo : {sum(cases_sp[cases_sp['municipio'] == 'São Paulo']['casos_novos']):>7}")
print(f"Dados ignorados    : {sum(cases_sp[cases_sp['municipio'] == 'Ignorado']['casos_novos']):>7}")


# Salva dados pré-processados
cases_sp.to_csv('../data/dados_covid_sp_preprocessado_py.csv')
isolation_sp.to_csv('../data/isolamento_sp_preprocessado_py.csv')
