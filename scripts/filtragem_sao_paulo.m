%% PTC3456 - Processamento de Sinais Biom�dicos
% Projeto 1

%% Customiza��o
r_c = 0.999;
r_i = 0.9;
per_pop = 100000;
city = 'S�o Paulo';
save = false;
correlation_init_delay = -300;
correlation_final_delay = 300;

%% Fases

% in�cio da quarentena: 2020-03-22 -> hoje (2021-05-15)
quarantene_begin = datetime('2020-03-22', 'InputFormat', 'yyyy-MM-dd');
quarantene_end = datetime('2021-05-16', 'InputFormat', 'yyyy-MM-dd');

set(groot, 'defaultAxesXGrid', 'on')
set(groot, 'defaultAxesYGrid', 'on')
set(groot, 'defaultAxesXMinorGrid', 'on', 'defaultAxesXMinorGridMode', 'manual')
set(groot, 'defaultAxesYMinorGrid', 'on', 'defaultAxesYMinorGridMode', 'manual')
set(groot, 'defaultLegendLocation', 'northwest')

%% Importa��o de dados
data_sao_paulo = readtable('../data/dados_sao_paulo.csv');

summary(data_sao_paulo);
[n_days, ~] = size(data_sao_paulo.data);
day_medium = ceil(n_days / 2);

disp(['N�mero de dados: ', num2str(n_days)])

pop_sao_paulo = data_sao_paulo.pop(1);

w = 0.01:0.01:2*pi;
w0 = 2*pi/7;

C_c = (1 - 2*r_c*cos(w0) + r_c^2) / (2 - 2*cos(w0));
b_c = C_c * [1, -2*cos(w0), 1];
a_c = [1, -2*r_c*cos(w0), r_c^2];

C_i = (1 - 2*r_i*cos(w0) + r_i^2) / (2 - 2*cos(w0));
b_i = C_i * [1, -2*cos(w0), 1];
a_i = [1, -2*r_i*cos(w0), r_i^2];


% figure(1)
% freqz(b_c, a_c, w)
% title(['Diagrama de Bold do Filtro do tipo notch com r=', num2str(r_c)])

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

quarantene_color = [0.99, 0.7, 0.7];

%% Visualiza��o

figure(1)
subplot(421)
stem(data_sao_paulo.data, data_sao_paulo.casos_novos, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['N�mero de novos casos di�rios de COVID-19 em ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(422)
stem(data_sao_paulo.data, new_cases_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r_c),' do n�mero de novos casos di�rios de COVID-19 em ', city])
legend(['notch r=', num2str(r_c)])
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

if save
    saveas(gcf, '../images/sao_paulo_novos_casos_filtragem.png')
end

