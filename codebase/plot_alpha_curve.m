function plot_alpha_curve(n_include,k_alpha,k_val_lines,type_str,varargin)
%k_alpha=k_alpha(end:-1:1); %flip direction for aestetics 
plot(n_include,k_alpha,'linewidth',3)
set(gca,'YLim',[0 1])
title(['alpha_k with ' type_str ' removed - removing poorly performing pairs (below quintile)'])
xlabel([type_str ' remaining'])
ylabel('alpha_k')
set(gca,'XLim',[1,max(n_include)])

k_val_lines=[k_val_lines max(k_alpha)];
n_inc_line=zeros(size(k_val_lines));
k_line = zeros(size(k_val_lines));
for n=1:length(k_val_lines)
    for min_idx=1:length(k_alpha)% find first value where larger
        if k_alpha(min_idx)>=k_val_lines(n)
            break
        end
    end
   n_inc_line(n) = n_include(min_idx);
   k_line(n)=k_alpha(min_idx);
   line([0,n_inc_line(n)],[k_line(n) k_line(n)],'color','black','linewidth',2)
   line([n_inc_line(n),n_inc_line(n)],[0 k_line(n)],'color','black','linewidth',2)
   if strcmp(type_str,'raters')
        n_pairs(n) = varargin{1}(min_idx);
   end
end
n_inc_line=unique(n_inc_line);
k_line=unique(k_line);
if strcmp(type_str,'raters')
    for n=1:length(k_val_lines)
       x_label{n} = [num2str(max(n_include)-n_inc_line(n)+1) '(' num2str(n_pairs(n)) ')'];
    end
else
    x_label = max(n_include)-n_inc_line+1;
end
set(gca,'XTick',n_inc_line,'XTickLabel',x_label)
set(gca,'YTick',k_line)
