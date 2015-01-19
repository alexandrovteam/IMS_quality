function [x_keep_lin, fval_keep_lin,test_corr,pval,exit_keep_lin] = createGroupAlgorithmMeasure(ComparisonTable, x0)
if sum(isinf(ComparisonTable(:)))>0 ||sum(isnan(ComparisonTable(:)))>0 
    error('Input contains inf or NaN')
end

nRuns = 100;
n_perRun = 10;
fval_keep_lin = inf;
options.MaxFunEvals = 250*(size(ComparisonTable,2)-3);
options.Display='off';
optisation_type = 'corr';
corr_type = 'pearson';
compareFraction = 0.1;

for n=1:nRuns
% take some portion for training - reserve rest for training
sample_vector = true(size(ComparisonTable,1),1);
sample_vector(randsample(length(sample_vector),ceil(0.2*length(sample_vector)))) = false;

% Training values
slider_values = ComparisonTable(sample_vector,3);
algorithm_table = ComparisonTable(sample_vector,4:end);
for nn=1:n_perRun
%     x0 = floor(5*randn(1,size(algorithm_table,2)+1));
if nargin ==1
    x0 =  0.1*randn(1,size(algorithm_table,2)+1);
end
x0 = x0./sum(x0);
    switch optisation_type
        case 'corr'
            [x,fval,exit_val] = fminsearch(@(x) -1*corr(slider_values,linearAlgorithmCombination(algorithm_table,x),'type',corr_type),x0,options); %6 algorithms plus constant
        case 'rankFunction'
            [x,fval,exit_val] = fminsearch(...
                @(x) 1-rankFraction(abs(slider_values),abs(linearAlgorithmCombination(algorithm_table,x)),compareFraction) ...
                ,x0,options);
    end

%     if fval < fval_keep_lin
    % keep track for averaging
        fval_keep_lin(:,n,nn) = -1*fval;
        x_keep_lin(:,n,nn) = x;
        exit_keep_lin(:,n,nn) = exit_val;
        keep_sample_vector(:,n,nn) = sample_vector;
%     end
% calculate on testing set
    test_values = ComparisonTable(~sample_vector,3);
    test_algorithm_table = ComparisonTable(~sample_vector,4:end);
    switch optisation_type
        case 'corr'%
            [test_corr(n,nn), pval(n,nn)]= corr(test_values,linearAlgorithmCombination(test_algorithm_table,x));
        
        case 'rankFunction'
             [test_corr(n,nn), pval(n,nn)] = rankFraction(abs(test_values),abs(linearAlgorithmCombination(test_algorithm_table,x)),compareFraction);
        
    end
end
end



% best so far:
% x =  0.350.0174   -0.0064   -3.8980    5.3378   -0.0000    5.5998    1.881984   -0.2576   -9.7195   -0.9049   -0.0000   18.4355  -16.9516
% fval =  -0.6219

% Test on remaining entries



