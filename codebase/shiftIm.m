function ImCube = shiftIm( I, kernelSize )
%Constructs an datacube where the layers consist of the input image but
%   shifted along dimension 1 & 2. The resulting ImCube will thus have the 
%   pixels inside the filter kernel along the dimension 3.
%   

m = kernelSize(1);
n = kernelSize(2);
if any( [mod(m,2)==0 mod(n,2)==0] )
    error('kernelSize must have an odd number of rows and columns')
end

xShift = floor(n/2);
yShift = floor(m/2);
xSize = size(I,2);
ySize = size(I,1);

ImCube = zeros(ySize, xSize, m*n);

k = 1;
for r = -yShift:1:yShift
    for c = -xShift:1:xShift
        ImCube(:,:,k) = circshift(I,[r c]);
        k = k+1;
    end
end

%ImCube = ImCube(1+yShift:end-yShift, 1+xShift:end-xShift, :);

end

