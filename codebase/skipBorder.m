function Iskipped = skipBorder( I, kernelSize )
%Removes pixels along the border
%   Detailed explanation goes here

ySkip = floor(kernelSize(1)/2);
xSkip = floor(kernelSize(2)/2);

Iskipped = I((ySkip+1):(end-ySkip), (xSkip+1):(end-xSkip));
end

