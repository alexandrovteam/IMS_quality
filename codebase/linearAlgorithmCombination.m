function calc_vector = linearAlgorithmCombination(algorithm_table,algorithm_paramsIn)
% tableIn - algorithm values for each pair
% paramsIn - constants, multipiers, end value additive

calc_vector = bsxfun(@mtimes,algorithm_table,algorithm_paramsIn(1:end-1));
calc_vector = sum(calc_vector,2) + algorithm_paramsIn(end);

% value_out = -1*corr(slider_values,calc_vector);%minus so minimised will work :)