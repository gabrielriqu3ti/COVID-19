function y = conv_moving_avg_filter(x, filter_size)
%conv_moving_avg_filter - Aplica um filtro de média móvel não-causal sobre 
% um vetor linha. Esta função adapta o tamanho do filtro para os valores 
% próximos a ponta.
% 
% Entradas:
%       x           : vetor n x 1 contendo um sinal amostrado
%       filter_size : número ímpar positivo
% 
% Saídas:
%       y           : vetor n x 1 contendo um sinal filtrado

    [signal_size, ~] = size(x);
    if mod(signal_size, 2) == 1
        filter_id_0 = (signal_size + 1) / 2;

        % Criação de filtro
        moving_avg_filter = zeros(signal_size, 1);
        moving_avg_filter(filter_id_0 - ((filter_size - 1) / 2):filter_id_0 + ((filter_size - 1) / 2), 1) = 1 / filter_size;

        y = conv(x, moving_avg_filter, 'same');

        % Adapta o tamanho do filtro da convolução para os valores da ponta
        for i = 1:round((filter_size - 1) / 2)
            y(i,1) = mean(x(1:2*i - 1,1));
        end
        for i = signal_size - round((filter_size - 1) / 2) + 1:signal_size
            y(i,1) = mean(x(2*i - signal_size:signal_size,1));
        end
    else
        % Criação de sinal ímpar
        x_odd = zeros(size(signal_size + 1), 1);

        filter_id_0 = (signal_size + 2) / 2;

        % Criação de filtro
        moving_avg_filter = zeros(signal_size + 1, 1);
        moving_avg_filter(filter_id_0 - ((filter_size - 1) / 2):filter_id_0 + ((filter_size - 1) / 2), 1) = 1 / filter_size;

        y_odd = conv(x_odd, moving_avg_filter, 'same');

        % Adapta o tamanho do filtro da convolução para os valores da ponta
        for i = 1:round((filter_size - 1) / 2)
            y_odd(i,1) = mean(x(1:2*i - 1,1));
        end
        for i = signal_size - round((filter_size - 1) / 2) + 1:signal_size
            y_odd(i,1) = mean(x(2*i - signal_size:signal_size,1));
        end
    
        y = y_odd(1:signal_size, 1);
    end
    
end
