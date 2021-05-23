%% PTC3456 - Processamento de Sinais Biomédicos
% Projeto 1

%% Customização
r_c = 0.999;
r_i = 0.9;
per_pop = 100000;
city = 'Araraquara';

%% Fases

% início da quarentena: 2020-03-22 -> hoje (2021-05-15)
quarantene_begin = datetime('2020-03-22', 'InputFormat', 'yyyy-MM-dd');
quarantene_end = datetime('2021-05-16', 'InputFormat', 'yyyy-MM-dd');

set(groot, 'defaultAxesXGrid', 'on')
set(groot, 'defaultAxesYGrid', 'on')
set(groot, 'defaultAxesXMinorGrid', 'on', 'defaultAxesXMinorGridMode', 'manual')
set(groot, 'defaultAxesYMinorGrid', 'on', 'defaultAxesYMinorGridMode', 'manual')
set(groot, 'defaultLegendLocation', 'northwest')

%% Importação de dados
data_araraquara = readtable('../data/dados_araraquara.csv');

summary(data_araraquara);
[n_days, ~] = size(data_araraquara.data);
day_medium = ceil(n_days / 2);

disp(['Número de dados: ', num2str(n_days)])

pop_araraquara = data_araraquara.pop(1);

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
new_cases_moving_avg_3 = conv_moving_avg_filter(data_araraquara.casos_novos, 3);
new_cases_moving_avg_5 = conv_moving_avg_filter(data_araraquara.casos_novos, 5);
new_cases_moving_avg_7 = conv_moving_avg_filter(data_araraquara.casos_novos, 7);
new_cases_gaussian_3 = conv_gaussian_filter(data_araraquara.casos_novos, 3);
new_cases_gaussian_5 = conv_gaussian_filter(data_araraquara.casos_novos, 5);
new_cases_gaussian_7 = conv_gaussian_filter(data_araraquara.casos_novos, 7);

new_cases_notch = filter(b_c, a_c, data_araraquara.casos_novos);
new_cases_moving_avg_3_notch = conv_moving_avg_filter(new_cases_notch, 3);
new_cases_moving_avg_5_notch = conv_moving_avg_filter(new_cases_notch, 5);
new_cases_moving_avg_7_notch = conv_moving_avg_filter(new_cases_notch, 7);
new_cases_gaussian_3_notch = conv_gaussian_filter(new_cases_notch, 3);
new_cases_gaussian_5_notch = conv_gaussian_filter(new_cases_notch, 5);
new_cases_gaussian_7_notch = conv_gaussian_filter(new_cases_notch, 7);


new_cases_per_pop_moving_avg_3 = conv_moving_avg_filter(data_araraquara.casos_novos_por_pop, 3);
new_cases_per_pop_moving_avg_5 = conv_moving_avg_filter(data_araraquara.casos_novos_por_pop, 5);
new_cases_per_pop_moving_avg_7 = conv_moving_avg_filter(data_araraquara.casos_novos_por_pop, 7);
new_cases_per_pop_gaussian_3 = conv_gaussian_filter(data_araraquara.casos_novos_por_pop, 3);
new_cases_per_pop_gaussian_5 = conv_gaussian_filter(data_araraquara.casos_novos_por_pop, 5);
new_cases_per_pop_gaussian_7 = conv_gaussian_filter(data_araraquara.casos_novos_por_pop, 7);

new_cases_per_pop_notch = filter(b_c, a_c, data_araraquara.casos_novos_por_pop);
new_cases_per_pop_moving_avg_3_notch = conv_moving_avg_filter(new_cases_per_pop_notch, 3);
new_cases_per_pop_moving_avg_5_notch = conv_moving_avg_filter(new_cases_per_pop_notch, 5);
new_cases_per_pop_moving_avg_7_notch = conv_moving_avg_filter(new_cases_per_pop_notch, 7);
new_cases_per_pop_gaussian_3_notch = conv_gaussian_filter(new_cases_per_pop_notch, 3);
new_cases_per_pop_gaussian_5_notch = conv_gaussian_filter(new_cases_per_pop_notch, 5);
new_cases_per_pop_gaussian_7_notch = conv_gaussian_filter(new_cases_per_pop_notch, 7);


isolation_moving_avg_3 = conv_moving_avg_filter(data_araraquara.indice_isolamento, 3);
isolation_moving_avg_5 = conv_moving_avg_filter(data_araraquara.indice_isolamento, 5);
isolation_moving_avg_7 = conv_moving_avg_filter(data_araraquara.indice_isolamento, 7);
isolation_gaussian_3 = conv_gaussian_filter(data_araraquara.indice_isolamento, 3);
isolation_gaussian_5 = conv_gaussian_filter(data_araraquara.indice_isolamento, 5);
isolation_gaussian_7 = conv_gaussian_filter(data_araraquara.indice_isolamento, 7);

