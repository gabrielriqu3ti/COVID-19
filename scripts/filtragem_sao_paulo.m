%% PTC3456 - Processamento de Sinais Biom�dicos
% Projeto 1

%% Customiza��o
r_c = 0.999;
r_i = 0.9;
per_pop = 100000;

%% Importa��o de dados
data_sao_paulo = readtable('../data/dados_sao_paulo.csv');

summary(data_sao_paulo);
[n_days, ~] = size(data_sao_paulo.data);
day_medium = ceil(n_days / 2);
city = 'S�o Paulo';

disp(['N�mero de dados: ', num2str(n_days)])

pop_sao_paulo = data_sao_paulo.pop(1);

w = 0.01:0.01:4*pi;
w0 = 2*pi/7;

C_c = (1 - 2*r_c*cos(w0) + r_c^2) / (2 - 2*cos(w0));
b_c = C_c * [1, -2*cos(w0), 1];
a_c = [1, -2*r_c*cos(w0), r_c^2];

C_i = (1 - 2*r_i*cos(w0) + r_i^2) / (2 - 2*cos(w0));
b_i = C_i * [1, -2*cos(w0), 1];
a_i = [1, -2*r_i*cos(w0), r_i^2];


figure(1)
freqz(b_c, a_c, w)

%% Filtragem
new_cases_moving_avg_3 = conv_moving_avg_filter(data_sao_paulo.casos_novos, 3);
new_cases_moving_avg_5 = conv_moving_avg_filter(data_sao_paulo.casos_novos, 5);
new_cases_moving_avg_7 = conv_moving_avg_filter(data_sao_paulo.casos_novos, 7);
new_cases_gaussian_3 = conv_gaussian_filter(data_sao_paulo.casos_novos, 3);
new_cases_gaussian_5 = conv_gaussian_filter(data_sao_paulo.casos_novos, 5);
new_cases_gaussian_7 = conv_gaussian_filter(data_sao_paulo.casos_novos, 7);

new_cases_notch = filter(b_c, a_c, data_sao_paulo.casos_novos);
new_cases_moving_avg_3_notch = conv_moving_avg_filter(new_cases_notch, 3);
new_cases_moving_avg_5_notch = conv_moving_avg_filter(new_cases_notch, 5);
new_cases_moving_avg_7_notch = conv_moving_avg_filter(new_cases_notch, 7);
new_cases_gaussian_3_notch = conv_gaussian_filter(new_cases_notch, 3);
new_cases_gaussian_5_notch = conv_gaussian_filter(new_cases_notch, 5);
new_cases_gaussian_7_notch = conv_gaussian_filter(new_cases_notch, 7);


new_cases_per_pop_moving_avg_3 = conv_moving_avg_filter(data_sao_paulo.casos_novos_por_pop, 3);
new_cases_per_pop_moving_avg_5 = conv_moving_avg_filter(data_sao_paulo.casos_novos_por_pop, 5);
new_cases_per_pop_moving_avg_7 = conv_moving_avg_filter(data_sao_paulo.casos_novos_por_pop, 7);
new_cases_per_pop_gaussian_3 = conv_gaussian_filter(data_sao_paulo.casos_novos_por_pop, 3);
new_cases_per_pop_gaussian_5 = conv_gaussian_filter(data_sao_paulo.casos_novos_por_pop, 5);
new_cases_per_pop_gaussian_7 = conv_gaussian_filter(data_sao_paulo.casos_novos_por_pop, 7);

new_cases_per_pop_notch = filter(b_c, a_c, data_sao_paulo.casos_novos_por_pop);
new_cases_per_pop_moving_avg_3_notch = conv_moving_avg_filter(new_cases_per_pop_notch, 3);
new_cases_per_pop_moving_avg_5_notch = conv_moving_avg_filter(new_cases_per_pop_notch, 5);
new_cases_per_pop_moving_avg_7_notch = conv_moving_avg_filter(new_cases_per_pop_notch, 7);
new_cases_per_pop_gaussian_3_notch = conv_gaussian_filter(new_cases_per_pop_notch, 3);
new_cases_per_pop_gaussian_5_notch = conv_gaussian_filter(new_cases_per_pop_notch, 5);
new_cases_per_pop_gaussian_7_notch = conv_gaussian_filter(new_cases_per_pop_notch, 7);


