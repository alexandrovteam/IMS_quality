function Isc = mocFilt( I, kernelSize )
% Calculate coefficient of varation 
% can either calculate on a moving window or the whole image
if isempty(kernelSize) % whole image
    Isc = calcMoC(I);
else % moving window
    I_padded = padarray(I,floor(kernelSize/2),nan);
    Isc = zeros(size(I));
    for ii=1:size(Isc,1)
        for jj=1:size(Isc,2)
            Isc(ii,jj) = calcMoC(I_padded(ii:ii+kernelSize(1),jj:jj+kernelSize(2)));
        end
    end
end