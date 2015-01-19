%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function implements the calculation the measure of spatial chaos
% for imaging mass spectrometry data, as published in the paper
%       
%       T. Alexandrov, A. Bartels (2013)
%       "Testing for presence of known and unknown molecules in
%        imaging mass spectrometry"
%       Bioinformatics, accepted
% 
% The steps are as follows:
%     I. Denoising using bilateral filtering followed by edge-detection
%    II. Calculate the measure of spatial chaos
%   III. Plot the results (optional)
%
% INPUT: 
%        img - The input image should be full of NaNs around the tissue and 
%              should not (!) include any NaN within the data. Otherwise our
%              applied boundary skip via morphological erosion would delete 
%              the data.
%    verbose - In case one would like to print out calculation details and 
%              plot the results.
%
% EXAMPLES:
%   1) Please see 'example_brain.m' and 'example_kidney' for examples how the
%      measure for spatial chaos is being calculated for ONE IMAGE of the 
%      rat brain and kidney, respectively.
%   2) Please see 'example_testGroup' for the application of measuring the
%      measure of spatial chaos (MoC) for a group of test images with a
%      subsequent sorting of these w.r.t. the MoC.
%
% Andreas Bartels, Theodore Alexandrov, University of Bremen
% Version 1.3 (June 2013)
% bartels@math.uni-bremen.de, theodore@math.uni-bremen.de
%
%---------------------------------------------------------------------------
% 	The following applies to the code except for the implementation of 
%	the "bilateral_colfilter" function.
%
%   Copyright (2013) Theodore Alexandrov, Andreas Bartels
%
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%
%       http://www.apache.org/licenses/LICENSE-2.0
%
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [measure] = calcMoC(img,varargin)
%% 0. Set environment variables
% addpath('Tools')
%pathName = fileparts(mfilename('fullpath'));
%addpath([pathName filesep 'Tools'])

%% Parsing optional parameters
if (rem(length(varargin),2)==1)
    error('calcMoC: Optional parameters should always go by pairs');
