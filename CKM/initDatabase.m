function [imPathAll, rgbd_imPath, rgbd_dePath,rgbdCLabel, rgbdILabel, rgbdVLabel] = initDatabase(params)
%%%%%%%%%%%%%%%%%%%%%%%%%
%   Description:
%   get the information of the dataset
%
%   Parmameters:
%   params-
%
%   Outputs:
%   imPath - path of each image
%   rgbdCLabel - class label of each image
%   rgbdILabel - instance label of each image
%   rgbdVLabel - view label of each image
%

if ~exist([params.dataDir 'rgbd_info.mat'], 'file')
    % compute the paths of images    
    disp('Get the paths of all the images')
    datasetDir = params.datasetDir;
    categories = dir(datasetDir);
    categories = categories(3:end);
    imPathAll = [];
    rgbd_imPath = [];
    rgbd_dePath=[];
    depPathAll=[];
    rgbdCLabel = [];
    rgbdILabel = [];
    rgbdVLabel = [];    
    labelNum = 0;
    params.sampleStride=1;%%%
    for i = 1:length(categories)
        fprintf('Read images from categoty %d / %d \n', i, length(categories));

        [rgbdILabelTmp, imPathTmp, imPathAllTmp] = getImgLabel([datasetDir categories(i).name], '*_crop.png', params.sampleStride);
        [rgbdILabelTmp, dePathTmp, dePathAllTmp] = getImgLabel([datasetDir categories(i).name], '*_depthcrop.png', params.sampleStride);
        for j = 1:length(imPathTmp)
            ind = find(imPathTmp{j} == '_');
            rgbdVLabelTmp(1,j) = str2num(imPathTmp{j}(ind(end-2)+1));
        end
        imPathAll = [imPathAll imPathAllTmp];
        rgbd_imPath = [rgbd_imPath imPathTmp];
        rgbd_dePath=[rgbd_dePath dePathTmp];
        rgbdCLabel = [rgbdCLabel i*ones(1,length(imPathTmp))];
        rgbdILabel = [rgbdILabel rgbdILabelTmp+labelNum];
        rgbdVLabel = [rgbdVLabel rgbdVLabelTmp];
        labelNum = labelNum + length(unique(rgbdILabelTmp));
        clear imPathAllTmp dePathAllTmp dePathTmp imPathTmp rgbdILabelTmp rgbdVLabelTmp 
    end
    save([params.dataDir 'rgbd_info.mat'], 'imPathAll', 'rgbd_imPath', 'rgbd_dePath','rgbdCLabel', 'rgbdILabel', 'rgbdVLabel');
else
    disp('Load the paths of all the images')
    load([params.dataDir 'rgbd_info.mat']);
end

disp(['total images: ' num2str(length(imPathAll))])
disp(['sample images: ' num2str(length(rgbd_imPath))])
