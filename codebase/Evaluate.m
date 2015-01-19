
% matlabpool open
%% Results params1
% error('load params3!!!!!!!!!!!!!!!!!!!!!!')
% error('load Results params3')
% ResultBrain_5x5_SC_params1 = evaluateMethodsParallel(ImRatBrain, mzRatBrain, [5 5], params1, 'noim');
% disp('Brain')
% ResultKidney_5x5_SC_params1 = evaluateMethodsParallel(ImRatKidney, mzRatKidney, [5 5], params1, 'noim');
% disp('Kidney')
% ResultPan1_5x5_SC_params1 = evaluateMethodsParallel(ImPancreas1, mzPancreas, [5 5], params1, 'noim');
% disp('Pan1')
% 
% ResultPan2_5x5_SC_params1 = evaluateMethodsParallel(ImPancreas2, mzPancreas, [5 5], params1, 'noim');
% disp('Pan2')
% ResultPan3_5x5_SC_params1 = evaluateMethodsParallel(ImPancreas3, mzPancreas, [5 5], params1, 'noim');
% disp('Pan3')
% ResultPan4_5x5_SC_params1 = evaluateMethodsParallel(ImPancreas4, mzPancreas, [5 5], params1, 'noim');
% disp('Pan4')
% ResultPan5_5x5_SC_params1 = evaluateMethodsParallel(ImPancreas5, mzPancreas, [5 5], params1, 'noim');
% disp('Pan5')
% ResultPan6_5x5_SC_params1 = evaluateMethodsParallel(ImPancreas6, mzPancreas, [5 5], params1, 'noim');
% disp('Pan6')
% 
% save('C:\Users\Mikael\Dropbox\Denator\Data\Method_results_params1.mat','ResultBrain_5x5_SC_params1',...
%     'ResultKidney_5x5_SC_params1','ResultPan1_5x5_SC_params1','ResultPan2_5x5_SC_params1',...
%     'ResultPan3_5x5_SC_params1','ResultPan4_5x5_SC_params1','ResultPan5_5x5_SC_params1',...
%     'ResultPan6_5x5_SC_params1');
% 
% disp('------------------------ Params1 done ------------------------')

%% Results params2
% ResultBrain_5x5_SC_params2 = evaluateMethodsParallel(ImRatBrain, mzRatBrain, [5 5], params2, 'noim');
% disp('Brain')
% ResultKidney_5x5_SC_params2 = evaluateMethodsParallel(ImRatKidney, mzRatKidney, [5 5], params2, 'noim');
% disp('Kidney')
% ResultPan1_5x5_SC_params2 = evaluateMethodsParallel(ImPancreas1, mzPancreas, [5 5], params2, 'noim');
% disp('Pan1')
% 
% ResultPan2_5x5_SC_params2 = evaluateMethodsParallel(ImPancreas2, mzPancreas, [5 5], params2, 'noim');
% disp('Pan2')
% ResultPan3_5x5_SC_params2 = evaluateMethodsParallel(ImPancreas3, mzPancreas, [5 5], params2, 'noim');
% disp('Pan3')
% ResultPan4_5x5_SC_params2 = evaluateMethodsParallel(ImPancreas4, mzPancreas, [5 5], params2, 'noim');
% disp('Pan4')
% ResultPan5_5x5_SC_params2 = evaluateMethodsParallel(ImPancreas5, mzPancreas, [5 5], params2, 'noim');
% disp('Pan5')
% ResultPan6_5x5_SC_params2 = evaluateMethodsParallel(ImPancreas6, mzPancreas, [5 5], params2, 'noim');
% disp('Pan6')
% 
% save('C:\Users\Mikael\Dropbox\Denator\Data\Method_results_params2.mat','ResultBrain_5x5_SC_params2',...
%     'ResultKidney_5x5_SC_params2','ResultPan1_5x5_SC_params2','ResultPan2_5x5_SC_params2',...
%     'ResultPan3_5x5_SC_params2','ResultPan4_5x5_SC_params2','ResultPan5_5x5_SC_params2',...
%     'ResultPan6_5x5_SC_params2');
% 
% disp('------------------------ Params2 done ------------------------')

