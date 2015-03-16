% Andrew Palmer
% 2015
% script for reproducing the results from the survey paper
% run this file from IMS_quality-master
%% Some global option
flag_save_im = 0; % saves images etc.
saveDir = ['..' filesep];
addpath(genpath(pwd)) %  but add folders to MATLAB path
%% Import Survey Responses
% First, load info on the image pairs used for the survey
load('/survey_images/ImagePairs_FullSurvey.mat')

% Load Survey Reponses
importDir ='/consistent_surveys';
%FullSurveyStruct = createFullSurveyStruct(importDir, SurveyPairList, ImPairs_rand); % note: scales slider values
load('/consistent_surveys/FullSurveyStruct.mat')
disp('Loaded Survey Responses')

% Parse data
categoryThold = 0.1;% rounding precision, 1/multiple of 10
categoryFunction = @(x)(round(x/categoryThold)*categoryThold);
[ratings, timings, rawdata] = generateDataTables(FullSurveyStruct,categoryFunction);
[pairRatingSummary, summaryHeaders] = summarisePairRatings(FullSurveyStruct,categoryThold);
n_ratings = checkNumberRatings(pairRatingSummary,find(~cellfun(@isempty,strfind(summaryHeaders,'slider value'))));
ratings = ratings(n_ratings==3,:);
[k_alpha, agreement_table_out] = calcualteKrippendorfAlpha(ratings);

%% Optimise k_alpha
% Remove one question at a time and re-check score
k_alpha_im = zeros(size(ratings,1),1);
for n=1:size(ratings,1)
    [k_alpha_im(n)] = calcualteKrippendorfAlpha(ratings(1:size(ratings,1)~=n,:));
end

% Remove one rater at a time and re-check score
k_alpha_rater = zeros(size(ratings,2),1);
for n=1:size(ratings,2)
    [k_alpha_rater(n)] = calcualteKrippendorfAlpha(ratings(:,1:size(ratings,2)~=n));
end

% Show results
figure;
subplot(1,2,1)
hist(100*(k_alpha_im-k_alpha)/k_alpha)
title('alpha_k with each pair removed')
xlabel('percentage change')
ylabel('number of pairs')

subplot(1,2,2)
hist(100*(k_alpha_rater-k_alpha)/k_alpha)
title('alpha_k with each rater removed')
xlabel('percentage change')
ylabel('number of raters')

disp('Leave one out k-alpha calcualted')
%save('leave_one_out.mat','k_alpha_rater','k_alpha_im')
%% removing members -> increased k_alpha
% so want to exclude k_alpha_im with -nv k_alpha change
q_vals_pair = 1:length(k_alpha_im);
[~,pair_id] = sort(k_alpha_im,'descend');%want to remove pairs where removing gave a high k_alpha
ka_q_pair = zeros(length(q_vals_pair),1);
for n=1:length(q_vals_pair) % plot at increasing cut-offs
    %       ka_q_pair(n) = calcualteKrippendorfAlpha(ratings(k_alpha_im<quantile(k_alpha_im,q_vals_pair(n)),:));
    ka_q_pair(n) = calcualteKrippendorfAlpha(ratings(pair_id(q_vals_pair(n):end),:));
end

q_vals_rater = 1:length(k_alpha_rater);
[~,rater_id] = sort(k_alpha_rater,'descend');
ka_q_rater = zeros(length(q_vals_rater),1);
for n=1:length(q_vals_rater) % plot at increasing cut-offs
    %    ka_q_rater(n) = calcualteKrippendorfAlpha(ratings(k_alpha_rater<quantile(k_alpha_rater,q_vals_rater(n)),:));
    ka_q_rater(n) = calcualteKrippendorfAlpha(ratings(:,rater_id(q_vals_rater(n):end)));
    n_im_rater(n)= sum(sum(~isnan(ratings(:,rater_id(q_vals_rater(n):end))),2)==3);
end
% save('opt_kalpha.mat','ka_q_rater','ka_q_pair')
figure
set(gcf,'color','w')
subplot(2,1,1),
plot_alpha_curve(q_vals_pair,ka_q_pair,[0.5,0.6,0.8,0.9], 'pairs')
subplot(2,1,2),
plot_alpha_curve(q_vals_rater,ka_q_rater,[0.5,0.6,0.8,0.9], 'raters',n_im_rater)
if flag_save_im
    saveas(gcf,'alpha_curves.png')
    saveas(gcf,'alpha_curves.fig')
