function [pairRatingSummary, summaryHeaders]= summarisePairRatings(FullSurveyStruct,category_thold)
nAnswersPerPair = 3; % number of ratings per pair (target)

nPairs = length(FullSurveyStruct.AllImPairs_plan);
summaryHeaders = {'pair idx', 'cube idx 1', 'cube idx 2', 'slider value 1','slider value 2','slider value 3', 'slider std'};
nFields = length(summaryHeaders); 
pairRatingSummary = nan + zeros(nPairs,nFields);

% pair indedx
pairRatingSummary(:,1) = 1:nPairs;

% cube index
pairRatingSummary(:,2) = FullSurveyStruct.AllImPairs_plan(:,1);
pairRatingSummary(:,3) = FullSurveyStruct.AllImPairs_plan(:,2);

% slider values 
nRaters = length(FullSurveyStruct.Response);
for n = 1 : nRaters 
   nRatings =  length(FullSurveyStruct.Response(n).ImPairs_plan);
   for r = 1 : nRatings
       dist_pairs = bsxfun(@minus,FullSurveyStruct.AllImPairs_plan,FullSurveyStruct.Response(n).ImPairs_plan(r,:));
       [v,pair_match] = min(sum(abs(dist_pairs),2));
       if v ==0
           for a = 1 : nAnswersPerPair % find next empty ratings slot
               if isnan(pairRatingSummary(pair_match,3+a))
                    break
               end
           end
           pairRatingSummary(pair_match,3+a) = FullSurveyStruct.Response(n).sliderValue_planScaled(r);
       else
           
          fprintf('v = %d fail on n = %d r = %d \n',v,n,r)
       end
   end
    
end

pairRatingSummary(:,7) = std(pairRatingSummary(:,4:6),[],2);
% category_thold = 0.1;
pairRatingSummary(:,8) = cellfun(@(x)(length(unique(x))==1), ...
num2cell(sign(pairRatingSummary(:,4:6)) .* (abs(pairRatingSummary(:,4:6)) > category_thold), 2));

pairRatingSummary(:,9) = cellfun(@(x)(abs(sum(x))==3), ...
num2cell(sign(pairRatingSummary(:,4:6)).*(abs(pairRatingSummary(:,4:6)) > category_thold), 2));