%% Results params_Pan1
% ResultBrain_5x5_SC_paramsPan = evaluateMethodsParallel(ImRatBrain, mzRatBrain, [5 5], paramsPan, 'noim');
% disp('Brain')
% ResultKidney_5x5_SC_paramsPan = evaluateMethodsParallel(ImRatKidney, mzRatKidney, [5 5], paramsPan, 'noim');
% disp('Kidney')
% ResultPan1_5x5_SC_paramsPan = evaluateMethodsParallel(ImPancreas1, mzPancreas, [5 5], paramsPan, 'noim');
% disp('Pan1')
% 
% ResultPan2_5x5_SC_paramsPan = evaluateMethodsParallel(ImPancreas2, mzPancreas, [5 5], paramsPan, 'noim');
% disp('Pan2')
% ResultPan3_5x5_SC_paramsPan = evaluateMethodsParallel(ImPancreas3, mzPancreas, [5 5], paramsPan, 'noim');
% disp('Pan3')
% ResultPan4_5x5_SC_paramsPan = evaluateMethodsParallel(ImPancreas4, mzPancreas, [5 5], paramsPan, 'noim');
% disp('Pan4')
% ResultPan5_5x5_SC_paramsPan = evaluateMethodsParallel(ImPancreas5, mzPancreas, [5 5], paramsPan, 'noim');
% disp('Pan5')
% ResultPan6_5x5_SC_paramsPan = evaluateMethodsParallel(ImPancreas6, mzPancreas, [5 5], paramsPan, 'noim');
% disp('Pan6')
% 
% save('C:\Users\Mikael\Dropbox\Denator\Data\Method_results_paramsPan.mat','ResultBrain_5x5_SC_paramsPan',...
%     'ResultKidney_5x5_SC_paramsPan','ResultPan1_5x5_SC_paramsPan','ResultPan2_5x5_SC_paramsPan',...
%     'ResultPan3_5x5_SC_paramsPan','ResultPan4_5x5_SC_paramsPan','ResultPan5_5x5_SC_paramsPan',...
%     'ResultPan6_5x5_SC_paramsPan');
% 
% disp('------------------------ Params_Pan done ------------------------')

%% CompResults
% Brain ----------------------------
CompRes_Brain_Set1_5x5_SC_params1_adj = evaluateByPairComp(ImPairs_Brain_Set1_30_adj, ResultBrain_5x5_SC_params1, chosenLR_Brain_Set1_30_adj);
CompRes_Brain_Set1_5x5_SC_params2_adj = evaluateByPairComp(ImPairs_Brain_Set1_30_adj, ResultBrain_5x5_SC_params2, chosenLR_Brain_Set1_30_adj);
CompRes_Brain_Set1_5x5_SC_params3_adj = evaluateByPairComp(ImPairs_Brain_Set1_30_adj, ResultBrain_5x5_SC_params3, chosenLR_Brain_Set1_30_adj);
CompRes_Brain_Set1_5x5_SC_paramsPan_adj = evaluateByPairComp(ImPairs_Brain_Set1_30_adj, ResultBrain_5x5_SC_paramsPan, chosenLR_Brain_Set1_30_adj);

CompRes_Brain_Set2_5x5_SC_params1_adj = evaluateByPairComp(ImPairs_Brain_Set2_40_adj, ResultBrain_5x5_SC_params1, chosenLR_Brain_Set2_40_adj);
CompRes_Brain_Set2_5x5_SC_params2_adj = evaluateByPairComp(ImPairs_Brain_Set2_40_adj, ResultBrain_5x5_SC_params2, chosenLR_Brain_Set2_40_adj);
CompRes_Brain_Set2_5x5_SC_params3_adj = evaluateByPairComp(ImPairs_Brain_Set2_40_adj, ResultBrain_5x5_SC_params3, chosenLR_Brain_Set2_40_adj);
CompRes_Brain_Set2_5x5_SC_paramsPan_adj = evaluateByPairComp(ImPairs_Brain_Set2_40_adj, ResultBrain_5x5_SC_paramsPan, chosenLR_Brain_Set2_40_adj);
disp('Brain CompRes')

