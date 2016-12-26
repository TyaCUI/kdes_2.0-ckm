function [imLabel, imPath, imPathAll] = getImgLabel(fileCatName, subName, sampleStride)
%%%%%%%%%%%%%%%%%%%%%%%%%
%   Description:
%   generate the image label and path
%
%   Parmameters:
%   fileCategoryName - image category folder
%   subName - '*_depthcrop.png'
%   sampleStride - the stride of sampling images from each folder
%
%   Outputs:
%   imLabel - instance label
%   imPath - image path
%   
%
instance = dir(fileCatName);
instance = instance(3:end);
it = 0;
itAll = 0;
for i = 1:length(instance)       
   fileInstName = [fileCatName '/' instance(i).name '/'];
   instanceData = dir([fileInstName subName]);
   instanceData = getValidInds(instanceData, fileInstName);
   for j = 1:length(instanceData)
       itAll = itAll + 1;
       imPathAll{1, itAll} = [fileInstName instanceData(j).name];
       if mod(j, sampleStride) == 0%1
           it = it + 1;
           % generate image paths
           imPath{1,it} = [fileInstName instanceData(j).name];
           imLabel(1,it) = i;
       end
   end
end


function instanceData = getValidInds(instanceData, fileInstName)
%%%%%%%%%%%%%%%%%%%%%%%%%
%   Description:
%   ensure that every image contains the *crop, *maskcrop, and
%   *depthcrop PNG images. 
%
%   
deleteInds = [];
for instDataInd = 1:length(instanceData)
    startInd = max(strfind(instanceData(instDataInd).name,'_'));
    newName = [instanceData(instDataInd).name(1:startInd) 'maskcrop.png'];
    if ~exist([fileInstName '/' newName],'file')
        deleteInds = [deleteInds instDataInd];
    end
end

instanceData(deleteInds) = [];


