function ImCube = normaliseScaleImCube(ImCube)
% ImCube = normaliseScaleImCube(ImCube)
% Applies a hard-coded scaling to the data
for n=1:size(ImCube,3)
   tmp = ImCube(:,:,n);
   tmp = tmp - min(tmp(:));
   tmp = tmp/ max(tmp(:));
   ImCube(:,:,n) = tmp;
    
end