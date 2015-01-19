function SurveyStruct_upd = addEvalToStruct( SurveyStruct, structPlace, ToAdd, Name, Rep ) %#ok<INUSL>
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

SurveyStruct_upd = SurveyStruct;
for m = 1: length(Rep)
    info = ToAdd{m};
    
    if length(info) == 1
        info = info{1};
    end
    
    eval([ 'SurveyStruct_upd.User(structPlace).Eval.' genvarname(Name{m}) '= info;']);
end

end

