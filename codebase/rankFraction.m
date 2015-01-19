function percent = rankFraction(vector_in, matrix_in, compareFraction)

NPairsTotal = length(vector_in);
NPairsTest = floor(compareFraction*NPairsTotal);

[~,user_sort_idx] = sort(vector_in,'descend');
 [~,alg_sort_idx] = sort(matrix_in,'descend');
percent = 0.5*sum(ismember(alg_sort_idx(1:NPairsTest,:),user_sort_idx(1:NPairsTest)))/NPairsTest ...
    + 0.5*sum(ismember(alg_sort_idx(end-NPairsTest:end,:),user_sort_idx(end-NPairsTest:end)))/NPairsTest;

