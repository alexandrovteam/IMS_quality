% Andrew Palmer
% 2015
% cript for reproducing the results from the survey paper 
%% Some global option
flag_save_im = 0; % saves images etc.
saveDir = 'gs_pairs';
%% Import Survey Responses
% First, load info on the image pairs used for the survey
load('../survey_images/ImagePairs_FullSurvey.mat')

% Load Survey Reponses
importDir ='../consistent_surveys';
%FullSurveyStruct = createFullSurveyStruct(importDir, SurveyPairList, ImPairs_rand); % note: scales slider values
load('../consistent_surveys/FullSurveyStruct.mat')
disp('Finished')
%% Optimise k_alpha
categoryThold = 0.1;% rounding precision, 1/multiple of 10
categoryFunction = @(x)(round(x/categoryThold)*categoryThold);
[ratings, timings, rawdata] = generateDataTables(FullSurveyStruct,categoryFunction);
[k_alpha, agreement_table_out] = calcualteKrippendorfAlpha(ratings);

% Remove one question at a time and re-check score
k_alpha_im = zeros(size(ratings,1),1);
for n=1:size(ratings,1)
    [k_alpha_im(n)] = calcualteKrippendorfAlpha(ratings(1:size(ratings,1)~=n,:));
end

% Show results
figure, 
subplot(1,2,1)
stem(100*(k_alpha_im-k_alpha)/k_alpha)
title('alpha_k with each pair removed')
xlabel('pair removed idx')
ylabel('percentage change to alpha_k')
set(gca,'XLim',[1 length(k_alpha_im)])
if flag_save_im
     saveas(gcf,'ka_alpha_eachPair_removed.png')
end
%% removing members -> increased k_alpha
% so want to exclude k_alpha_im with -nv k_alpha change
% [~,k_alpha_im_idx] = sort(k_alpha_im,'ascend');
q_vals = (1:10:length(k_alpha_im))/length(k_alpha_im);
ka_q = zeros(length(q_vals),1);
for n=1:length(q_vals) % plot at increasing cut-offs
   ka_q(n) = calcualteKrippendorfAlpha(ratings(k_alpha_im<quantile(k_alpha_im,q_vals(n)),:)); 
end
subplot(1,2,2),
plot(q_vals, ka_q)
set(gca,'YLim',[0 1])
title('alpha_k with images removed - removing poorly performing individuals (below quintile)')
xlabel('quintile')
ylabel('alpha_k')

% - choose quintile
flag_auto = 1;
if flag_auto
    [~,q_val_idx] = max(ka_q);
    q_val = q_vals(q_val_idx);
else
    q_val = input('Enter quintile  ', 's');
end
pairs_agreement = k_alpha_im<quantile(k_alpha_im,q_val);
disp(sum(pairs_agreement))

%% Plot time against slider std

tmp_timings=timings'; 
tmp_timings=reshape(tmp_timings(~isnan(tmp_timings)),3,[]); % time per pair (lose user information)
tmp_ratings=ratings'; 
tmp_ratings=reshape(tmp_ratings(~isnan(tmp_ratings)),3,[]); % time per pair (lose user information)