% Kidney ----------------------------
CompRes_Kidney_Set1_5x5_SC_params1_adj = evaluateByPairComp(ImPairs_Kidney_Set1_40x2_adj, ResultKidney_5x5_SC_params1, chosenLR_Kidney_Set1_40x2_adj);
CompRes_Kidney_Set1_5x5_SC_params2_adj = evaluateByPairComp(ImPairs_Kidney_Set1_40x2_adj, ResultKidney_5x5_SC_params2, chosenLR_Kidney_Set1_40x2_adj);
CompRes_Kidney_Set1_5x5_SC_params3_adj = evaluateByPairComp(ImPairs_Kidney_Set1_40x2_adj, ResultKidney_5x5_SC_params3, chosenLR_Kidney_Set1_40x2_adj);
CompRes_Kidney_Set1_5x5_SC_paramsPan_adj = evaluateByPairComp(ImPairs_Kidney_Set1_40x2_adj, ResultKidney_5x5_SC_paramsPan, chosenLR_Kidney_Set1_40x2_adj);

CompRes_Kidney_Set2_5x5_SC_params1_adj = evaluateByPairComp(ImPairs_Kidney_Set2_40_adj, ResultKidney_5x5_SC_params1, chosenLR_Kidney_Set2_40_adj);
CompRes_Kidney_Set2_5x5_SC_params2_adj = evaluateByPairComp(ImPairs_Kidney_Set2_40_adj, ResultKidney_5x5_SC_params2, chosenLR_Kidney_Set2_40_adj);
CompRes_Kidney_Set2_5x5_SC_params3_adj = evaluateByPairComp(ImPairs_Kidney_Set2_40_adj, ResultKidney_5x5_SC_params3, chosenLR_Kidney_Set2_40_adj);
CompRes_Kidney_Set2_5x5_SC_paramsPan_adj = evaluateByPairComp(ImPairs_Kidney_Set2_40_adj, ResultKidney_5x5_SC_paramsPan, chosenLR_Kidney_Set2_40_adj);
disp('kidney CompRes')

% Pan1 ----------------------------
CompRes_Pan1_Set1_5x5_SC_params1_adj = evaluateByPairComp(ImPairs_Pan1_Set1_50_adj, ResultPan1_5x5_SC_params1, chosenLR_Pan1_Set1_50_adj);
CompRes_Pan1_Set1_5x5_SC_params2_adj = evaluateByPairComp(ImPairs_Pan1_Set1_50_adj, ResultPan1_5x5_SC_params2, chosenLR_Pan1_Set1_50_adj);
CompRes_Pan1_Set1_5x5_SC_params3_adj = evaluateByPairComp(ImPairs_Pan1_Set1_50_adj, ResultPan1_5x5_SC_params3, chosenLR_Pan1_Set1_50_adj);
CompRes_Pan1_Set1_5x5_SC_paramsPan_adj = evaluateByPairComp(ImPairs_Pan1_Set1_50_adj, ResultPan1_5x5_SC_paramsPan, chosenLR_Pan1_Set1_50_adj);

CompRes_Pan1_Set2_5x5_SC_params1_adj = evaluateByPairComp(ImPairs_Pan1_Set2_40_adj, ResultPan1_5x5_SC_params1, chosenLR_Pan1_Set2_40_adj);
CompRes_Pan1_Set2_5x5_SC_params2_adj = evaluateByPairComp(ImPairs_Pan1_Set2_40_adj, ResultPan1_5x5_SC_params2, chosenLR_Pan1_Set2_40_adj);
CompRes_Pan1_Set2_5x5_SC_params3_adj = evaluateByPairComp(ImPairs_Pan1_Set2_40_adj, ResultPan1_5x5_SC_params3, chosenLR_Pan1_Set2_40_adj);
CompRes_Pan1_Set2_5x5_SC_paramsPan_adj = evaluateByPairComp(ImPairs_Pan1_Set2_40_adj, ResultPan1_5x5_SC_paramsPan, chosenLR_Pan1_Set2_40_adj);
disp('pan1 CompRes')

save('EVERYTHING.mat')
