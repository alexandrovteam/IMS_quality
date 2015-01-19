function SurveyStruct = importSurveyResults( filepath, NInfo, endString )
%UNTITLED Summary of this function goes here
%   importSurveyResults( filepath, NumberOfInfoStrings, String that ends the header )

fid = fopen(filepath);
ScanOutput = textscan(fid,'%s', 'Delimiter',{','}, 'MultipleDelimsAsOne',false,...
    'EndOfLine','\r\n', 'Whitespace','');
fclose(fid);

ScanOutput = ScanOutput{1}; % Mx1 cell array with all strings in file. M is number of total strings.
ScanOutput = fixStringsWithCommas(ScanOutput); % Fix user-entered commas 
ScanOutput = removeCitationWrap(ScanOutput); % Remove " at the beginning and end
ScanOutput = fixDoubleCitation(ScanOutput); % Convert "" into "
ScanOutput = replaceOutputNaN(ScanOutput); % Replace Empty with NaN
ScanOutput = convertOutputNumbers(ScanOutput); % Convert "number strings" to double

% Find response lenght and # responses
repStr = cell(size(ScanOutput));
repStr(:) = {endString};
lastEntry = cellfun(@strcmpi,ScanOutput,repStr);
responseLength = find(lastEntry);
Nresp = length(ScanOutput)/responseLength - 1;
if mod(Nresp,1) ~= 0
    error('The number of responses in input file differ between participants')
end

InfoStrings = genvarname(ScanOutput(1:NInfo));

SurveyStruct.structCreated = datestr(clock);
SurveyStruct.numberOfResponses = Nresp;

Header = ScanOutput( 1:responseLength);
UserOutput = cell(Nresp,1);
for k = 1:Nresp
    UserOutput{k} = ScanOutput( k*responseLength+1:(k+1)*responseLength );
  
    %% Automatic Information Fields
    for n = 1:NInfo
        if ischar(UserOutput{k}{n});
            userStr = ['''' UserOutput{k}{n} ''''];
        else
            userStr = num2str(UserOutput{k}{n});
        end
        eval([ 'SurveyStruct.User(k).' InfoStrings{n} '=' userStr ';']);
    end
    
    %% User Related Information
    UserInfoName{1} = 'Experience';
    UserCode{1} = 'QExp';
    
    UserInfoName{2} = 'Work';
    UserCode{2} = 'QWork';
    
    UserInfoName{3} = 'Handedness';
    UserCode{3} = 'QLRhand';
    
    UserInfoName{4} = 'Mail';
    UserCode{4} = 'QMail';
    
    SurveyStruct = findAndAddToSurveyStruct( Header, UserCode, UserOutput{k}, SurveyStruct, k, UserInfoName );
    
    %% Extract Answer Info
    Nrep = 3; % Number of repeated pairs
    
    [answer,LR] = ... 
        extractReoccuringInfo(Header, UserOutput{k}, {'Qim','LR_Q'},'NonNaN','cell2mat');
    LR_rand = logical(LR(Nrep+1:end));
    
    %% Extract Info on Repeated Pairs
    repAnsInd = extractRepeatInd( Header, {'QRep' ' [SQ001]'}, Nrep );
    repLRInd = extractRepeatInd( Header, 'LR_QRep', Nrep );
    repTimeInd = -1 + extractRepeatInd( Header, {'QRep' 'Time'}, Nrep ); % Actual index will be shifted -1 because we want groupTime
    
    repPairSliderValue = cell2mat(UserOutput{k}(repAnsInd));
    repPairLRFlipValue = logical(cell2mat( UserOutput{k}(repLRInd) ));
    repPairTimings = cell2mat( UserOutput{k}(repTimeInd) );
    
    %% Extract Timings Info
    groupsBeforeQuestions = 2;
    groupsAfterQuestions = 1;
    
    [timings,totalTime,Indices] = extractReoccuringInfo(Header,...
        UserOutput{k}, {'groupTime','interviewtime'}, 'cell2mat', 'returnInd');
    timings_randQ = timings(groupsBeforeQuestions + 1 : end - groupsAfterQuestions);
    timeInd_randQ = Indices{1}(groupsBeforeQuestions + 1 : end - groupsAfterQuestions);
    
    [wasFound,indToRemove] = ismember(repTimeInd, timeInd_randQ);
    if ~all(wasFound)
        error('There was an error when locating indices for repeated pair timings')
    end
    timings_randQ(indToRemove) = [];
    
    %% Extract Survey Evaluation
    EvalName{1} = 'Agreement Statements';
    EvalCode{1} = {'QEval_Agreement [SQ00' ']'};
    EvalRep(1) = 4;
    
    EvalName{2} = 'Duration';
    EvalCode{2} = 'QEval_Time [SQ001]';
    EvalRep(2) = 1;
    
    EvalName{3} = 'NumberOfPairs';
    EvalCode{3} = 'QEval_NQs [SQ001]';
    EvalRep(3) = 1;
    
    EvalName{4} = 'Quality Asessment';
    EvalCode{4} = 'QEval_Asessment';
    EvalRep(4) = 1;
    
    EvalName{5} = 'Additional Comments';
    EvalCode{5} = 'QEval_Comment';
    EvalRep(5) = 1;
    
    for m = 1:length(EvalRep)
        ind = extractRepeatInd( Header, EvalCode{m}, EvalRep(m) );
        EvalExtracted{m} = UserOutput{k}(ind);
    end
   
    
    %% Add Values to SurveyStruct
    SurveyStruct.User(k).LRFlipValue = LR_rand';
    SurveyStruct.User(k).sliderValue_survey = answer';
    
    SurveyStruct.User(k).totalTime = totalTime;
    SurveyStruct.User(k).timings = timings_randQ';
    
    SurveyStruct.User(k).repPairLRFlipValue = repPairLRFlipValue';
    SurveyStruct.User(k).repPairSliderValue_survey = repPairSliderValue';
    SurveyStruct.User(k).repPairTimings = repPairTimings';
    
    SurveyStruct = addEvalToStruct( SurveyStruct, k, EvalExtracted, EvalName, EvalRep );
end

end


