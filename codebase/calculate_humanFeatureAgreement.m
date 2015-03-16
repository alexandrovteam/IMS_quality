function [ComparisonTable,correlation,pval,tmp_struct]= calculate_humanFeatureAgreement(FullSurveyStruct,MethodResultsForSurveyIm,labels,varargin)
disp(' ')
disp('------------- Comparing human judgment Vs Image descriptors -------------')
disp(' ')
for n=1:2:length(varargin)
    options.(varargin{n})=varargin{n+1};
end
[ComparisonTable, correlation,pval] = createHumanAlgorithmComparisonTable( FullSurveyStruct, MethodResultsForSurveyIm,options);
sign_match = sum(bsxfun(@eq,sign(ComparisonTable(:,4:end)),sign(ComparisonTable(:,3))))/length(ComparisonTable);
% We didn't try and guess whether large or small values were better so
% negative predictions should be corrected
correlation = abs(correlation);
sign_match(sign_match<0.5) = 1-sign_match(sign_match<0.5) ;
for ll=4:length(labels)
    disp({labels{ll} correlation(ll-3) pval(ll-3) sign_match(ll-3)})
    tmp_struct(ll-3,:)={labels{ll} abs(correlation(ll-3)) pval(ll-3) sign_match(ll-3)};
end
