function fea = scaleFea(fea, type)
%%%%%%%%%%%%%%%%%%%%%%%%%
%   Description:
%   scale the features
%
%   Parameters:
%   fea - num x dimension
%
minvalue = min(fea,[],1);
maxvalue = max(fea,[],1);
switch type
    case 'linear'
        parfor i = 1:size(fea,1) 
            fea(i, :) = (fea(i, :) - minvalue)./(maxvalue - minvalue);
        end
    case 'power'
        ppp = 0.3;
        parfor i = 1:size(fea,1)
            fea(i, :) = sign(fea(i, :)).*abs(fea(i, :)).^ppp;
        end
    otherwise
        disp('Unknown type');
end