else
    for i=1:2:(length(varargin)-1)
        switch varargin{i}
            case 'omega' % Parameter for bilateral filtering
                omega = varargin{i+1}; % Gaussian bilateral filter window
            case 'sigma_d' % Parameter for bilateral filtering
                sigma_d = varargin{i+1}; % Spatial-domain standard deviation
            case 'sigma_i' % Parameter for bilateral filtering
                sigma_i = varargin{i+1}; % Intensity-domain standard deviation
            case 'verbose' % Output option
                verbose = varargin{i+1};
            case 'quantVec' % Vector of quantile values with fixed stepsize 0.05
                quantVec = varargin{i+1};    
            case 'boundSkipFun' % Special function for skipping the boundary
                boundSkipFun = varargin{i+1}; % function handle
                if ~isa(varargin{i+1},'function_handle')
                   error('The boundSkip function needs to be a function handle');
                end 
            otherwise
                error(['calcMoC: Unrecognized option: ''' varargin{i} '''']);
        end;
    end;
end

if ~exist('verbose','var'), verbose = 0; end

if ~exist('quantVec','var') % Vector of quantile values to take into account
    quantVec = 0.60:0.05:0.95;
end

if ~exist('omega','var') % Parameter for bilateral filtering
    omega = 10; % Gaussian bilateral filter window
end

if ~exist('sigma_d','var') % Parameter for bilateral filtering
    sigma_d = 3; % Spatial-domain standard deviation
end

if ~exist('sigma_i','var') % Parameter for bilateral filtering
    sigma_i = 0.3; % Intensity-domain standard deviation
end


%% 1. Apply edge detection on the image with prior bilateral filtering
img_save = img;
img(isnan(img)) = 0; % Set all NaN's in the image as zeros
c = img./(max(max(img))); % Normalize to [0,1]
tic;
b = bilateral_colfilter(c, [omega omega], sigma_d, sigma_i); % bilateral filtering
BF_time = toc;
tic;
[ax,ay] = gradient(b);
edge_crit = sqrt(ax.^2+ay.^2);
ED_time = toc;

edge_crit(isnan(img_save)) = NaN;
if exist('boundSkipFun','var')
    edge_crit = boundSkipFun(edge_crit);
end
% if strcmpi(dataset,'brain')
%     edge_crit = boundSkip(edge_crit);
% elseif strcmpi(dataset,'kidney')
%     edge_crit = cutKidneyMask(edge_crit);
% end

%% 2. Now calculate the measure of chaos
ticID = tic;
[measRes,~,~,~] = calcMeasure(1,edge_crit,quantVec);
MoC_time = toc(ticID);
measure = measRes(1,1)-1;

if verbose
    disp(['Measure of chaos (MoC):' num2str(measure)]);
    disp('Needed');
    disp(['----------' num2str(BF_time+ED_time) 's for edge detection including bilateral filtering.']);
    disp(['----------' num2str(MoC_time) 's calculating the measure of chaos using the proposed method.']);
end

%% 3. Some plotting
if verbose
    % I. Plot original image
    subplot(2,2,1)
        % Hotspot removal
        q=quantile(img_save(:),0.99);
        img_save(img_save>q)=q;
        % Plotting
        h=imagesc(img_save);
        set(h,'alphadata',~isnan(img_save));
        axis image; axis off;
        title('Original image');
    
    % II. Plot the edge-criterion
    subplot(2,2,2)
        h=imagesc(edge_crit);
        set(h,'alphadata',~isnan(edge_crit));
        axis image; axis off;
        title('Edge criterion');
    
    % III. Plot the edge-detector
    subplot(2,2,3)
        % Fill edge detector with NaN where there are NaNs in the 
        % cutted original image
        used_quantile = measRes(1,3);
        thresh_func = @(im) im > quantile(im(:),used_quantile);
        e_detector = thresh_func(edge_crit);
        e_detector = double(e_detector); % Needed to convert values to NaNs (next step)
        e_detector(isnan(edge_crit)) = NaN;
        h=imagesc(e_detector); set(h,'alphadata',~isnan(e_detector));
        myColorMap = jet;
        myColorMap(1, :) = [0,0,0];
        myColorMap(end, :) = [255,165,0]./255; %orange
        colormap(myColorMap); axis image; axis off;
        title(['Edge detector, q = ' num2str(used_quantile)]);
    
    % IV. Plot the kNN-graph (k=1)
    subplot(2,2,4)
        e_detector(isnan(edge_crit)) = 0;
        getkNNgraph(e_detector);
        title(['1-NN graph: Measure = ' num2str(measure,'%.4f')]);
end



end

function getkNNgraph(e_detector)

[m,n]=size(e_detector);
numOfOnes = sum(sum(e_detector));
vt = zeros(numOfOnes,2);

% Go through the picture and notice the coordinates of each 1
% Go rowwise:
p=1; % Counting variable 
for k=1:m
    for j=1:n
        if e_detector(k,j) == 1
            vt(p,1) = j; vt(p,2) = m-k;
            p = p + 1;
        else
            continue;
        end
    end
end

[IDX,~] = knnsearch(vt,vt,'k',2);

hold off
for k=1:numOfOnes
    plot([vt(k,1) vt(IDX(k,2),1)],[vt(k,2) vt(IDX(k,2),2)],...
        'Color',[0 61 245]./255)
    hold on
end
hold off; axis image; axis off; 

end

function FA = bilateral_colfilter(A, size, std_c, std_s)
%BILATERALFILTER Filters a gray level image with a bilateral filter.
% FA = BILATERALFILTER(A, size, std_c, std_s) filters the
% gray level image A using a window of [size(1) size(2)] with a
% standard bilateral filter.
% Bilateral filtering smooths images while preserving edges in contrast.
% Therefor an adaptive filtering kernel for each image element in
% the convolution is created. The kernel is the product of a gaussian
% kernel (closeness function) and a gaussian weighted similarity function
% for pixel intensities. std_c and std_s are the standard derivations
% for closeness and similarity function.
%
% Reference
% ���
% This implemtation is based on the original paper �Bilateral Filtering
% for Gray and Color Images� published by C. Tomasi and R. Manduchi
% (Proceedings of the 1998 IEEE International Conference on Computer Vision).
%
% (c) Christopher Rohkohl
% christopher@oneder.de
% http://www.oneder.de
%
% Modified 2007-10-12
% Use colfilter instead of nlfilter for speed increase
% Tom Richardson
% http://www.mathworks.com/matlabcentral/newsreader/author/96032
% create gaussian closeness function
hs = (size-1)/2;
[x y] = meshgrid(-hs(2):hs(2),-hs(1):hs(1));
H_c = exp(-(x.*x + y.*y)/(2*std_c*std_c));
% perform filtering
FA = colfilt(A, size, 'sliding', @simfunc, std_s, H_c(:));
end
% adaptive similarity function
function V = simfunc(B, std, H_c);
% Find the row of B corresponding to the center pixel
center = floor((size(B,1)+1)/2);
% Make the similarity matrix
sim = exp(-(B - repmat(B(center,:), size(B,1), 1)).^2 / (2*std*std));
% Multiply the similarity matrix by the closeness matrix
sim = sim .* repmat(H_c, size(sim) ./ size(H_c));
ssum = sum(sim);
nonzerosum = ssum ~= 0;
sim(:, nonzerosum) = sim(:, nonzerosum) ./ repmat(ssum(nonzerosum), size(sim, 1), 1);
V = sum(sim .* B);
end