isolation_notch = filter(b_i, a_i, data_araraquara.indice_isolamento);
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

%% Visualização
figure(1)
set(gcf,'position',[0,0,1400,860])
subplot(421)
stem(data_araraquara.data, data_araraquara.casos_novos, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['Número de novos casos diários de COVID-19 em ', city])
legend('original')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(422)
stem(data_araraquara.data, new_cases_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r_c),' do número de novos casos diários de COVID-19 em ', city])
legend(['notch r=', num2str(r_c)])
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(423)
stem(data_araraquara.data, new_cases_moving_avg_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Média móvel 3 do número de novos casos diários de COVID-19 em ', city])
legend('média móvel 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(425)
stem(data_araraquara.data, new_cases_moving_avg_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Média móvel 5 do número de novos casos diários de COVID-19 em ', city])
legend('média móvel 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(427)
stem(data_araraquara.data, new_cases_moving_avg_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Média móvel 7 do número de novos casos diários de COVID-19 em ', city])
legend('média móvel 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(424)
stem(data_araraquara.data, new_cases_gaussian_3, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 do número de novos casos diários de COVID-19 em ', city])
legend('gaussian 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(426)
stem(data_araraquara.data, new_cases_gaussian_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 do número de novos casos diários de COVID-19 em ', city])
legend('gaussian 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(428)
stem(data_araraquara.data, new_cases_gaussian_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 do número de novos casos diários de COVID-19 em ', city])
legend('gaussian 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

saveas(gcf, '../images/araraquara_novos_casos_filtragem.png')

%% Figure 2
figure(2)
set(gcf,'position',[0,0,1500,860])
subplot(421)
stem(data_araraquara.data, data_araraquara.casos_novos, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['Número de novos casos diários de COVID-19 em ', city])
legend('original')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(423)
stem(data_araraquara.data, new_cases_moving_avg_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Média móvel 3 e notch com r=', num2str(r_c), ' do número de novos casos diários de COVID-19 em ', city])
legend('média móvel 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(425)
stem(data_araraquara.data, new_cases_moving_avg_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Média móvel 5 e notch com r=', num2str(r_c), ' do número de novos casos diários de COVID-19 em ', city])
legend('média móvel 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(427)
stem(data_araraquara.data, new_cases_moving_avg_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Média móvel 7 e notch com r=', num2str(r_c), ' do número de novos casos diários de COVID-19 em ', city])
legend('média móvel 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(422)
stem(data_araraquara.data, new_cases_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r_c),' do número de novos casos diários de COVID-19 em ', city])
legend(['notch r=', num2str(r_c)])
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(424)
stem(data_araraquara.data, new_cases_gaussian_3_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 e notch com r=', num2str(r_c), ' do número de novos casos diários de COVID-19 em ', city])
legend('gaussian 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(426)
stem(data_araraquara.data, new_cases_gaussian_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 e notch com r=', num2str(r_c), ' do número de novos casos diários de COVID-19 em ', city])
legend('gaussian 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(428)
stem(data_araraquara.data, new_cases_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 e notch com r=', num2str(r_c), ' do número de novos casos diários de COVID-19 em ', city])
legend('gaussian 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

saveas(gcf, '../images/araraquara_novos_casos_filtragem_notch.png')


%% Figure 3
figure(3)
set(gcf,'position',[0,0,1500,860])
subplot(421)
stem(data_araraquara.data, per_pop * data_araraquara.casos_novos_por_pop, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['Número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('original')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(422)
stem(data_araraquara.data, per_pop * new_cases_per_pop_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r_c),' do número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend(['notch r=', num2str(r_c)])
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(423)
stem(data_araraquara.data, per_pop * new_cases_per_pop_moving_avg_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Média móvel 3 do número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('média móvel 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(425)
stem(data_araraquara.data, per_pop * new_cases_per_pop_moving_avg_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Média móvel 5 do número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('média móvel 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(427)
stem(data_araraquara.data, per_pop * new_cases_per_pop_moving_avg_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Média móvel 7 do número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('média móvel 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(424)
stem(data_araraquara.data, per_pop * new_cases_per_pop_gaussian_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 do número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(426)
stem(data_araraquara.data, per_pop * new_cases_per_pop_gaussian_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 do número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(428)
stem(data_araraquara.data, per_pop * new_cases_per_pop_gaussian_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 do número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

saveas(gcf, '../images/araraquara_novos_casos_por_pop_filtragem.png')


%% Figure 4
figure(4)
set(gcf,'position',[0,0,1500,860])
subplot(421)
stem(data_araraquara.data, per_pop * data_araraquara.casos_novos_por_pop, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['Número de novos casos diários de COVID-19 por ', num2str(per_pop), ' habitantes em ', city])
legend('original')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(422)
stem(data_araraquara.data, per_pop * new_cases_per_pop_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r_c),' do número de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend(['notch r=', num2str(r_c)])
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(423)
stem(data_araraquara.data, per_pop * new_cases_per_pop_moving_avg_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Média móvel 3 e notch com r=', num2str(r_c), ' do número de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('média móvel 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(425)
stem(data_araraquara.data, per_pop * new_cases_per_pop_moving_avg_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Média móvel 5 e notch com r=', num2str(r_c), ' do número de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('média móvel 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(427)
stem(data_araraquara.data, per_pop * new_cases_per_pop_moving_avg_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Média móvel 7 e notch com r=', num2str(r_c), ' do número de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('média móvel 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(424)
stem(data_araraquara.data, per_pop * new_cases_per_pop_gaussian_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Gaussiana 3 e notch com r=', num2str(r_c), ' do número de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(426)
stem(data_araraquara.data, per_pop * new_cases_per_pop_gaussian_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Gaussiana 5 e notch com r=', num2str(r_c), ' do número de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(428)
stem(data_araraquara.data, per_pop * new_cases_per_pop_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Gaussiana 7 e notch com r=', num2str(r_c), ' do número de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('gaussian 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

saveas(gcf, '../images/araraquara_novos_casos_por_pop_filtragem_notch.png')


%% Figure 5
figure(5)
set(gcf,'position',[0,0,1500,860])
subplot(421)
stem(data_araraquara.data, data_araraquara.indice_isolamento, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['Índice de isolamento social médio diário em ', city])
legend('original')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(422)
stem(data_araraquara.data, isolation_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r_i),' do índice de isolamento social médio diário em ', city])
legend(['notch r=', num2str(r_i)])
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(423)
stem(data_araraquara.data, isolation_moving_avg_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Média móvel 3 do índice de isolamento social médio diário em ', city])
legend('média móvel 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(425)
stem(data_araraquara.data, isolation_moving_avg_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Média móvel 5 do índice de isolamento social médio diário em ', city])
legend('média móvel 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(427)
stem(data_araraquara.data, isolation_moving_avg_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Média móvel 7 do índice de isolamento social médio diário em ', city])
legend('média móvel 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(424)
stem(data_araraquara.data, isolation_gaussian_3, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 do índice de isolamento social médio diário em ', city])
legend('gaussian 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(426)
stem(data_araraquara.data, isolation_gaussian_5, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 do índice de isolamento social médio diário em ', city])
legend('gaussian 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(428)
stem(data_araraquara.data, isolation_gaussian_7, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 do índice de isolamento social médio diário em ', city])
legend('gaussian 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

saveas(gcf, '../images/araraquara_isolamento_filtragem.png')


%% Figure 6
figure(6)
set(gcf,'position',[0,0,1500,860])
subplot(421)
stem(data_araraquara.data, data_araraquara.indice_isolamento, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
title(['Índice de isolamento social médio diário em ', city])
legend('original')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(422)
stem(data_araraquara.data, isolation_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_notch, 'MarkerFaceColor', marker_color_notch, 'MarkerEdgeColor', marker_color_notch)
title(['Filtragem notch com r=', num2str(r_i),' do índice de isolamento social médio diário em ', city])
legend(['notch r=', num2str(r_i)])
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(423)
stem(data_araraquara.data, isolation_moving_avg_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Média móvel 3 e notch com r=', num2str(r_i), ' do índice de isolamento social médio diário em ', city])
legend('média móvel 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(425)
stem(data_araraquara.data, isolation_moving_avg_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Média móvel 5 e notch com r=', num2str(r_i), ' do índice de isolamento social médio diário em ', city])
legend('média móvel 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(427)
stem(data_araraquara.data, isolation_moving_avg_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Média móvel 7 e notch com r=', num2str(r_i), ' do índice de isolamento social médio diário em ', city])
legend('média móvel 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(424)
stem(data_araraquara.data, isolation_gaussian_3_notch, 'filled', 'MarkerSize', 3, ...
    'LineWidth', 0.1, 'Color', bar_color_3, 'MarkerFaceColor', marker_color_3, 'MarkerEdgeColor', marker_color_3)
title(['Filtragem gaussiana 3 e notch com r=', num2str(r_i), ' do índice de isolamento social médio diário em ', city])
legend('gaussian 3')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(426)
stem(data_araraquara.data, isolation_gaussian_5_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_5, 'MarkerFaceColor', marker_color_5, 'MarkerEdgeColor', marker_color_5)
title(['Filtragem gaussiana 5 e notch com r=', num2str(r_i), ' do índice de isolamento social médio diário em ', city])
legend('gaussian 5')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

subplot(428)
stem(data_araraquara.data, isolation_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_7, 'MarkerFaceColor', marker_color_7, 'MarkerEdgeColor', marker_color_7)
title(['Filtragem gaussiana 7 e notch com r=', num2str(r_i), ' do índice de isolamento social médio diário em ', city])
legend('gaussian 7')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

saveas(gcf, '../images/araraquara_isolamento_filtragem_notch.png')


%% Figura 7
figure(7)
set(gcf,'position',[0,0,860,860])

subplot(311)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 1.5*max(data_araraquara.casos_novos), 1.5*max(data_araraquara.casos_novos)], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_araraquara.data, data_araraquara.casos_novos, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['Número de novos casos diários de COVID-19 em ', city])
legend('quarentena', 'original')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(312)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 4*max(new_cases_per_pop_gaussian_7_notch*per_pop), 4*max(new_cases_per_pop_gaussian_7_notch*per_pop)], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_araraquara.data, per_pop * data_araraquara.casos_novos_por_pop, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['Número de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('quarentena', 'original')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(313)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 1, 1], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_araraquara.data, data_araraquara.indice_isolamento, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['Índice de isolamento social médio diário em ', city])
legend('quarentena', 'original')
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

saveas(gcf, '../images/araraquara_dados_originais.png')


%% Figura 8

figure(8)
set(gcf,'position',[0,0,860,860])
subplot(311)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 1.5*max(new_cases_gaussian_7_notch), 1.5*max(new_cases_gaussian_7_notch)], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_araraquara.data, new_cases_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['Número de novos casos diários de COVID-19 em ', city])
legend('quarentena', ['gaussian 7 notch r=', num2str(r_c)])
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(312)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 1.5*max(new_cases_per_pop_gaussian_7_notch*per_pop), 1.5*max(new_cases_per_pop_gaussian_7_notch*per_pop)], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_araraquara.data, per_pop * new_cases_per_pop_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['Gaussiana 7 e notch com r=', num2str(r_c), ' do número de novos casos por ', num2str(per_pop), ' habitantes em ', city])
legend('quarentena', ['gaussian 7 notch r=', num2str(r_c)])
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])

subplot(313)
fill([quarantene_begin, quarantene_end, quarantene_end, quarantene_begin], [0, 0, 5000, 5000], ...
    quarantene_color, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
hold on
stem(data_araraquara.data, isolation_gaussian_7_notch, 'filled', 'MarkerSize', 3,...
    'LineWidth', 0.1, 'Color', bar_color_src, 'MarkerFaceColor', marker_color_src, 'MarkerEdgeColor', marker_color_src)
hold off
title(['Índice de isolamento social médio diário em ', city])
legend('quarentena', ['gaussian 7 notch r=', num2str(r_i)])
xlim([data_araraquara.data(1), data_araraquara.data(n_days)])
ylim([0, 1])

saveas(gcf, '../images/araraquara_dados_filtrados.png')


%% Correlação Linear

corr_new_cases_isolation = corrcoef(new_cases_per_pop_gaussian_7_notch, isolation_gaussian_7_notch);
corr_new_cases_isolation_before = corrcoef(new_cases_per_pop_gaussian_7_notch(8:n_days,1), isolation_gaussian_7_notch(1:n_days-7, 1));
corr_new_cases_isolation_after = corrcoef(new_cases_per_pop_gaussian_7_notch(1:n_days-7,1), isolation_gaussian_7_notch(8:n_days, 1));

%corr_new_cases_isolation = corr_new_cases_isolation(1,2);
%corr_new_cases_isolation_before = corr_new_cases_isolation_before(1,2);
%corr_new_cases_isolation_after = corr_new_cases_isolation_after(1,2);

disp(['Correlação linear entre o número de casos diários e o índice de isolamento social: ', num2str(corr_new_cases_isolation(1,2))])
disp(['Correlação linear entre o número de casos diários e o índice de isolamento social uma semana antes: ', num2str(corr_new_cases_isolation_before(1,2))])
disp(['Correlação linear entre o número de casos diários e o índice de isolamento social uma semana depois: ', num2str(corr_new_cases_isolation_after(1,2))])

%% Teste t para avaliar se o coeficiente 

t_new_cases_isolation = corr_new_cases_isolation * sqrt(n_days - 1) ./ sqrt(1 - corr_new_cases_isolation^2);
t_new_cases_isolation_before = corr_new_cases_isolation_before * sqrt(n_days - 1 - 7) ./ sqrt(1 - corr_new_cases_isolation_before^2);
t_new_cases_isolation_after = corr_new_cases_isolation_after * sqrt(n_days - 1 - 7) ./ sqrt(1 - corr_new_cases_isolation_after^2);

% TODO: Realizar o teste t para ver se a hipótese H_0 de que o coeficiente
% de correlação é nulo pode ser rejeitada ou não.

