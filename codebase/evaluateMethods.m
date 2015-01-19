function ResultsFromImcube = evaluateMethods(ImCube, mzVals, window, varargin)
%   Calculates the image descriptors for all images in ImCube.
%       - mzVals is the mz values for the images in ImCube.
%       - window is the window size that should be used for some of the image
%         descriptors.
%   Usage of variable input can be seen below: (variable input can be
%   combined)
%   ResultsFromImage = evaluateMethods(ImCube, mzVals, window)
%   ResultsFromImage = evaluateMethods(ImCube, mzVals, window, params)
%   ResultsFromImage = evaluateMethods(ImCube, mzVals, window, 'NoDisp')
%   ResultsFromImage = evaluateMethods(ImCube, imageLabels, window, 'labels')
%
%       - params is paramters for the Spatial Chaos method.

%% Check input
if size(ImCube,3) ~= length(mzVals)
    error('Input does not match: Number of images must equal the number of mz values')
end

if size(window,1) ~= 1 || size(window,2) ~= 2
    error('Input ''window'' must be a 1x2 array')
end

% Check that tissue in ImCube has been separated by using NaN:s as background
test = isnan( [ImCube(1,1,1) ImCube(end,1,1) ImCube(1,end,1) ImCube(end,end,1)] );

if ~any(reshape(isnan(ImCube(:,:,1)),[],1))
    disp(' ')
    warning('ImCube appears to be missing NaN separation of background!')
end

% Check if user defined paramters for the Spatial Chaos method should be
% used
tmpInd = cellfun(@isnumeric,varargin);
if nargin > 3 && sum(tmpInd) > 0
    params = varargin{tmpInd == 1};
    SCpar = length(params);
else
    SCpar = 0;
    params = [];
end

%% Initialise
Nmz = size(ImCube,3);
windowString = [num2str(window(1)) 'x' num2str(window(2))];

% CoV mean - standard deviation mean
MethodName{1} = 'COVmean';
bestValue{1} = 'Low';
win{1} = windowString;

% CoV median - standard deviation median
MethodName{2}= 'COVmedian';
bestValue{2} = 'Low';
win{2} = windowString;

% SNR mean - signal to noise ratio mean
MethodName{3} = 'SNRmean';
bestValue{3} = 'High';
win{3} = windowString;

% SNR median - signal to noise ratio median
MethodName{4} = 'SNRmedian';
bestValue{4} = 'High';
win{4} = windowString;

% MSE - mean square error
MethodName{5} = 'MSE';
bestValue{5} = 'High';
win{5} = '';

% Spatial Chaos
MethodName{6} = 'SpatialChaos';
bestValue{6} = 'Low';
win{6} = '';

% STD mean - standard deviation mean
MethodName{7} = 'STDmean';
bestValue{7} = 'Low';
win{7} = windowString;

% STD median - standard deviation median
MethodName{8}= 'STDmedian';
bestValue{8} = 'Low';
win{8} = windowString;

% % Total Ion Count
% MethodName{7} = 'Mean Intensity';
% bestValue{7} = 'High';
% win{7} = '';

Nmethods = length(MethodName);

%% Calculate
values1 = zeros(Nmz,1);
values2 = zeros(Nmz,1);
values3 = zeros(Nmz,1);
values4 = zeros(Nmz,1);
values5 = zeros(Nmz,1);
values6 = zeros(Nmz,1);
values7 = zeros(Nmz,1);
values8 = zeros(Nmz,1);

for mz = 1:Nmz
    im = ImCube(:,:,mz); %normalised image cube
    values1(mz) = localCOV(im, 'mean', window);
    values2(mz) = localCOV(im, 'median', window);
    values3(mz) = localSNR(im , 'mean', window);
    values4(mz) = localSNR(im , 'median', window);
    values5(mz) = noiseMSE(im );

    % Decide if default or user defined paramters should be used for
    % Spatial Chaos
    if SCpar == 4
        [values6(mz)] = calcMoC(im , 'omega',params(1), 'sigma_d',params(2), 'sigma_i',params(3), 'quantVec',params(4)*0.05:0.05:0.95 );
    elseif SCpar == 3
        [values6(mz)] = calcMoC(im , 'omega',params(1), 'sigma_d',params(2), 'sigma_i',params(3));
    else
        [values6(mz)] = calcMoC(im);
    end
     %     values7(mz) = imageMIC(ImCube(:,:,mz));
    values7(mz) = localSTD(im, 'mean', window);
    values8(mz) = localSTD(im, 'median', window);

    % Print progress in command prompt unless disabled by user
    if nargin == 3 || ~( sum(strcmpi('noDisp', varargin)) > 0 )
        if mod(mz,round(Nmz/10)) == 0
            disp(['Progress: ' num2str(round(100*mz/Nmz)) '%'])
        elseif mz == Nmz
            disp('Finished ')
        end
    end
   
end
values = [values1 values2 values3 values4 values5 values6 values7 values8];

%% Create struct with results and information
for m = 1:Nmethods
    
    % Create array with rankings. ranks(1) will hold the index of the best
    % image and ranks(end) will hold the index of the worst image,
    % according to the respective methods.
    if strcmpi(bestValue{m}, 'High')
        [~, ranks] = sort(values(:,m),'descend');
    elseif strcmpi(bestValue{m}, 'Low')
        [~, ranks] = sort(values(:,m),'ascend');
    end
    
    ResultsFromImcube.method(m).name = MethodName{m};
    ResultsFromImcube.method(m).window = win{m};
    ResultsFromImcube.method(m).bestValue = bestValue{m};
    
    % If specified in input, use user defined labels instead of mz-values
    if nargin > 3 && sum( strcmpi(varargin, 'labels') ) > 0
        ResultsFromImcube.method(m).labels = mzVals;
    else
        ResultsFromImcube.method(m).mz = mzVals;
    end
    
    ResultsFromImcube.method(m).values = values(:,m);
    ResultsFromImcube.method(m).ranks = ranks;
    
end


end
