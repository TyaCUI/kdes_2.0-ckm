function [imlabel, impath] = get_im_label(imdir, subname, subsample)
% generate the image paths and the corresponding image labels
% written by Liefeng Bo on 01/05/2011 in University of Washington

% directory
if nargin < 2
   subdir = dir_bo(imdir);
   it = 0;
   for i = 1:length(subdir)
       datasubdir{i} = [imdir '/' subdir(i).name];
       dataname = dir_bo(datasubdir{i});
       for j = 1:subsample:size(dataname,1)
           it = it + 1;
 	       % generate image paths
           impath{1,it} = [datasubdir{i} '/' dataname(j).name];
           imlabel(1,it) = i;
       end
   end

else
   subdir = dir_bo(imdir);
   it = 0;
   for i = 1:length(subdir)
       datasubdir{i} = [imdir subdir(i).name];
       dataname = dir([datasubdir{i} '/*' subname]);
       dataname = getValidInds(dataname, datasubdir{i});
       for j = 1:subsample:size(dataname,1)
           it = it + 1;
           % generate image paths
           impath{1,it} = [datasubdir{i} '/' dataname(j).name];
           imlabel(1,it) = i;
       end
   end
end

function instanceData = getValidInds(instanceData, fileInstName)
% This is to ensure that every image contains the *crop, *maskcrop, and
% *depthcrop PNG images. 

deleteInds = [];
for instDataInd = 1:length(instanceData)
    startInd = max(strfind(instanceData(instDataInd).name,'_'));
    newName = [instanceData(instDataInd).name(1:startInd) 'maskcrop.png'];
    if ~exist([fileInstName '/' newName],'file')
        deleteInds = [deleteInds instDataInd];
    end
end

instanceData(deleteInds) = [];


