function ResultsFromImcube = evaluateMethods(ImCube, mzVals, varargin)
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
% Check that tissue in ImCube has been separated by using NaN:s as background
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
% windowString = [num2str(window(1)) 'x' num2str(window(2))];
% 
% % CoV mean - standard deviation mean
% MethodName{1} = 'COVmean';
% bestValue{1} = 'Low';
% win{1} = windowString;
% 
% % CoV median - standard deviation median
% MethodName{2}= 'COVmedian';
% bestValue{2} = 'Low';
% win{2} = windowString;
% 
% % SNR mean - signal to noise ratio mean
% MethodName{3} = 'SNRmean';
% bestValue{3} = 'High';
% win{3} = windowString;
% 
% % SNR median - signal to noise ratio median
% MethodName{4} = 'SNRmedian';
% bestValue{4} = 'High';
% win{4} = windowString;
% 
% % MSE - mean square error
% MethodName{5} = 'SE';
% bestValue{5} = 'High';
% win{5} = '';
% 
% % Spatial Chaos
% MethodName{6} = 'SpatialChaos';
% bestValue{6} = 'Low';
% win{6} = '';
% 
% % STD mean - standard deviation mean
% MethodName{7} = 'STDmean';
% bestValue{7} = 'Low';
% win{7} = windowString;
% 
% % STD median - standard deviation median
% MethodName{8}= 'STDmedian';
% bestValue{8} = 'Low';
% win{8} = windowString;

% % Total Ion Count
% MethodName{7} = 'Mean Intensity';
% bestValue{7} = 'High';
% win{7} = '';

%% Method list
n_bins=20; % bins for histogram measures
featureDetection = {
  % Function  | window                           | evaluation
    @localCOV ,{[3,3] [5,5], [11,11], [21 21], [51,51],[]},{@mean, @median, @mad, @max, @min, @sum};
    @localSNR ,{[3,3] [5,5], [11,11], [21 21], [51,51],[]},{@mean, @median, @mad, @max, @min, @sum};
    @localSE  ,{[3,3] [5,5], [11,11], [21 21], [51,51],[]},{@mean, @median, @mad, @max, @min, @sum};
    @localSC  ,{[]}                              ,{@sum}; %too slow to work on patches, just return whole image val
    @localSTD ,{[3,3] [5,5], [11,11], [21 21], [51,51],[]},{@mean, @median, @mad, @max, @min, @sum};
    @imhist     ,{n_bins}                                ,{@histmaxindex, @kurtosis,@skewness, @hentropy}
    };
featureDetectionRGB = {
    @localLum ,{[]},{@mean, @median, @range, @max, @min, @sum};
    @histR    ,{n_bins}                                ,{@histmaxindex, @kurtosis,@skewness, @hentropy}
    @histG    ,{n_bins}                                ,{@histmaxindex, @kurtosis,@skewness, @hentropy}
    @histB    ,{n_bins}                                ,{@histmaxindex, @kurtosis,@skewness, @hentropy}
};
featureDetection_test = {
  % Function  | window    | evaluation
    @localCOV ,{[3,3] ,[]} ,{@mad};
    @localSNR ,{[3,3] ,[]} ,{@median};
    @localSE  ,{[3,3],[]}  ,{@range};
    @localSC  ,{[]}        ,{@max}; %too slow to work on patches, just return whole iimage val
    @localSTD ,{[3,3] ,[]} ,{@sum};
    @himhist     ,{n_bins}  ,{@histmaxindex}
    };
featureDetectionRGB_test = {
    @localLum ,{[]},{@mean};
    @histR    ,{n_bins}  ,{@kurtosis}
    @histG    ,{n_bins}  ,{@skewness}
    @histB    ,{n_bins}  ,{@hentropy}
};
% featureDetection = featureDetection_test;
% featureDetection = [];
% featureDetectionRGB=featureDetectionRGB_test;
%% Calculate