isolation_moving_avg_3 = conv_moving_avg_filter(data_sao_paulo.indice_isolamento, 3);
isolation_moving_avg_5 = conv_moving_avg_filter(data_sao_paulo.indice_isolamento, 5);
isolation_moving_avg_7 = conv_moving_avg_filter(data_sao_paulo.indice_isolamento, 7);
isolation_gaussian_3 = conv_gaussian_filter(data_sao_paulo.indice_isolamento, 3);
isolation_gaussian_5 = conv_gaussian_filter(data_sao_paulo.indice_isolamento, 5);
isolation_gaussian_7 = conv_gaussian_filter(data_sao_paulo.indice_isolamento, 7);

isolation_notch = filter(b_i, a_i, data_sao_paulo.indice_isolamento);
isolation_moving_avg_3_notch = conv_moving_avg_filter(isolation_notch, 3);
isolation_moving_avg_5_notch = conv_moving_avg_filter(isolation_notch, 5);
isolation_moving_avg_7_notch = conv_moving_avg_filter(isolation_notch, 7);
isolation_gaussian_3_notch = conv_gaussian_filter(isolation_notch, 3);
isolation_gaussian_5_notch = conv_gaussian_filter(isolation_notch, 5);
isolation_gaussian_7_notch = conv_gaussian_filter(isolation_notch, 7);

%% Cores
bar_color_src = [0.6, 0.6, 1];
bar_color_3 = [0.9, 0.4, 0.5];
bar_color_5 = [0.95, 0.6, 0.2];
bar_color_7 = [0.8, 0.4, 0.9];
bar_color_notch = [0.6, 0.8, 0.3];

marker_color_src = [0 0.4 0.7];
marker_color_3 = [0.7, 0.2, 0.3];
marker_color_5 = [0.85, 0.32, 0.1];
marker_color_7 = [0.5, 0.2, 0.6];
marker_color_notch = [0.3, 0.6, 0.1];

%% Visualiza��o