%% Figure 2
figure(2)
subplot(421)
stem(data_sao_paulo.data, data_sao_paulo.casos_novos, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['N�mero de novos casos di�rios de COVID-19 em ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(423)
stem(data_sao_paulo.data, new_cases_moving_avg_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['M�dia m�vel 3 e notch com r=', num2str(r_c), ' do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('m�dia m�vel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(425)
stem(data_sao_paulo.data, new_cases_moving_avg_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['M�dia m�vel 5 e notch com r=', num2str(r_c), ' do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('m�dia m�vel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(427)
stem(data_sao_paulo.data, new_cases_moving_avg_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['M�dia m�vel 7 e notch com r=', num2str(r_c), ' do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('m�dia m�vel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(422)
stem(data_sao_paulo.data, new_cases_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r_c),' do n�mero de novos casos di�rios de COVID-19 em ', city])
legend(['notch r=', num2str(r_c)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(424)
stem(data_sao_paulo.data, new_cases_gaussian_3_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 e notch com r=', num2str(r_c), ' do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('gaussian 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(426)
stem(data_sao_paulo.data, new_cases_gaussian_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 e notch com r=', num2str(r_c), ' do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('gaussian 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(428)
stem(data_sao_paulo.data, new_cases_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 e notch com r=', num2str(r_c), ' do n�mero de novos casos di�rios de COVID-19 em ', city])
legend('gaussian 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

if save
    saveas(gcf, '../images/sao_paulo_novos_casos_filtragem_notch.png')
end

%% Figure 3
figure(3)
subplot(421)
stem(data_sao_paulo.data, per_pop * data_sao_paulo.casos_novos_por_pop, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['N�mero de novos casos di�rios de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(422)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r_c),' do n�mero de novos casos di�rios de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend(['notch r=', num2str(r_c)])
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

if save
    saveas(gcf, '../images/sao_paulo_novos_casos_por_pop_filtragem.png')
end

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
title(['Filtragem notch com r=', num2str(r_c),' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend(['notch r=', num2str(r_c)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(423)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['M�dia m�vel 3 e notch com r=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('m�dia m�vel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(425)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['M�dia m�vel 5 e notch com r=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('m�dia m�vel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(427)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_moving_avg_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['M�dia m�vel 7 e notch com r=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('m�dia m�vel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(424)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_gaussian_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Gaussiana 3 e notch com r=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(426)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_gaussian_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Gaussiana 5 e notch com r=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(428)
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Gaussiana 7 e notch com r=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

if save
    saveas(gcf, '../images/sao_paulo_novos_casos_por_pop_filtragem_notch.png')
end

%% Figure 5
figure(5)
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
title(['Filtragem notch com r=', num2str(r_i),' do �ndice de isolamento social m�dio di�rio em ', city])
legend(['notch r=', num2str(r_i)])
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

if save
    saveas(gcf, '../images/sao_paulo_isolamento_filtragem.png')
end


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
title(['Filtragem notch com r=', num2str(r_i),' do �ndice de isolamento social m�dio di�rio em ', city])
legend(['notch r=', num2str(r_i)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(423)
stem(data_sao_paulo.data, isolation_moving_avg_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['M�dia m�vel 3 e notch com r=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('m�dia m�vel 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(425)
stem(data_sao_paulo.data, isolation_moving_avg_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['M�dia m�vel 5 e notch com r=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('m�dia m�vel 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(427)
stem(data_sao_paulo.data, isolation_moving_avg_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['M�dia m�vel 7 e notch com r=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('m�dia m�vel 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(424)
stem(data_sao_paulo.data, isolation_gaussian_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 e notch com r=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('gaussian 3')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(426)
stem(data_sao_paulo.data, isolation_gaussian_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 e notch com r=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('gaussian 5')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

subplot(428)
stem(data_sao_paulo.data, isolation_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 e notch com r=', num2str(r_i), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('gaussian 7')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

if save
    saveas(gcf, '../images/sao_paulo_isolamento_filtragem_notch.png')
end

%% Figura 7
figure(7)

subplot(311)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 10000, 10000], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_sao_paulo.data, data_sao_paulo.casos_novos, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['N�mero de novos casos di�rios de COVID-19 em ', city])
legend('quarentena', 'original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(312)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 80, 80], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_sao_paulo.data, per_pop * data_sao_paulo.casos_novos_por_pop, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['N�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('quarentena', 'original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(313)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 1, 1], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_sao_paulo.data, data_sao_paulo.indice_isolamento, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['�ndice de isolamento social m�dio di�rio em ', city])
legend('quarentena', 'original')
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])
if save
    saveas(gcf, '../images/sao_paulo_dados_originais.png')
end

%% Figura 8

figure(8)
subplot(311)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 4000, 4000], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_sao_paulo.data, new_cases_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['N�mero de novos casos di�rios de COVID-19 em ', city])
legend('quarentena', ['gaussian 7 notch r=', num2str(r_c)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(312)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 40, 40], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_sao_paulo.data, per_pop * new_cases_per_pop_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['Gaussiana 7 e notch com r=', num2str(r_c), ' do n�mero de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('quarentena', ['gaussian 7 notch r=', num2str(r_c)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])

subplot(313)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 5000, 5000], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_sao_paulo.data, isolation_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['Gaussiana 7 e notch com r=', num2str(r_c), ' do �ndice de isolamento social m�dio di�rio em ', city])
legend('quarentena', ['gaussian 7 notch r=', num2str(r_i)])
xlim([data_sao_paulo.data(1), data_sao_paulo.data(n_days)])
ylim([0, 1])

if save
    saveas(gcf, '../images/sao_paulo_dados_filtrados.png')
end


%% Figura 9

figure(9)
subplot(221)
scatter(new_cases_gaussian_7_notch, isolation_gaussian_7_notch, '.b')
title(['Novos casos vs isolamento social em ', city])

subplot(222)
scatter(new_cases_gaussian_7_notch(27:n_days, 1), isolation_gaussian_7_notch(27:n_days, 1), '.b')
title(['Novos casos vs isolamento social em ', city])

subplot(223)
scatter(new_cases_gaussian_7_notch(8:n_days, 1), isolation_gaussian_7_notch(1:n_days-7, 1), '.r')
title(['Novos casos vs isolamento social na semana anterior em ', city])

subplot(224)
scatter(new_cases_gaussian_7_notch(1:n_days-7, 1), isolation_gaussian_7_notch(8:n_days, 1), '.g')
title(['Novos casos vs isolamento social na semana posterior em ', city])

% if save
% saveas(gcf, '../images/sao_paulo_dados_filtrados.png')
% end

%% Figura 10

new_cases_diff = new_cases_gaussian_7_notch(2:n_days,1) - new_cases_gaussian_7_notch(1:n_days - 1,1);

figure(10)
subplot(221)
scatter(new_cases_diff, isolation_gaussian_7_notch(1:n_days-1), '.b')
title(['Varia��o de novos casos vs isolamento social em ', city])

subplot(222)
scatter(new_cases_diff(27:n_days-1, 1), isolation_gaussian_7_notch(27:n_days-1, 1), '.b')
title(['Varia��o de novos casos vs isolamento social em ', city])

subplot(223)
scatter(new_cases_diff(8:n_days-1, 1), isolation_gaussian_7_notch(1:n_days-8, 1), '.r')
title(['Varia��o de novos casos vs isolamento social na semana anterior em ', city])

subplot(224)
scatter(new_cases_diff(1:n_days-7, 1), isolation_gaussian_7_notch(8:n_days, 1), '.g')
title(['Varia��o de novos casos vs isolamento social na semana posterior em ', city])

% if save
% saveas(gcf, '../images/sao_paulo_dados_filtrados.png')
% end

%% Figure 11
cases = zeros(n_days,1);
cases(1, 1) = new_cases_gaussian_7_notch(1,1);
for i=2:n_days
    cases(i, 1) = cases(i-1, 1) + new_cases_gaussian_7_notch(i,1);
end

figure(11)
subplot(221)
scatter(cases, isolation_gaussian_7_notch, '.b')
title(['Casos vs isolamento social em ', city])

subplot(222)
scatter(cases(27:n_days, 1), isolation_gaussian_7_notch(27:n_days, 1), '.b')
title(['Casos vs isolamento social em ', city])

subplot(223)
scatter(cases(8:n_days, 1), isolation_gaussian_7_notch(1:n_days-7, 1), '.r')
title(['Casos vs isolamento social na semana anterior em ', city])

subplot(224)
scatter(cases(1:n_days-7, 1), isolation_gaussian_7_notch(8:n_days, 1), '.g')
title(['Casos vs isolamento social na semana posterior em ', city])

% if save
% saveas(gcf, '../images/sao_paulo_dados_filtrados.png')
% end


%% Correlograma

if correlation_final_delay < correlation_init_delay
    exit(-1)
else
    
    corr_new_cases_isolation_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);
    corr_diff_new_cases_isolation_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);
    corr_cases_isolation_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);

    corr_new_cases_isolation_p_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);
    corr_diff_new_cases_isolation_p_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);
    corr_cases_isolation_p_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);

    corr_new_cases_isolation_upper_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);
    corr_diff_new_cases_isolation_upper_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);
    corr_cases_isolation_upper_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);

    corr_new_cases_isolation_lower_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);
    corr_diff_new_cases_isolation_lower_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);
    corr_cases_isolation_lower_tensor = zeros(correlation_final_delay - correlation_init_delay + 1,2,2);


    correlation_new_cases_by_delay = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    correlation_diff_new_cases_by_delay = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    correlation_cases_by_delay = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    
    correlation_new_cases_by_delay_p = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    correlation_diff_new_cases_by_delay_p = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    correlation_cases_by_delay_p = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    
    correlation_new_cases_by_delay_upper = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    correlation_diff_new_cases_by_delay_upper = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    correlation_cases_by_delay_upper = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    
    correlation_new_cases_by_delay_lower = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    correlation_diff_new_cases_by_delay_lower = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    correlation_cases_by_delay_lower = zeros(1, correlation_final_delay - correlation_init_delay + 1);
    
    for delay_days = correlation_init_delay:correlation_final_delay
        if delay_days >= 0
            [corr_new_cases_isolation_tensor(delay_days - correlation_init_delay + 1,1:2,1:2), ...
                corr_new_cases_isolation_p_tensor(delay_days - correlation_init_delay + 1,1:2,1:2), ...
                corr_new_cases_isolation_lower_tensor(delay_days - correlation_init_delay + 1,1:2,1:2), ...
                corr_new_cases_isolation_upper_tensor(delay_days - correlation_init_delay + 1,1:2,1:2)...
                ] = corrcoef(new_cases_per_pop_gaussian_7_notch(1+delay_days:n_days,1), isolation_gaussian_7_notch(1:n_days-delay_days, 1));
            
            [corr_diff_new_cases_isolation_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_diff_new_cases_isolation_p_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_diff_new_cases_isolation_lower_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_diff_new_cases_isolation_upper_tensor(delay_days - correlation_init_delay + 1,1:2,1:2)...
                ] = corrcoef(new_cases_diff(1+delay_days:n_days-1,1), isolation_gaussian_7_notch(1:n_days-delay_days-1, 1));
            
            [corr_cases_isolation_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_cases_isolation_p_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_cases_isolation_lower_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_cases_isolation_upper_tensor(delay_days - correlation_init_delay + 1,1:2,1:2)...
                ] = corrcoef(cases(1+delay_days:n_days-1,1), isolation_gaussian_7_notch(1:n_days-delay_days-1, 1));
        else
            [corr_new_cases_isolation_tensor(delay_days - correlation_init_delay + 1,1:2,1:2), ...
                corr_new_cases_isolation_p_tensor(delay_days - correlation_init_delay + 1,1:2,1:2), ...
                corr_new_cases_isolation_lower_tensor(delay_days - correlation_init_delay + 1,1:2,1:2), ...
                corr_new_cases_isolation_upper_tensor(delay_days - correlation_init_delay + 1,1:2,1:2), ...
                ] = corrcoef(new_cases_per_pop_gaussian_7_notch(1:n_days+delay_days,1), isolation_gaussian_7_notch(1-delay_days:n_days, 1));

            [corr_diff_new_cases_isolation_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_diff_new_cases_isolation_p_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_diff_new_cases_isolation_lower_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_diff_new_cases_isolation_upper_tensor(delay_days - correlation_init_delay + 1,1:2,1:2)...
                ] = corrcoef(new_cases_diff(1:n_days+delay_days-1,1), isolation_gaussian_7_notch(1-delay_days:n_days-1, 1));
            
            [corr_cases_isolation_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_cases_isolation_p_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_cases_isolation_lower_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                corr_cases_isolation_upper_tensor(delay_days - correlation_init_delay + 1,1:2,1:2),...
                ] = corrcoef(cases(1:n_days+delay_days-1,1), isolation_gaussian_7_notch(1-delay_days:n_days-1, 1));
        end
        correlation_new_cases_by_delay(1, delay_days - correlation_init_delay + 1) = corr_new_cases_isolation_tensor(delay_days - correlation_init_delay + 1,1,2);
        correlation_new_cases_by_delay_p(1, delay_days - correlation_init_delay + 1) = corr_new_cases_isolation_p_tensor(delay_days - correlation_init_delay + 1,1,2);
        correlation_new_cases_by_delay_lower(1, delay_days - correlation_init_delay + 1) = corr_new_cases_isolation_lower_tensor(delay_days - correlation_init_delay + 1,1,2);
        correlation_new_cases_by_delay_upper(1, delay_days - correlation_init_delay + 1) = corr_new_cases_isolation_upper_tensor(delay_days - correlation_init_delay + 1,1,2);
        
        correlation_diff_new_cases_by_delay(1, delay_days - correlation_init_delay + 1) = corr_diff_new_cases_isolation_tensor(delay_days - correlation_init_delay + 1,1,2);
        correlation_diff_new_cases_by_delay_p(1, delay_days - correlation_init_delay + 1) = corr_diff_new_cases_isolation_p_tensor(delay_days - correlation_init_delay + 1,1,2);
        correlation_diff_new_cases_by_delay_lower(1, delay_days - correlation_init_delay + 1) = corr_diff_new_cases_isolation_lower_tensor(delay_days - correlation_init_delay + 1,1,2);
        correlation_diff_new_cases_by_delay_upper(1, delay_days - correlation_init_delay + 1) = corr_diff_new_cases_isolation_upper_tensor(delay_days - correlation_init_delay + 1,1,2);

        correlation_cases_by_delay(1, delay_days - correlation_init_delay + 1) = corr_cases_isolation_tensor(delay_days - correlation_init_delay + 1,1,2);
        correlation_cases_by_delay_p(1, delay_days - correlation_init_delay + 1) = corr_cases_isolation_p_tensor(delay_days - correlation_init_delay + 1,1,2);
        correlation_cases_by_delay_lower(1, delay_days - correlation_init_delay + 1) = corr_cases_isolation_lower_tensor(delay_days - correlation_init_delay + 1,1,2);
        correlation_cases_by_delay_upper(1, delay_days - correlation_init_delay + 1) = corr_cases_isolation_upper_tensor(delay_days - correlation_init_delay + 1,1,2);
    end
    
    delay_days = correlation_init_delay:correlation_final_delay;
        
    %% Figure 12
    figure(12)
    fill([delay_days, fliplr(delay_days)], [correlation_new_cases_by_delay_lower, fliplr(correlation_new_cases_by_delay_upper)], ...
    bar_color_src, 'FaceAlpha', 0.5, 'EdgeColor', bar_color_src, 'LineStyle', '--')
    hold on
    plot(delay_days, correlation_new_cases_by_delay, 'Color', marker_color_src, 'LineStyle', '-');
    hold on
    plot([0, 0], [-1, 1], 'k--');
    hold on
    plot([correlation_init_delay, correlation_final_delay], [0, 0], 'k--');
    hold off
    title(['Correlograma por atraso entre o isolamento social e o n�mero de casos di�rios em ', city])
    xlabel('Diferen�a de dias entre o dia de coleta do isolamento social e o dia de coleta dos casos di�rios')
    ylabel('Correla��o entre novos casos di�rios e �ndice de isolamento social')
    legend('intervalo com 95% confian�a', 'correla��o')
    ylim([-1, 1])
    xlim([correlation_init_delay, correlation_final_delay])
    
    if save
        saveas(gcf, '../images/sao_paulo_correlograma_novos_casos.png')
    end
    
    %% Figure 13
    figure(13)
    fill([delay_days, fliplr(delay_days)], [correlation_diff_new_cases_by_delay_lower, fliplr(correlation_diff_new_cases_by_delay_upper)], ...
    bar_color_src, 'FaceAlpha', 0.5, 'EdgeColor', bar_color_src, 'LineStyle', '--')
    hold on
    plot(delay_days, correlation_diff_new_cases_by_delay, 'Color', marker_color_src, 'LineStyle', '-');
    hold on
    plot([0, 0], [-1, 1], 'k--');
    hold on
    plot([correlation_init_delay, correlation_final_delay], [0, 0], 'k--');
    hold off
    title(['Correlograma por atraso entre o isolamento social e a varia��o di�ria do n�mero de casos di�rios em ', city])
    xlabel('Diferen�a de dias entre o dia de coleta do isolamento social e o dia de coleta da varia��o di�ria dos casos di�rios')
    ylabel('Correla��o entre a varia��o di�ria de novos casos di�rios e �ndice de isolamento social')
    legend('intervalo com 95% confian�a', 'correla��o')
    ylim([-1, 1])
    xlim([correlation_init_delay, correlation_final_delay])
        
    if save
        saveas(gcf, '../images/sao_paulo_correlograma_variacao_novos_casos.png')
    end
    
    %% Figure 14
    figure(14)
    fill([delay_days, fliplr(delay_days)], [correlation_cases_by_delay_lower, fliplr(correlation_cases_by_delay_upper)], ...
    bar_color_src, 'FaceAlpha', 0.5, 'EdgeColor', bar_color_src, 'LineStyle', '--')
    hold on
    plot(delay_days, correlation_cases_by_delay, 'Color', marker_color_src, 'LineStyle', '-');
    hold on
    plot([0, 0], [-1, 1], 'k--');
    hold on
    plot([correlation_init_delay, correlation_final_delay], [0, 0], 'k--');
    hold off
    title(['Correlograma por atraso entre o isolamento social e o n�mero de casos acumulados em ', city])
    xlabel('Diferen�a de dias entre o dia de coleta do isolamento social e o dia de coleta dos casos acumulados')
    ylabel('Correla��o entre os casos acumulados e �ndice de isolamento social')
    legend('intervalo com 95% confian�a', 'correla��o')
    ylim([-1, 1])
    xlim([correlation_init_delay, correlation_final_delay])
    
    if save
        saveas(gcf, '../images/sao_paulo_correlograma_casos_acumulados.png')
    end
    
end

corr_new_cases_isolation = corrcoef(new_cases_per_pop_gaussian_7_notch, isolation_gaussian_7_notch);
corr_new_cases_isolation_before = corrcoef(new_cases_per_pop_gaussian_7_notch(8:n_days,1), isolation_gaussian_7_notch(1:n_days-7, 1));
corr_new_cases_isolation_after = corrcoef(new_cases_per_pop_gaussian_7_notch(1:n_days-7,1), isolation_gaussian_7_notch(8:n_days, 1));

corr_new_cases_isolation = corr_new_cases_isolation(1,2);
corr_new_cases_isolation_before = corr_new_cases_isolation_before(1,2);
corr_new_cases_isolation_after = corr_new_cases_isolation_after(1,2);

disp(['Correla��o linear entre o n�mero de casos di�rios e o �ndice de isolamento social: ', num2str(corr_new_cases_isolation)])
disp(['Correla��o linear entre o n�mero de casos di�rios e o �ndice de isolamento social uma semana antes: ', num2str(corr_new_cases_isolation_before)])
disp(['Correla��o linear entre o n�mero de casos di�rios e o �ndice de isolamento social uma semana depois: ', num2str(corr_new_cases_isolation_after)])