Nmethods = 0;
for f=1:size(featureDetection,1)
    func = featureDetection{f,1};% measure to apply to images
    func_str = func2str(func); 
    window_list = featureDetection{f,2}; % windows to use 
    eval_list = featureDetection{f,3}; % type of evaluation to return
    for w=1:size(window_list,2)
        window = window_list{w};
        window_str = num2str(window);
        for e=1:size(eval_list,2)
            % explicitly list which functions are used this iteration
            Nmethods=Nmethods+1;
            eval_type = eval_list{e};
            eval_str = func2str(eval_type); 
            MethodName{Nmethods}= [func_str '_' window_str '_' eval_str];
            % Update summary variables
            bestValue{Nmethods} = 'High'; % dummy as sign should be assigned during optimisation
            win{Nmethods} = window_str;
            % Calculate measure for each image
            disp(MethodName{Nmethods})
            values{Nmethods} = zeros(Nmz,1);
            for mz = 1:Nmz
                im = ImCube(:,:,mz); %normalised image cube
                im(isnan(im)) = 0; % most methods break with background nans
                im=im/max(im(:));
                values{Nmethods}(mz) = func(im,eval_type,window); % all function take common input
            end
        end

    end
end
C=jet(254); % colormap for RGB
for f=1:size(featureDetectionRGB,1)
    func = featureDetectionRGB{f,1};% measure to apply to images
    func_str = func2str(func); 
    window_list = featureDetectionRGB{f,2}; % windows to use 
    eval_list = featureDetectionRGB{f,3}; % type of evaluation to return
    for w=1:size(window_list,2)
        window = window_list{w};
        window_str = num2str(window);
        for e=1:size(eval_list,2)
            Nmethods=Nmethods+1;
            eval_type = eval_list{e};
            eval_str = func2str(eval_type); 
            MethodName{Nmethods}= [func_str '_' window_str '_' eval_str];
            bestValue{Nmethods} = 'High'; % sign should be assigned during optimisation
            win{Nmethods} = window_str;
            values{Nmethods} = zeros(Nmz,1);
            disp(MethodName{Nmethods})
            for mz = 1:Nmz
                im = ImCube(:,:,mz); %normalised image cube
                im(isnan(im)) = 0;
                im =  double(ind2rgb(gray2ind(im,255),C)); %normalised image cube
                im = im./ max(im(:));
                values{Nmethods}(mz) = func(im,eval_type,window); % all function take common input
                if ~isfinite(values{Nmethods}(mz))
                    assignin('base','im',im)
                    figure, imshow(im)
                    return
                end
            end
        end

    end
end

% %% Calculate
% values1 = zeros(Nmz,1);
% values2 = zeros(Nmz,1);
% values3 = zeros(Nmz,1);
% values4 = zeros(Nmz,1);
% values5 = zeros(Nmz,1);
% values6 = zeros(Nmz,1);
% values7 = zeros(Nmz,1);
% values8 = zeros(Nmz,1);
% 
% for mz = 1:Nmz
%     im = ImCube(:,:,mz); %normalised image cube
%     values1(mz) = localCOV(im,@mean, window);
%     values3(mz) = localSNR(im ,@mean, window);
%     values5(mz) = localSE(im,@mean,window );
%     values6(mz) = localSC(im,@mean,window);
%      %     values7(mz) = imageMIC(ImCube(:,:,mz));
%     values7(mz) = localSTD(im, 'mean', window);
% 
%     % Print progress in command prompt unless disabled by user
%     if nargin == 3 || ~( sum(strcmpi('noDisp', varargin)) > 0 )
%         if mod(mz,round(Nmz/10)) == 0
%             disp(['Progress: ' num2str(round(100*mz/Nmz)) '%'])
%         elseif mz == Nmz
%             disp('Finished ')
%         end
%     end
%    
% end
% values = [values1 values2 values3 values4 values5 values6 values7 values8];

%% Create struct with results and information
for m = 1:Nmethods
    
    % Create array with rankings. ranks(1) will hold the index of the best
    % image and ranks(end) will hold the index of the worst image,
    % according to the respective methods.
    if strcmpi(bestValue{m}, 'High')
        [~, ranks] = sort(values{m},'descend');
    elseif strcmpi(bestValue{m}, 'Low')
        [~, ranks] = sort(values{m},'ascend');
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
    
    ResultsFromImcube.method(m).values = values{m};
    ResultsFromImcube.method(m).ranks = ranks;
    
end


end
