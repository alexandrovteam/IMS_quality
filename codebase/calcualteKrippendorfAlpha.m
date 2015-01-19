function [k_alpha, agreement_table_out] = calcualteKrippendorfAlpha(ratings,varargin)
% [k_alpha, agreement_table_out] = calcualteKrippendorfAlpha(ratings,varargin)
% http://www.asc.upenn.edu/usr/krippendorff/mwebreliability5.pdf
% Deal with input arguments TODO

%defaults:
type = 'interval';
for v = 1 : 2 : length(varargin)
    switch varargin{v}
        case 'type'
            type = varargin{v+1};
    otherwise
        error('calcKripAlpha:badinput',['input pair ' varargin{v} ' not known'])
    end
end



% Get the number of pairs assesed from the data
nObjects = size(ratings,1);
nRaters = size(ratings,2); % number of raters

categories = unique(ratings(~isnan(ratings)));
nCategories = length(categories);
t=0;




% Converts raw ratings into an agreement table
agreement_table = zeros(nObjects,nCategories);
for n = 1 : nObjects
    for r = 1 : nRaters
        if ~isnan(ratings(n,r))
            t = t+1;
            % tally number of times object n is classified as a particular class
            c = find(categories == ratings(n,r));
            agreement_table(n,c) = agreement_table(n,c) + 1; 
        end
    end
end

% calculate total ratings per object
total_perObject = sum(agreement_table,2);

% can only use objects with >1 rating
agreement_table_out = agreement_table;
agreement_table = agreement_table(total_perObject>1,:);
total_perObject = total_perObject(total_perObject>1);
total_perClass = sum(agreement_table,1);

% Calculation of krippendorf's alpha
% krip_alpha = 1 - Da/De;
% Da - disagreement acutal, De - disagreement expected

% update tallies
nObjects = size(agreement_table,1);
nCategories = size(agreement_table,2);

% func_struct = {@(c,k)(1);
%                @(c,k)((c-k).^2)
%                @(c,k)((c-k).^2)
%                @(c,k)(((c-k)/(c+k)).^2)};
switch  type
    case 'nominal'
        type_idx = 1;
        delta = ones(nCategories);
    case 'interval'
        type_idx = 2;
        delta = zeros(nCategories);

        for c = 1 : nCategories
            for k = c + 1 : nCategories
                delta(c,k) = (c-k).^2;
            end
        end
        
    case 'ratio'
        type_idx = 3;
        delta = zeros(nCategories);

        for c = 1 : nCategories
            for k = c + 1 : nCategories
                delta(c,k) = ((c-k)/(c+k)).^2;
            end
        end
    otherwise
        error('type not know')
end
Da = 0;%zeros(nObjects,1);
for u = 1 : nObjects; 
    tmp = 0;
    for c = 1 : nCategories
        for k = c + 1 : nCategories
             tmp = tmp + agreement_table(u,c)*agreement_table(u,k)*delta(c,k);
%              tmp = tmp + agreement_table(u,c)*agreement_table(u,k)*delta(c,k,type_idx,func_struct);

        end
    end

    Da = Da + tmp./(total_perObject(u)-1);
end

Da = (sum(total_perClass) -1)*sum(Da);

De = 0;
for c = 1:nCategories - 1
    del = zeros(1,length(total_perClass) - c);
    for d = 1 : length(total_perClass) - c
        del(d) = delta_func(0,d,type_idx);
    end
    De = De + total_perClass(c)*sum(total_perClass(c+1:end).*del);
end

k_alpha = 1 - Da/De;

function d = delta_func(c,k,type)
func_struct = {@(c,k)(1);
               @(c,k)((c-k).^2)
               @(c,k)((c-k).^2)
               @(c,k)(((c-k)/(c+k)).^2)};
           
d = feval(func_struct{type},c,k);

