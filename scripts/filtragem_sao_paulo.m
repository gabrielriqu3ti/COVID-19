%% PTC3456 - Processamento de Sinais Biomédicos
% Projeto 1

%% Customização
r = 0.99;
per_pop = 100000;

%% Importação de dados
data_sao_paulo = readtable('../data/dados_sao_paulo.csv');
% data_sao_paulo = readtable('../data/dados_campinas.csv');
% data_sao_paulo = readtable('../data/dados_botucatu.csv');

summary(data_sao_paulo);
[n_days, ~] = size(data_sao_paulo.data);
day_medium = ceil(n_days / 2);
city = 'São Paulo';

disp(['Número de dados: ', num2str(n_days)])

pop_sao_paulo = data_sao_paulo.pop(1);

w = 0.01:0.01:4*pi;
w0 = 2*pi/7;
C = (1 - 2*r*cos(w0) + r^2) / (2 - 2*cos(w0));
b = C*[1, -2*cos(w0), 1];
a = [1, -2*r*cos(w0), r^2];

figure(1)
freqz(b, a, w)

%% Filtragem
new_cases_moving_avg_3 = conv_moving_avg_filter(data_sao_paulo.casos_novos, 3);
new_cases_moving_avg_5 = conv_moving_avg_filter(data_sao_paulo.casos_novos, 5);
new_cases_moving_avg_7 = conv_moving_avg_filter(data_sao_paulo.casos_novos, 7);
new_cases_notch = filter(b, a, data_sao_paulo.casos_novos);

new_cases_per_pop_moving_avg_3 = conv_moving_avg_filter(data_sao_paulo.casos_novos_por_pop, 3);
new_cases_per_pop_moving_avg_5 = conv_moving_avg_filter(data_sao_paulo.casos_novos_por_pop, 5);
new_cases_per_pop_moving_avg_7 = conv_moving_avg_filter(data_sao_paulo.casos_novos_por_pop, 7);
new_cases_per_pop_notch = filter(b, a, data_sao_paulo.casos_novos_por_pop);

isolation_moving_avg_3 = conv_moving_avg_filter(data_sao_paulo.indice_isolamento, 3);
isolation_moving_avg_5 = conv_moving_avg_filter(data_sao_paulo.indice_isolamento, 5);
isolation_moving_avg_7 = conv_moving_avg_filter(data_sao_paulo.indice_isolamento, 7);
isolation_notch = filter(b, a, data_sao_paulo.indice_isolamento);

%% Colors
bar_color_src = [0.6, 0.6, 1];
bar_color_moving_avg_3 = [0.9, 0.4, 0.5];
bar_color_moving_avg_5 = [0.95, 0.6, 0.2];
bar_color_moving_avg_7 = [0.8, 0.4, 0.9];
bar_color_notch = [0.6, 0.8, 0.3];

marker_color_src = [0 0.4 0.7];
marker_color_moving_avg_3 = [0.7, 0.2, 0.3];
marker_color_moving_avg_5 = [0.85, 0.32, 0.1];
marker_color_moving_avg_7 = [0.5, 0.2, 0.6];
marker_color_notch = [0.3, 0.6, 0.1];

%% Visualização

figure(2)
subplot(511)
stem(data_sao_paulo.data, data_sao_paulo.casos_novos, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['Número de novos casos diários de COVID-19 no Município de ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(512)
stem(data_sao_paulo.data, new_cases_moving_avg_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_moving_avg_3, 'MarkerFaceColor', marker_color_moving_avg_3, 'MarkerEdgeColor', marker_color_moving_avg_3)
title(['Média móvel 3 do número de novos casos diários de COVID-19 no Município de ', city])
legend('média móvel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(513)
stem(data_sao_paulo.data, new_cases_moving_avg_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_moving_avg_5, 'MarkerFaceColor', marker_color_moving_avg_5, 'MarkerEdgeColor', marker_color_moving_avg_5)
title(['Média móvel 5 do número de novos casos diários de COVID-19 no Município de ', city])
legend('média móvel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(514)
stem(data_sao_paulo.data, new_cases_moving_avg_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_moving_avg_7, 'MarkerFaceColor', marker_color_moving_avg_7, 'MarkerEdgeColor', marker_color_moving_avg_7)
title(['Média móvel 7 do número de novos casos diários de COVID-19 no Município de ', city])
legend('média móvel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(515)
stem(data_sao_paulo.data, new_cases_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r),' do número de novos casos diários de COVID-19 no Município de ', city])
legend(['notch r=', num2str(r)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])


figure(3)
subplot(511)
stem(data_sao_paulo.data, per_pop * data_sao_paulo.casos_novos_por_pop, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['Número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes no Município de ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(512)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_moving_avg_3, 'MarkerFaceColor', marker_color_moving_avg_3, 'MarkerEdgeColor', marker_color_moving_avg_3)
title(['Média móvel 3 do número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes no Município de ', city])
legend('média móvel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(513)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_moving_avg_5, 'MarkerFaceColor', marker_color_moving_avg_5, 'MarkerEdgeColor', marker_color_moving_avg_5)
title(['Média móvel 5 do número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes no Município de ', city])
legend('média móvel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(514)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_moving_avg_7, 'MarkerFaceColor', marker_color_moving_avg_7, 'MarkerEdgeColor', marker_color_moving_avg_7)
title(['Média móvel 7 do número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes no Município de ', city])
legend('média móvel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(515)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r),' do número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes no Município de ', city])
legend(['notch r=', num2str(r)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])


figure(4)
subplot(511)
stem(data_sao_paulo.data, data_sao_paulo.indice_isolamento, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['Índice de isolamento social médio diário no Município de ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(512)
stem(data_sao_paulo.data, isolation_moving_avg_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_moving_avg_3, 'MarkerFaceColor', marker_color_moving_avg_3, 'MarkerEdgeColor', marker_color_moving_avg_3)
title(['Média móvel 3 do índice de isolamento social médio diário no Município de ', city])
legend('média móvel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(513)
stem(data_sao_paulo.data, isolation_moving_avg_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_moving_avg_5, 'MarkerFaceColor', marker_color_moving_avg_5, 'MarkerEdgeColor', marker_color_moving_avg_5)
title(['Média móvel 5 do índice de isolamento social médio diário no Município de ', city])
legend('média móvel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(514)
stem(data_sao_paulo.data, isolation_moving_avg_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_moving_avg_7, 'MarkerFaceColor', marker_color_moving_avg_7, 'MarkerEdgeColor', marker_color_moving_avg_7)
title(['Média móvel 7 do índice de isolamento social médio diário no Município de ', city])
legend('média móvel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(515)
stem(data_sao_paulo.data, isolation_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r),' do índice de isolamento social médio diário no Município de ', city])
legend(['notch r=', num2str(r)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])
