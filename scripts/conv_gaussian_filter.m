function y = conv_gaussian_filter(x, std_dev_2_plus_1)
%conv_gaussian - Aplica um filtro de gaussiano n�o-causal sobre 
% um vetor linha. Esta fun��o adapta o tamanho do filtro para os valores 
% pr�ximos a ponta.
% 
% Entradas:
%       x                : vetor n x 1 contendo um sinal amostrado
%       std_dev_2_plus_1 : n�mero �mpar positivo
%                          Duas vezes o desvio-padr�o da distribui��o 
%                          gaussiana mais um
% 
% Sa�das:
%       y                : vetor n x 1 contendo um sinal filtrado

    gauss = @(x, mu, sigma) exp(-((x - mu)./sigma).^2./2);

    [signal_size, ~] = size(x);
    if mod(signal_size, 2) == 1
        filter_id_0 = (signal_size + 1) / 2;

        % Cria��o de filtro
        n = 1:signal_size;
        gaussian_filter = gauss(n, filter_id_0, (std_dev_2_plus_1 - 1) / 2);
        gaussian_filter = gaussian_filter ./ sum(gaussian_filter);
        
        y = conv(x, gaussian_filter, 'same');

        % Adapta o tamanho do filtro da convolu��o para os valores da ponta
        for i = 1:round((std_dev_2_plus_1 - 1) / 2)
            y(i,1) = mean(x(1:2*i - 1,1));
        end
        for i = signal_size - round((std_dev_2_plus_1 - 1) / 2) + 1:signal_size
            y(i,1) = mean(x(2*i - signal_size:signal_size,1));
        end
    else
        % Cria��o de sinal �mpar
        x_odd = zeros(size(signal_size + 1), 1);

        filter_id_0 = (signal_size + 2) / 2;

        % Cria��o de filtro
        n = 1:signal_size + 1;
        gaussian_filter = gauss(n, filter_id_0, (std_dev_2_plus_1 - 1) / 2);
        gaussian_filter = gaussian_filter ./ sum(gaussian_filter);

        y_odd = conv(x_odd, gaussian_filter, 'same');

        % Adapta o tamanho do filtro da convolu��o para os valores da ponta
        for i = 1:round((std_dev_2_plus_1 - 1) / 2)
            y_odd(i,1) = mean(x(1:2*i - 1,1));
        end
        for i = signal_size - round((std_dev_2_plus_1 - 1) / 2) + 1:signal_size
            y_odd(i,1) = mean(x(2*i - signal_size:signal_size,1));
        end
    
        y = y_odd(1:signal_size, 1);
    end
    
end
