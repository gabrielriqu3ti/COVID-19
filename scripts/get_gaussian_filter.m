function h = get_gaussian_filter(filter_size, std_dev)
%get_gaussian_filter - Gera um filtro gaussiano n�o-causal representado por um 
% vetor linha. O desvio-padr�o � igual � metado do (tamanho do 
% filtro - 1) e o ganho vale 1.
% 
% Entradas:
%       filter_size      : n�mero �mpar positivo
%                          tamanho n do filtro n x 1
%       std_dev          : n�mero positivo
%                          desvio-padr�o do filtro
% 
% Sa�das:
%       h                : vetor n x 1 contendo filtro discretizado

    gauss = @(x, mu, sigma) exp(-((x - mu)./sigma).^2./2);
    
    if (mod(filter_size, 2) == 1) && (filter_size > 1)
        filter_size_minus_1_half = (abs(filter_size) - 1) / 2;
        n = -filter_size_minus_1_half:1:filter_size_minus_1_half;
        h = gauss(n, 0, std_dev);
        h = h ./ sum(h);
    else
        h = ones(1,1);
    end

end