figure('color','w')
subplot(1,2,1)
plot(mean(tmp_timings), mean(tmp_ratings),'.')
x=1:100;
y=-3:0.1:3;
N = hist3([mean(tmp_timings);mean(tmp_ratings)]',[{x},{y}]);
hold all
contour(x,y,medfilt2(N',[5 5]),5,'LineWidth',3)% show smoothed density contours
colormap('Copper');
xlim([0 quantile(mean(tmp_timings),0.995)])
title('mean time vs mean  slider value','FontSize',18)
xlabel('time (s)','FontSize',18)
ylabel('mean slider value','FontSize',18)
set(gca,'FontSize',18)
subplot(1,2,2)
plot(mean(tmp_timings), std(tmp_ratings),'.')
N = hist3([mean(tmp_timings);std(tmp_ratings)]',[{x},{y}]);
hold all
contour(x,y,medfilt2(N',[5 5]),5,'LineWidth',3)% show smoothed density contours
set(gca,'FontSize',18)
title('mean time vs standard deviation of slider value','FontSize',18)
xlabel('time (s)','FontSize',18)
ylabel('standard deviation of slider value','FontSize',18)
xlim([0 quantile(mean(tmp_timings),0.995)])

if flag_save_im
     saveas(gcf','time_vs_slider.png')
end
%% Determine 'gold standard' image pairs
n_ratings_target = 3;
gs_consist_thresh = 0.25;
[pairRatingSummary, summaryHeaders] = summarisePairRatings(FullSurveyStruct,categoryThold);
n_ratings = checkNumberRatings(pairRatingSummary,find(~cellfun(@isempty,strfind(summaryHeaders,'slider value'))));

gs_def=@(x,y) x & y==n_ratings_target;
goldStandardPairs = gs_def(pairs_agreement,n_ratings);
disp('Gold Standard Calculated')
sum(goldStandardPairs)


%% Re-Load Suvey Image
load('../survey_images/ImCube50_rand_filledInsideNaN.mat') % image cube with machine_precision*rand added to avoid absolute zero intensities 
if flag_save_im
    for n=1:length(goldStandardPairs);
        if goldStandardPairs(n);
            subplot(1,2,1);
            imagesc(ImCube_rand_filled(:,:,pairRatingSummary(n,2)));
            title(['Pair index:' num2str(n) '. Average rater value: '  num2str(mean(pairRatingSummary(n,4:6)))])
            
            axis image; axis off
            subplot(1,2,2);
            imagesc(ImCube_rand_filled(:,:,pairRatingSummary(n,3)));
            axis image; axis off
            title( ['rater std ' num2str(pairRatingSummary(n,7))])
            saveas(gcf,[saveDir filesep 'pair_' num2str(n) '.png']);
        end
    end
end
%% Calculate Image Descriptor for images in Survey
disp(' ')
disp('---------------- Calculate Image Descriptors Survey ----------------')
disp(' ')
window=[5 5];
MethodResultsForSurveyIm = calculateImageDescriptors(ImCube_rand_filled, mz_rand, window );
disp('Finished')

%% Comparing human judgment Vs Image descriptors
disp(' ')
disp('------------- Comparing human judgment Vs Image descriptors -------------')
disp(' ')

[ComparisonTable, correlation] = createHumanAlgorithmComparisonTable( FullSurveyStruct, MethodResultsForSurveyIm,'goldStandardPairs',goldStandardPairs);
sign_match = sum(bsxfun(@eq,sign(ComparisonTable(:,4:end)),sign(ComparisonTable(:,3))))/length(ComparisonTable);
disp(correlation)
disp(sign_match)

disp('Finished')

% Create a group algorithm metric
%       [idx_1 idx_2 slider 'COVmean' 'COVmedian' 'SNRmean' 'SNRmedian' 'MSE' 'SpatialChaos' 'STDmean' 'STDmedian']
alg_idx = [1     1     1       0          1            0         1        1         1           0           1]; 
alg_idx = logical(alg_idx);
[x_keep_lin, fval_keep_lin,test_corr, p_val_test] = createGroupAlgorithmMeasure(ComparisonTable(:,alg_idx));
[~,idx] = max(fval_keep_lin); 

disp('Metrics included')
alg_idx=alg_idx(4:end); % just record algorithms used
disp(alg_idx)

disp('Median test correlation')
disp(median(test_corr(:)))
[v,max_fval_idx] = max(test_corr,[],2);

% take statistical average of high scoring coefficients and check it against data.
group_coeffs = mean(x_keep_lin(:,test_corr>max(correlation(alg_idx))),2);
group_coeffs = group_coeffs/(10^mean(real(log10(group_coeffs)))); %scale out crazy high powers of 10
disp('Group Coefficients')
disp(group_coeffs')

paper_group_coeffs =   [0.10; 0.08; 5.05; 1.65; 0.11; 0.97];
group_coeff = paper_group_coeffs;

tmp_ComparisonTable = ComparisonTable(:,[true true true alg_idx]);
group_score = linearAlgorithmCombination(tmp_ComparisonTable(:,4:end),group_coeffs');
disp(corr(ComparisonTable(:,3),group_score ))
disp(sum(bsxfun(@eq,sign(group_score - mean(group_score)),sign(ComparisonTable(:,3))))/length(ComparisonTable))
