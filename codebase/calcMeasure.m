
% Function calcMeasure calculates the measure of chaos as the minimum measure 
% taking into account all quantile values in a vector of quantile vectors, e.g.
% {0.60,0.65,...,0.95}.
%  
% INPUT: 
%   N : The number of the first N images to be selected with lowest 
%		measure of chaos.
%		One should set this value always to the same size as the size 
%		of the data 'datas',
%			if num of images in 'datas' = 1 image, set N = 1;
%			if num of images in 'datas' = M image, set N = M;
%	datas : These are the edge criterion (!) images on which the measure of
%			chaos has to be calculated.
%   quantVector : Vector of quantile vectors that should be take into
%                 account for the calculation. 
%                 Note that the distance from each quantile value should be
%                 equidistant 0.05. Therefore sth. like 0.55:0.10:0.95 is
%                 not allowed.
%                 Example: quantVector = 0.60:0.05:0.95
%
% OUTPUT:
%   N_images : This is the only important output here and includes in ascendent
%			   order in each row the information about 
%					1.Column: The measure of chaos,
%					2.Column: the index in the assigned dataset 'datas',
%					3.Column: the selected quantile value between in 
%						 	  min(quantVector):max(quantVector)
%
% Andreas Bartels, Theodore Alexandrov, University of Bremen
% Version 1.2 (May 2013)
% bartels@math.uni-bremen.de


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [N_images,ind,saved_min,all_images_MoC] = calcMeasure(N,datas,quantVector)

datas(isnan(datas)) = 0;
numOfQuantiles = numel(quantVector);

all_images_MoC = zeros(numOfQuantiles,size(datas,3)); % Each row: Quantile value, 
                                       % Each column: Image in the data
                                                                            
countQuant = 1;
for quant = quantVector
    thresh_func = @(im) im > quantile(im(:),quant);
    for k = 1:size(datas,3)
        e_detector = thresh_func(datas(:,:,k));
        MoC = getMoC(e_detector); % Calculate MoC
        all_images_MoC(countQuant,k) = MoC;
    end
    countQuant = countQuant + 1;
end

saved_min = zeros(size(datas,3),3);
saved_min(:,2) = 1:size(datas,3);
% Now go through all columns and detect the minimum MoC
for k=1:size(datas,3)
    [val,idx] = min(all_images_MoC(:,k));
    q_val = min(quantVector)+(idx-1)*0.05;
    saved_min(k,1) = val;
    saved_min(k,3) = q_val;
end

% Finally sort with respect to MoC values and take only the N most minimum
N_images = zeros(N,3);
[~,ind] = sort(saved_min(:,1));
for k=1:N
    N_images(k,:) = saved_min(ind(k),:);
end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MoC = getMoC(pic)
% Function getMoC calculates the measure of chaos on one binary image. 
%  
% INPUT: 
%   pic : Binary image
%
% OUTPUT:
%   MoC : Measure of chaos, i.e. mean length of edges of the 1-NN graph
%
% Andreas Bartels, Theodore Alexandrov, University of Bremen
% Version 1.0 (August 2012)
% bartels@math.uni-bremen.de

% First go through the whole BINARY image 'pic' and write the coords
% of all ones in a matrix
[m,n]=size(pic);

kval = 1; % We are dealing with 1-NN graphs

% Count the number of ones and create matrix of vertices
numOfOnes = sum(sum(pic));
vt = zeros(numOfOnes,2);

% Go through the picture and notice the coordinates of each 1
% Go rowwise:
p=1; % Counting variable 
for k=1:m
    for j=1:n
        if pic(k,j) == 1
            vt(p,1) = j; vt(p,2) = m-k;
            p = p + 1;
        else
            continue;
        end
    end
end

% Now apply simple kNN-search using the Matlab routine
[~,distv] = knnsearch(vt,vt,'k',kval+1);

% Finally calculate the mean distance
MoC = mean(distv(:,kval+1));

end