end
%% Choose k-alpha cutoff
flag_auto = 0;
if flag_auto
    [~,alpha_thresh_idx] = max(ka_q_pair);
else
    alpha_target = input('Enter threshold  ', 's');
    [~,alpha_thresh_idx] = min(abs(ka_q_pair-str2double(alpha_target)));
end

pairs_agreement=zeros(size(n_ratings));
pairs_agreement(pair_id(q_vals_pair(alpha_thresh_idx):end)) = 1;

disp(sum(pairs_agreement))
disp('Systematic rater removal calcualted')
%% Plot time against slider std

tmp_timings=timings';
tmp_timings=reshape(tmp_timings(~isnan(tmp_timings)),3,[]); % time per pair (lose user information)
tmp_ratings=ratings';
tmp_ratings=reshape(tmp_ratings(~isnan(tmp_ratings)),3,[]); % rating per pair (lose user information)

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
disp('Timing Data Plotted')
%% Determine 'gold standard' image pairs
n_ratings_target = 3;
gs_consist_thresh = 0.25;
[pairRatingSummary, summaryHeaders] = summarisePairRatings(FullSurveyStruct,categoryThold);
n_ratings = checkNumberRatings(pairRatingSummary,find(~cellfun(@isempty,strfind(summaryHeaders,'slider value'))));

gs_def=@(x,y) x & y==n_ratings_target;

goldStandardPairs = gs_def(pairs_agreement,n_ratings);
disp([num2str(sum(goldStandardPairs)) ' Gold Standard Pairs'])
%% Re-Load Suvey Image
load('/survey_images/ImCube50_rand_filledInsideNaN.mat') % image cube with machine_precision*rand added to avoid absolute zero intensities
disp('All-Pairs Image data loaded')

%% Print Gold Standard Images
if flag_save_im
    for gs_thresh = [0.5,0.6,0.8]
        pairs_agreement=zeros(size(n_ratings));
        pairs_agreement(pair_id(q_vals_pair(alpha_thresh_idx):end)) = 1;
        goldStandardPairs = gs_def(pairs_agreement,n_ratings);
        save_dir = [saveDir filesep strrep(num2str(gs_thresh),'.','_') filesep];
        if ~exist(save_dir,'dir')
            mkdir(save_dir)
        end
        f = fopen([save_dir 'pair_ratings.csv'],'w');
        pair_ratings_header ='Pair Number,Pair Rating,Pair Rating Std\n';
        fprintf(f,pair_ratings_header);
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
                saveas(gcf,[save_dir 'pair_' num2str(n) '.png']);
                fprintf(f,[num2str(n) ',' num2str(mean(pairRatingSummary(n,4:6))) ',' num2str(std(pairRatingSummary(n,4:6))) '\n']);
            end
        end
        fclose(f)
    end
end
%% Calculate Image Descriptor for images in Survey
disp(' ')
disp('---------------- Calculate Image Descriptors Survey ----------------')
disp(' ')
window=[5 5];
load('/survey_images/ImCube50_rand_filledInsideNaN.mat')

MethodResultsForSurveyIm = calculateImageDescriptors(ImCube_rand_filled, mz_rand );
disp('Image Descriptors Calculated')

%% Comparing human judgment Vs Im
% Using lasso
%Construct the lasso fit using ten-fold cross validation. Include the FitInfo output so you can plot the result.
X = ComparisonTable(:,4:end);
X(~isfinite(X)) = nan;% should ignore any column with Inf entry
[B, FitInfo] = lasso(ComparisonTable(:,4:end),ComparisonTable(:,3),'CV',10);
% Plot the cross-validated fits.
lassoPlot(B,FitInfo,'PlotType','CV');
%% Calc correlation of best
X_0 = X;
X_0(isnan(X_0)) = 0;
group_score = linearAlgorithmCombination(X_0,[B(:,FitInfo.IndexMinMSE); 0]');
labels([false;false;false; B(:,FitInfo.IndexMinMSE)>0])
disp(corr(ComparisonTable(:,3),group_score ))
disp(sum(bsxfun(@eq,sign(group_score - mean(group_score)),sign(ComparisonTable(:,3))))/length(ComparisonTable))
%% Look at inclusion lists
idx = 1:167;
inc_count = (sum(B>0,2));
figure, stem(inc_count(inc_count>0))
set(gca,'XTick',1:sum(inc_count>0));
set(gca,'XTickLabel',labels([false;false;false; inc_count>0]))