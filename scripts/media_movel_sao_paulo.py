# -*- coding: utf-8 -*-
# @file media_movel_sao_paulo.py
# @author Gabriel Henrique Riqueti
# @date 17/05/2021
# @brief Cálcula a média móvel dos cases e óbitos de covid-19

import pandas as pd
import matplotlib.pyplot as plt

def preprocess_isolation_data(date):
    """
    Remove dia da semana e adiciona o daquela data, considerando que datas a partir de maio são de 2020 e datas até
    fevereiro são de 2021

    Params
    ------
    date : str
           Data no formto

    Returns
    _______
    out : str
         Data no formato 'dia/mês/ano'
    """
    # Removendo semana
    date_comma_parts = date.split(', ')
    date_day_month = date_comma_parts[1]

    # Adicionando ano
    date_parts = date_day_month.split('/')
    if int(date_parts[1]) >= 5:
        # Maio a dezembro de 2020
        return date_day_month + '/2020'
    else:
        # janeiro e fevereiro de 2021
        return date_day_month + '/2021'


isolation_sp = pd.read_csv('../data/20210516_isolamento.csv', sep=';', decimal=',')
cases_sp = pd.read_csv('../data/20210516_dados_covid_municipios_sp.csv', sep=';', decimal=',')

isolation_sp['Data'] = isolation_sp['Data'].map(preprocess_isolation_data)

cases_sao_paulo = cases_sp[cases_sp['nome_munic'] == 'São Paulo'][['datahora', 'casos_novos']]
isolation_sao_paulo = isolation_sp[isolation_sp['Município1'] == 'SÃO PAULO'][['Data', 'Média de Índice De Isolamento']]

isolation_sao_paulo = isolation_sao_paulo.rename(columns={'Data': 'datahora', 'Média de Índice De Isolamento': 'indice_isolamento'})

cases_sao_paulo = cases_sao_paulo.set_index('datahora')
isolation_sao_paulo = isolation_sao_paulo.set_index('datahora')

dados_sao_paulo = cases_sao_paulo.copy()
dados_sao_paulo = dados_sao_paulo.join(isolation_sao_paulo)

plt.figure(1)
isolation_sao_paulo.plot()
cases_sao_paulo.plot()
plt.show()

# Falta aplicar a média móvel ainda
