function y = conv_gaussian_filter(x, two_std_dev_plus_one)
%conv_gaussian - Aplica um filtro de gaussiano não-causal sobre 
% um vetor linha. Esta função adapta o tamanho do filtro para os valores 
% próximos a ponta.
% 
% Entradas:
%       x                    : vetor contendo um sinal amostrado
%       two_std_dev_plus_one : número ímpar positivo
%                              Duas vezes o desvio-padrão da distribuição 
%                              gaussiana mais um
% 
% Saídas:
%       y                    : vetor contendo um sinal filtrado

    std_dev = (two_std_dev_plus_one - 1) / 2;

    filter_size = two_std_dev_plus_one + 0;
    filter_size_minus_1_half = (filter_size - 1) / 2;

    [signal_size, ~] = size(x);
    if mod(signal_size, 2) == 1
        filter_id_0 = (signal_size + 1) / 2;

        % Criação de filtro
        gaussian_filter = zeros(signal_size, 1);
        gaussian_filter(filter_id_0 - filter_size_minus_1_half:filter_id_0 + filter_size_minus_1_half, 1) = get_gaussian_filter(filter_size, std_dev);
%         gaussian_filter = gauss(n, filter_id_0, (filter_size - 1) / 2);
        gaussian_filter = gaussian_filter ./ sum(gaussian_filter);
        
        y = conv(x, gaussian_filter, 'same');

        % Adapta o tamanho do filtro da convolução para os valores da ponta
        for i = 1:round((filter_size - 1) / 2)
            y(i,1) = dot(x(1:2*i - 1,1), get_gaussian_filter(2*i-1, std_dev));
%             y(i,1) = mean(x(1:2*i - 1,1));
        end
        for i = signal_size - round((filter_size - 1) / 2) + 1:signal_size
            y(i,1) = dot(x(2*i - signal_size:signal_size,1), get_gaussian_filter(2*(signal_size - i) + 1, std_dev));
%             y(i,1) = mean(x(2*i - signal_size:signal_size,1));
        end
    else
        % Criação de sinal ímpar
        x_odd = zeros(size(signal_size + 1), 1);
        x_odd(1:signal_size, 1) = x;

        filter_id_0 = (signal_size + 2) / 2;

        % Criação de filtro
        gaussian_filter = zeros(signal_size + 1, 1);
        gaussian_filter(filter_id_0 - filter_size_minus_1_half:filter_id + filter_size_minus_1_half, 1) = get_gaussian_filter(filter_size, std_dev);
%         gaussian_filter = gauss(n, filter_id_0, (filter_size - 1) / 2);
        gaussian_filter = gaussian_filter ./ sum(gaussian_filter);

        y_odd = conv(x_odd, gaussian_filter, 'same');

        % Adapta o tamanho do filtro da convolução para os valores da ponta
        for i = 1:round((filter_size - 1) / 2)
            y_odd(i,1) = dot(x(1:2*i - 1,1), get_gaussian_filter(2*i-1, std_dev));
%             y_odd(i,1) = mean(x(1:2*i - 1,1));
        end
        for i = signal_size - round((filter_size - 1) / 2) + 1:signal_size
            y_odd(i,1) = dot(x(2*i - signal_size:signal_size,1), get_gaussian_filter(2*(signal_size - i) + 1, std_dev));
%             y_odd(i,1) = mean(x(2*i - signal_size:signal_size,1));
        end
    
        y = y_odd(1:signal_size, 1);
    end
    
end
