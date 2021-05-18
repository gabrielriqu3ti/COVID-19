function y = conv_moving_avg_filter(x, filter_size)
%conv_moving_avg_filter - Aplica um filtro de m�dia m�vel sobre um vetor
% linha. Esta fun��o adapta o tamanho do filtro para os valores pr�ximos a
% ponta.
% 
% Entradas:
%       x           : vetor n x 1 contendo um sinal amostrado
%       filter_size : n�mero �mpar positivo
% 
% Sa�das:
%       y           : vetor n x 1 contendo um sinal filtrado

    [signal_size, ~] = size(x);
    filter_id_0 = ceil(signal_size / 2);

    % Cria��o de filtro
    filter = zeros(signal_size, 1);
    filter(filter_id_0 - ((filter_size - 1) / 2):filter_id_0 + ((filter_size - 1) / 2), 1) = 1 / filter_size;

    y = conv(x, filter, 'same');
    
    % Adapta o tamanho do filtro da convolu��o para os valores da ponta
    for i = 1:round((filter_size - 1) / 2)
        y(i,1) = mean(x(1:2*i - 1,1));
    end
    for i = signal_size - round((filter_size - 1) / 2) + 1:signal_size
        y(i,1) = mean(x(2*i - signal_size:signal_size,1));
    end
    
end
