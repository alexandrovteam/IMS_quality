function [ComparisonTable, correlation, pval] = createHumanAlgorithmComparisonTable( FullSurveyStruct, MethodResultsForSurveyIm, varargin )
%   Returns ComparisonTable, a matrix of size Nx(M+3), where N are the 
%   total number of pairs used in the survey and M is the number of image 
%   descriptors. Also returns the correlation between human judgement 
%   and image descriptors.
%
%   Uses:
%   [ComparisonTable, correlation] = createHumanAlgorithmComparisonTable(FullSurveyStruct, MethodResultsForSurveyIm)
%   [ComparisonTable, correlation] = createHumanAlgorithmComparisonTable(FullSurveyStruct, MethodResultsForSurveyIm, options.responsesPerPair)
%
%   Input:
%   -   FullSurveyStruct is a struct containing all survey responses for
%       the finished survey. This variable is created using the function 
%       createFullSurveyStruct().
%   -   MethodResultsForSurveyIm is a struct containing the calculated
%       image descriptors for all images in the survey. This variable is
%       created using the function calculateImageDescriptors().
%   -   options.responsesPerPair is the number of responses/pair in
%       FullSurveyStruct.
%       Default value is 3 (3DMassomics Survey)
%
%   Output:
%   For every row in ComparisonTable: 
%   The first 2 columns contains the indices into the image cube that for
%   that pair. The 3:rd column is the numerical value for the overall human
%   opinion for that pair. The rest of the columns is the numerical value 
%   representing the opinion of the different image decriptors. The order
%   of the image decriptors are the same as in input 
%   MethodResultsForSurveyIm.
%
%   correlation is a vector of length M with the correlation values 
%   between human judgement and the different image descriptors. They are 
%   in the same order as input MethodResultsForSurveyIm.

%% Input checks
nPairs = length(FullSurveyStruct.AllImPairs_plan);
% defaults
defaultOptions.responsesPerPair = 3;
defaultOptions.goldStandardPairs = true(nPairs,1);
defaultOptions.compareFraction = 0.2;
defaultOptions.compareType = 'spearman';
% get varargin
options=defaultOptions;
if ~isempty(varargin)
    input_fieldnames = fieldnames(varargin{1});
    default_fieldnames=fieldnames(defaultOptions);
    for n=1:length(input_fieldnames)
        if ~strcmp(input_fieldnames{n},default_fieldnames)
            error([input_fieldnames{n} ' not in ' default_fieldnames])
        end
        options.(input_fieldnames{n}) = varargin{1}.(input_fieldnames{n});
   end
end
% check varargins
if ~isnumeric(options.responsesPerPair) || ~islogical(options.goldStandardPairs)
    error('Input ''options.responsesPerPair'' must be numeric, Input ''options.goldStandardPairs'' must be logical.')
end

if max(FullSurveyStruct.AllImPairs_plan(:)) ~= length(MethodResultsForSurveyIm.method(1).values)
    error('Input does not match! Total number of images are not the same.')
end

%% Calculate
% NPairsTotal = size(FullSurveyStruct.AllImPairs_plan,1);
NPairsTotal = sum(options.goldStandardPairs);

NMethods = length(MethodResultsForSurveyIm.method);

% Initiate
ComparisonTable = nan(NPairsTotal, 3+NMethods);

% Get Image pairs and table for slider values
PairSliderValueTable = createPairSliderValueTable( FullSurveyStruct, options.responsesPerPair );
ComparisonTable(:,1:2) = PairSliderValueTable(options.goldStandardPairs,1:2);

% Merge slider values into a single value for every pair
sliderValues_merged = mergeSliderValuesForAllPairs( PairSliderValueTable(:,3:end));
ComparisonTable(:,3) = sliderValues_merged(options.goldStandardPairs);

% Loop through the different Image descriptors and merge their values into
% a singel value/pair. Then add it to the ComparisonTable
for m = 1:NMethods
    MethodValueTable = MethodResultsForSurveyIm.method(m).values(ComparisonTable(:,1:2));
    methodValues_merged = mergeMethodValuesForAllPairs( ...
        MethodValueTable, MethodResultsForSurveyIm.method(m).bestValue );

    ComparisonTable(:,3+m) = methodValues_merged;
end

% Calculate the correlation between the human opinion and the different
% image descriptors.
switch options.compareType
    case 'pearson'
        size(ComparisonTable)
        [correlation pval]=  corr(ComparisonTable(:,3), ComparisonTable(:,4:end));
    case 'spearman'
         [correlation pval] =  corr(ComparisonTable(:,3), ComparisonTable(:,4:end),'type','spearman');
    case 'kendall'
         [correlation pval] =  corr(ComparisonTable(:,3), ComparisonTable(:,4:end),'type','Kendall');
    case 'rms'
        for nn=4:size(ComparisonTable,2)
            [p,S] = polyfit(ComparisonTable(:,3),ComparisonTable(:,nn),1);
            correlation(nn-3)=S.normr;
            pval(nn-3) = sum((ComparisonTable(:,3)-ComparisonTable(:,nn)).^2);
        end
%          sq_err= bsxfun(@minus,ComparisonTable(:,4:end),ComparisonTable(:,3)).^2;
%          [correlation] =  sqrt(mean(sq_err));
%          pval = sqrt(std(sq_err));

    case 'rankFraction'
%         [~,user_sort_idx] = sort(abs(ComparisonTable(:,3)),'descend');
%         NPairsTest = floor(options.compareFraction*NPairsTotal);
%         for m = 1:NMethods
%             [~,alg_sort_idx] = sort(abs(ComparisonTable(:,3+m)),'descend');
%             correlation(m) = sum(ismember(user_sort_idx(1:NPairsTest),alg_sort_idx(1:NPairsTest)))/NPairsTest;
%         end
        correlation =  rankFraction(abs(ComparisonTable(:,3)),abs(ComparisonTable(:,4:end)),options.compareFraction);
	pval = nan;
    otherwise
        error('comparison not know')
end




end

