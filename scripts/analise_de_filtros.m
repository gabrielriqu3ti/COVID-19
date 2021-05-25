%% PTC3456 - Processamento de Sinais Biomédicos
% Projeto 1

w = 0:0.0001:pi;
w0 = 2*pi/7;
Ts = 24 * 60 * 60; % período de amostragem em segundos (1 dia)

%% Filtro de Média Móvel Não-Causal
% h_m[n] =  (1/(2m + 1)) Soma de k=-m até m de DeltaDirac[n + k]
% Transformada z:
% H_m(z) = (1/(2m + 1)) Soma de k=-m até m de z^k
% Em potências negativas de z:
% H_m(z) = (1 + Soma de k=1 até 2m de z^(-k)) /((2m + 1)z^(-m))

%% Média Móvel de 3 dias
% h_3[n] =  (DeltaDirac[n + 1] + DeltaDirac[n] + DeltaDirac[n - 1]) / 3
% Transformada z:
% H_3(z) = (1 + z^(-1) + z^(-2))/(3 z^(-1))

num_moving_avg_3 = [1, 1, 1];
den_moving_avg_3 = [0, 3];

H_moving_avg_3 = filt(num_moving_avg_3, den_moving_avg_3, Ts)

figure(1)
freqz(num_moving_avg_3, den_moving_avg_3, w)
subplot(211)
hold on
plot([w0/pi, w0/pi], [0, -100], '--k')
hold off
legend('filtro', 'frequência semanal')
title('Diagrama de Bode de filtro de média móvel de 3 dias')
ylim([-100, 0])
subplot(212)
hold on
plot([w0/pi, w0/pi], [50, -200], '--k')
hold off
legend('filtro', 'frequência semanal')
ylim([-200, 50])

saveas(gcf, '../images/bode_media_movel_3.png')


%% Média Móvel de 5 dias
% h_5[n] =  (DeltaDirac[n + 2] + DeltaDirac[n + 1] + DeltaDirac[n] +
% DeltaDirac[n - 1] + DeltaDirac[n - 2]) / 5
% Transformada z:
% H_5(z) = (1 + z^(-1) + z^(-2) + z^(-3) + z^(-4))/(5 z^(-2))

num_moving_avg_5 = [1, 1, 1, 1, 1];
den_moving_avg_5 = [0, 0, 5];

H_moving_avg_5 = filt(num_moving_avg_5, den_moving_avg_5, Ts)

figure(2)
freqz(num_moving_avg_5, den_moving_avg_5, w)
subplot(211)
hold on
plot([w0/pi, w0/pi], [0, -100], '--k')
hold off
legend('filtro', 'frequência semanal')
title('Diagrama de Bode de filtro de média móvel de 5 dias')
ylim([-100, 0])
subplot(212)
hold on
plot([w0/pi, w0/pi], [-100, 400], '--k')
hold off
legend('filtro', 'frequência semanal')
ylim([-100, 400])

saveas(gcf, '../images/bode_media_movel_5.png')


%% Média Móvel de 7 dias
% h_7[n] =  (DeltaDirac[n + 3] + DeltaDirac[n + 2] + DeltaDirac[n + 1] + DeltaDirac[n] +
% DeltaDirac[n - 1] + DeltaDirac[n - 2] + DeltaDirac[n - 3]) / 7
% Transformada z:
% H_7(z) = (1 + z^(-1) + z^(-2) + z^(-3) + z^(-4) + z^(-5) + z^(-6))/(7 z^(-3))

num_moving_avg_7 = [1, 1, 1, 1, 1, 1, 1];
den_moving_avg_7 = [0, 0, 0, 7];

H_moving_avg_7 = filt(num_moving_avg_7, den_moving_avg_7, Ts)

figure(3)
freqz(num_moving_avg_7, den_moving_avg_7, w)
subplot(211)
hold on
plot([w0/pi, w0/pi], [0, -100], '--k')
hold off
legend('filtro', 'frequência semanal')
title('Diagrama de Bode de filtro de média móvel de 7 dias')
ylim([-100, 0])
subplot(212)
hold on
plot([w0/pi, w0/pi], [-50, 200], '--k')
hold off
legend('filtro', 'frequência semanal')
ylim([-50, 200])

saveas(gcf, '../images/bode_media_movel_7.png')


%% Filtro Gaussiano de desvio-padrão de 1 dia
% h_s[n] =  (Soma de k=-oo até oo de exp(-((n + k)/s)^2/2)) /
% (Soma de k=-oo até oo de exp(-(k/s)^2/2))
% Transformada z:
% H_s(z) = (Soma de k=-oo até oo de exp(-((n + k)/s)^2/2)) /
% (Soma de k=-oo até oo de exp(-(k/s)^2/2))

gauss = @(x, mu, sigma) exp(-((x - mu)./sigma).^2./2);

num_gaussian_3 = gauss(-38:38, 0, 1);
den_gaussian_3 = zeros(1, 39);
den_gaussian_3(1,39) = sum(num_gaussian_3);

H_gaussian_3 = filt(num_gaussian_3, den_gaussian_3, Ts)

figure(4)
freqz(num_gaussian_3, den_gaussian_3, w)
subplot(211)
hold on
plot([w0/pi, w0/pi], [0, -40], '--k')
hold off
legend('filtro', 'frequência semanal')
title('Diagrama de Bode de filtro Gaussiano de desvio-padrão de 1 dia')
subplot(212)
hold on
plot([w0/pi, w0/pi], [-10, 10], '--k')
hold off
legend('filtro', 'frequência semanal')

saveas(gcf, '../images/bode_gaussiano_3.png')


