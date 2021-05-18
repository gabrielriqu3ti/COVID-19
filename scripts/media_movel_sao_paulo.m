%% PTC3456 - Processamento de Sinais Biom�dicos
% Projeto 1

data_sao_paulo = readtable('../data/dados_sao_paulo.csv');

summary(data_sao_paulo);
[n_days, ~] = size(data_sao_paulo.data);
day_medium = ceil(n_days / 2);

disp(['N�mero de dados: ', num2str(n_days)])

% Popula��o de S�o Paulo
pop_sao_paulo = data_sao_paulo.pop(1);

%% Filtragem
new_cases_moving_avg_3 = conv_moving_avg_filter(data_sao_paulo.casos_novos, 3);
new_cases_moving_avg_5 = conv_moving_avg_filter(data_sao_paulo.casos_novos, 5);
new_cases_moving_avg_7 = conv_moving_avg_filter(data_sao_paulo.casos_novos, 7);

new_cases_per_pop_moving_avg_3 = conv_moving_avg_filter(data_sao_paulo.casos_novos_por_pop, 3);
new_cases_per_pop_moving_avg_5 = conv_moving_avg_filter(data_sao_paulo.casos_novos_por_pop, 5);
new_cases_per_pop_moving_avg_7 = conv_moving_avg_filter(data_sao_paulo.casos_novos_por_pop, 7);

isolation_moving_avg_3 = conv_moving_avg_filter(data_sao_paulo.indice_isolamento, 3);
isolation_moving_avg_5 = conv_moving_avg_filter(data_sao_paulo.indice_isolamento, 5);
isolation_moving_avg_7 = conv_moving_avg_filter(data_sao_paulo.indice_isolamento, 7);

%% Visualiza��o
figure(1)
plot(data_sao_paulo.data, data_sao_paulo.casos_novos)
hold on
plot(data_sao_paulo.data, new_cases_moving_avg_3)
hold on
plot(data_sao_paulo.data, new_cases_moving_avg_5)
hold on
plot(data_sao_paulo.data, new_cases_moving_avg_7)
hold off
title('N�mero de novos casos di�rios de COVID-19 no Munic�pio de S�o Paulo')
legend('original', 'm�dia m�vel 3', 'm�dia m�vel 5', 'm�dia m�vel 7')

figure(2)
plot(data_sao_paulo.data, 1000 * data_sao_paulo.casos_novos_por_pop)
hold on
plot(data_sao_paulo.data, 1000 * new_cases_per_pop_moving_avg_3)
hold on
plot(data_sao_paulo.data, 1000 * new_cases_per_pop_moving_avg_5)
hold on
plot(data_sao_paulo.data, 1000 * new_cases_per_pop_moving_avg_7)
hold off
title('N�mero de novos casos di�rios de COVID-19 por mil habitantes no Munic�pio de S�o Paulo')
legend('original', 'm�dia m�vel 3', 'm�dia m�vel 5', 'm�dia m�vel 7')

figure(3)
plot(data_sao_paulo.data, data_sao_paulo.indice_isolamento)
hold on
plot(data_sao_paulo.data, isolation_moving_avg_3)
hold on
plot(data_sao_paulo.data, isolation_moving_avg_5)
hold on
plot(data_sao_paulo.data, isolation_moving_avg_7)
hold off
title('�ndice de isolamento social m�dio di�rio no Munic�pio de S�o Paulo')
legend('original', 'm�dia m�vel 3', 'm�dia m�vel 5', 'm�dia m�vel 7')