figure(2)
subplot(421)
stem(data_sao_paulo.data, data_sao_paulo.casos_novos, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['N�mero de novos casos di�rios de COVID-19 em ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(422)
stem(data_sao_paulo.data, new_cases_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r_c=', num2str(r_c),' do n�mero de novos casos di�rios de COVID-19 em ', city])
legend(['notch r_c=', num2str(r_c)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(423)
stem(data_sao_paulo.data, new_cases_moving_avg_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['M�dia m�vel 3 do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('m�dia m�vel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(425)
stem(data_sao_paulo.data, new_cases_moving_avg_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['M�dia m�vel 5 do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('m�dia m�vel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(427)
stem(data_sao_paulo.data, new_cases_moving_avg_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['M�dia m�vel 7 do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('m�dia m�vel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(424)
stem(data_sao_paulo.data, new_cases_gaussian_3, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('gaussian 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(426)
stem(data_sao_paulo.data, new_cases_gaussian_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('gaussian 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(428)
stem(data_sao_paulo.data, new_cases_gaussian_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('gaussian 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])


%% Figure 3
figure(3)
subplot(421)
stem(data_sao_paulo.data, data_sao_paulo.casos_novos, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['N�mero de novos casos di�rios de COVID-19 em ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(423)
stem(data_sao_paulo.data, new_cases_moving_avg_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['M�dia m�vel 3 e notch com r_c=', num2str(r_c), 'do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('m�dia m�vel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(425)
stem(data_sao_paulo.data, new_cases_moving_avg_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['M�dia m�vel 5 e notch com r_c=', num2str(r_c), 'do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('m�dia m�vel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(427)
stem(data_sao_paulo.data, new_cases_moving_avg_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['M�dia m�vel 7 e notch com r_c=', num2str(r_c), 'do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('m�dia m�vel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(422)
stem(data_sao_paulo.data, new_cases_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r_c=', num2str(r_c),' do n�mero de novos casos di�rios de COVID-19 em ', city])
legend(['notch r_c=', num2str(r_c)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(424)
stem(data_sao_paulo.data, new_cases_gaussian_3_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 e notch com r_c=', num2str(r_c), 'do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('gaussian 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(426)
stem(data_sao_paulo.data, new_cases_gaussian_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 e notch com r_c=', num2str(r_c), 'do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('gaussian 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(428)
stem(data_sao_paulo.data, new_cases_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 e notch com r_c=', num2str(r_c), 'do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('gaussian 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])


%% Figure 4
figure(4)
subplot(421)
stem(data_sao_paulo.data, per_pop * data_sao_paulo.casos_novos_por_pop, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['N�mero de novos casos di�rios de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(422)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r_c=', num2str(r_c),' do n�mero de novos casos di�rios de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend(['notch r_c=', num2str(r_c)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(423)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['M�dia m�vel 3 do n�mero de novos casos di�rios de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('m�dia m�vel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(425)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['M�dia m�vel 5 do n�mero de novos casos di�rios de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('m�dia m�vel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(427)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['M�dia m�vel 7 do n�mero de novos casos di�rios de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('m�dia m�vel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(424)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_gaussian_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 do n�mero de novos casos di�rios de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(426)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_gaussian_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 do n�mero de novos casos di�rios de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(428)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_gaussian_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 do n�mero de novos casos di�rios de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

%% Figure 5
figure(5)
subplot(421)
stem(data_sao_paulo.data, per_pop * data_sao_paulo.casos_novos_por_pop, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['N�mero de novos casos di�rios de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(422)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r_c=', num2str(r_c),' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend(['notch r_c=', num2str(r_c)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(423)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['M�dia m�vel 3 e notch com r_c=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('m�dia m�vel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(425)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['M�dia m�vel 5 e notch com r_c=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('m�dia m�vel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(427)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['M�dia m�vel 7 e notch com r_c=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('m�dia m�vel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(424)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_gaussian_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Gaussiana 3 e notch com r_c=', num2str(r_c), ' 3 do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(426)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_gaussian_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Gaussiana 5 e notch com r_c=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(428)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Gaussiana 7 e notch com r_c=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])


%% Figure 6
figure(6)
subplot(421)
stem(data_sao_paulo.data, data_sao_paulo.indice_isolamento, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['�ndice de isolamento social m�dio di�rio em ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(422)
stem(data_sao_paulo.data, isolation_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r_i=', num2str(r_i),' do �ndice de isolamento social m�dio di�rio em ', city])
legend(['notch r_i=', num2str(r_i)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(423)
stem(data_sao_paulo.data, isolation_moving_avg_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['M�dia m�vel 3 do �ndice de isolamento social m�dio di�rio em ', city])
legend('m�dia m�vel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(425)
stem(data_sao_paulo.data, isolation_moving_avg_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['M�dia m�vel 5 do �ndice de isolamento social m�dio di�rio em ', city])
legend('m�dia m�vel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(427)
stem(data_sao_paulo.data, isolation_moving_avg_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['M�dia m�vel 7 do �ndice de isolamento social m�dio di�rio em ', city])
legend('m�dia m�vel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(424)
stem(data_sao_paulo.data, isolation_gaussian_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 do �ndice de isolamento social m�dio di�rio em ', city])
legend('gaussian 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(426)
stem(data_sao_paulo.data, isolation_gaussian_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 do �ndice de isolamento social m�dio di�rio em ', city])
legend('gaussian 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(428)
stem(data_sao_paulo.data, isolation_gaussian_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 do �ndice de isolamento social m�dio di�rio em ', city])
legend('gaussian 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])


%% Figure 7
figure(7)
subplot(421)
stem(data_sao_paulo.data, data_sao_paulo.indice_isolamento, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['�ndice de isolamento social m�dio di�rio em ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(422)
stem(data_sao_paulo.data, isolation_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r_i=', num2str(r_i),' do �ndice de isolamento social m�dio di�rio em ', city])
legend(['notch r_i=', num2str(r_i)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(423)
stem(data_sao_paulo.data, isolation_moving_avg_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['M�dia m�vel 3 e notch com r_i=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('m�dia m�vel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(425)
stem(data_sao_paulo.data, isolation_moving_avg_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['M�dia m�vel 5 e notch com r_i=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('m�dia m�vel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(427)
stem(data_sao_paulo.data, isolation_moving_avg_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['M�dia m�vel 7 e notch com r_i=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('m�dia m�vel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(424)
stem(data_sao_paulo.data, isolation_gaussian_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 e notch com r_i=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('gaussian 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(426)
stem(data_sao_paulo.data, isolation_gaussian_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 e notch com r_i=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('gaussian 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(428)
stem(data_sao_paulo.data, isolation_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 e notch com r_i=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('gaussian 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