%% Filtro Gaussiano de desvio-padrão de 2 dias
% h_s[n] =  (Soma de k=-oo até oo de exp(-((n + k)/2)^2/2)) /
% (Soma de k=-oo até oo de exp(-(k/2)^2/2))
% Transformada z:
% H_s(z) = (Soma de k=-oo até oo de exp(-((n + k)/2)^2/2)) /
% (Soma de k=-oo até oo de exp(-(k/2)^2/2))

gauss = @(x, mu, sigma) exp(-((x - mu)./sigma).^2./2);

num_gaussian_5 = gauss(-77:77, 0, 2);
den_gaussian_5 = zeros(1, 78);
den_gaussian_5(1,78) = sum(num_gaussian_5);

H_gaussian_5 = filt(num_gaussian_5, den_gaussian_5, Ts)

figure(5)
freqz(num_gaussian_5, den_gaussian_5, w)
subplot(211)
hold on
plot([w0/pi, w0/pi], [0, -200], '--k')
hold off
legend('filtro', 'frequência semanal')
title('Diagrama de Bode de filtro Gaussiano de desvio-padrão de 2 dias')
subplot(212)
hold on
plot([w0/pi, w0/pi], [10, -10], '--k')
hold off
legend('filtro', 'frequência semanal')

saveas(gcf, '../images/bode_gaussiano_5.png')


%% Filtro Gaussiano de desvio-padrão de 3 dias
% h_s[n] =  (Soma de k=-oo até oo de exp(-((n + k)/s)^2/2)) /
% (Soma de k=-oo até oo de exp(-(k/s)^2/2))
% Transformada z:
% H_s(z) = (Soma de k=-oo até oo de exp(-((n + k)/s)^2/2)) /
% (Soma de k=-oo até oo de exp(-(k/s)^2/2))

gauss = @(x, mu, sigma) exp(-((x - mu)./sigma).^2./2);

num_gaussian_7 = gauss(-115:115, 0, 3);
den_gaussian_7 = zeros(1, 116);
den_gaussian_7(1,116) = sum(num_gaussian_3);

H_gaussian_7 = filt(num_gaussian_7, den_gaussian_7, Ts)

figure(6)
freqz(num_gaussian_7, den_gaussian_7, w)
subplot(211)
hold on
plot([w0/pi, w0/pi], [100, -400], '--k')
hold off
legend('filtro', 'frequência semanal')
title('Diagrama de Bode de filtro Gaussiano de desvio-padrão de 3 dias')
ylim([-400, 100])
subplot(212)
hold on
plot([w0/pi, w0/pi], [10, -10], '--k')
plot([0.6, 1], [0, 0], '-b')
hold off
legend('filtro', 'frequência semanal')

saveas(gcf, '../images/bode_gaussiano_7.png')


%% Filtro do Tipo Notch Não-Causal
% Transformada z:
% H_r(z) = C ((1 - z1 z^(-1) (1 - z2 z^(-1))) / (1 - p)
% 
% H_r(z) = C (1 - 2 cos(w0) z^(-1) + z^(-2)) / (1 - 2r cos(w0) z^(-1) + r^2 z^(-2))
% com C = (1 + r^2 - 2r cos(w0)) / (2 - 2 cos(w0))

%% Notch com r = 0.9

r = 0.9;

C = (1 - 2*r*cos(w0) + r^2) / (2 - 2*cos(w0));
num_notch = C * [1, -2*cos(w0), 1];
den_notch = [1, -2*r*cos(w0), r^2];

H_notch_r_0_9 = filt(num_notch, den_notch, Ts)

figure(7)
freqz(num_notch, den_notch, w)
subplot(211)
hold on
plot([w0/pi, w0/pi], [0, -100], '--k')
hold off
legend('filtro', 'frequência semanal')
title('Diagrama de Bode de filtro do tipo notch com r = 0.9')
subplot(212)
hold on
plot([w0/pi, w0/pi], [-100, 100], '--k')
hold off
legend('filtro', 'frequência semanal')

saveas(gcf, '../images/bode_notch_0_9.png')


%% Notch com r = 0.99

r = 0.99;

C = (1 - 2*r*cos(w0) + r^2) / (2 - 2*cos(w0));
num_notch = C * [1, -2*cos(w0), 1];
den_notch = [1, -2*r*cos(w0), r^2];

H_notch_r_0_99 = filt(num_notch, den_notch, Ts)

figure(8)
freqz(num_notch, den_notch, w)
subplot(211)
hold on
plot([w0/pi, w0/pi], [0, -100], '--k')
hold off
legend('filtro', 'frequência semanal')
title('Diagrama de Bode de filtro do tipo notch com r = 0.99')
subplot(212)
hold on
plot([w0/pi, w0/pi], [-100, 100], '--k')
hold off
legend('filtro', 'frequência semanal')

saveas(gcf, '../images/bode_notch_0_99.png')


%% Notch com r = 0.999

r = 0.999;

C = (1 - 2*r*cos(w0) + r^2) / (2 - 2*cos(w0));
num_notch = C * [1, -2*cos(w0), 1];
den_notch = [1, -2*r*cos(w0), r^2];

H_notch_r_0_999 = filt(num_notch, den_notch, Ts)

figure(9)
freqz(num_notch, den_notch, w)
subplot(211)
hold on
plot([w0/pi, w0/pi], [0, -100], '--k')
hold off
legend('filtro', 'frequência semanal')
title('Diagrama de Bode de filtro do tipo notch com r = 0.999')
subplot(212)
hold on
plot([w0/pi, w0/pi], [-100, 100], '--k')
hold off
legend('filtro', 'frequência semanal')

saveas(gcf, '../images/bode_notch_0_999.png')

