function [dictionaries, params] = pretrain(imPath, dePath, rgbdILabel,  params, type)

%%%%%%%%%%%%%%%%%%%%%%%%%
%   Description:
%   learn the dictionaries by k-means
%  
disp('learn the dictionary')
switch type
    case 0
        if exist([params.feaDir 'dicRGB_CKM.mat'], 'file')
            load([params.feaDir 'dicRGB_CKM.mat']);
            return
        end        
    case 1
         if exist([params.feaDir 'dicGray_CKM.mat'], 'file')
            load([params.feaDir 'dicGray_CKM.mat']);
            return
         end      
    case 2
         if exist([params.feaDir 'dicDepth_CKM.mat'], 'file')
            load([params.feaDir 'dicDepth_CKM.mat']);
            return
         end    
    case 3
         if exist([params.feaDir 'dicNormal_CKM.mat'], 'file')
            load([params.feaDir 'dicNormal_CKM.mat']);
            return
         end    
end
params.patchOverlap = 0.01;
showDicts = false;

% patches = numPatches x patchSize
patches = getPatches(imPath, dePath, rgbdILabel, params, type); 

%% get whitening info from patches
% normalize for contrast
patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,[],2)+10));

C = cov(patches);
M = mean(patches);
[V,D] = eig(C);
P = V * diag(sqrt(1./(diag(D) + 0.1))) * V';

% Now whiten patches before pretraining
patches = bsxfun(@minus, patches, M) * P;
dictionaries = runKmeans(patches,params.numFilters,100);

if showDicts    
    showCentroids(dictionaries, params.rfSize);
end

params.whiten.P = P;
params.whiten.M = M;

switch type
    case 0
        disp('save dicRGB_CRNN.mat')
        save([params.feaDir 'dicRGB_CKM.mat'], 'dictionaries', 'params');
    case 1
        disp('save dicGray_CRNN.mat')
        save([params.feaDir 'dicGray_CKM.mat'], 'dictionaries', 'params');
    case 2
        disp('save dicDepth_CRNN.mat')
        save([params.feaDir 'dicDepth_CKM.mat'], 'dictionaries', 'params');
    case 3
        disp('save dicNormal_CRNN.mat')
        save([params.feaDir 'dicNormal_CKM.mat'], 'dictionaries', 'params');
end
return;

function patches  = getPatches(imPath, dePath, rgbdILabel, params, type)
% returns patches = numPatches x patchSize
% use imPathAll may learn bettern dictionaries
switch type
    case 0 
        channels = 3; % rgb
    case 1 
        channels = 1; % gray
    case 2 
        channels = 1; % depth
    case 3 
        channels = 3; % surface normals
end

instance = unique(rgbdILabel);
disp(['instance: ' num2str(length(instance))])
numWant = params.numPatches;
rfSize = params.rfSize;
patches = zeros(rfSize*rfSize*channels,numWant);

numHave = 0;
printCount = 0;
printStride = 1000;
iterNum = 0;
while numHave < numWant
    % load this instance
    iterNum = iterNum + 1;
    disp(['**********iterNum is ' num2str(iterNum) '************'])
    for instIdx = 1:length(instance)
        if (iterNum>1) && (rand < 0.1) 
            continue;
        end
        instDataIdxs = find(rgbdILabel == instance(instIdx));
        %instDataIdxs = randsample(instDataIdxs, ceil(length(instDataIdxs)*0.2));
        for instDataIdx = instDataIdxs
            switch type
                case 0 
                    img = imread([imPath{instDataIdx}]);                    
                    img = double(imresize(img,params.setImgSize));
                case 1
                    img = imread([imPath{instDataIdx}]);                    
                    img = rgb2gray(img);
                    img = double(imresize(img,params.setImgSize));
                case 2
                    img = swapbytes(imread([dePath{instDataIdx}]));
                    img = double(imresize(img,params.setImgSize));
                case 3
                    img = depthtonormal([dePath{instDataIdx}]);
                    img = double(imresize(img,params.setImgSize));
            end 

            % get all possible patches
            imgPatches = [];
            for ch = 1:size(img,3)
                imgPatches = [imgPatches; im2col(img(:,:,ch), [rfSize rfSize])];
            end

            % subsample all possible patches
            keepInds = randperm(size(imgPatches, 2));
            %numToTake = min(round(length(keepInds)*0.002), numWant-numHave);
            numToTake = min(20, numWant-numHave);
            keepInds = keepInds(1:numToTake);

            % add patches
            patches(:,numHave+1:numHave+length(keepInds)) = imgPatches(:,keepInds);
            numHave = numHave + length(keepInds);
            if numHave == numWant
                disp(['Now have ' num2str(numHave) '/' num2str(numWant) ' patches']);
                break;
            elseif  numHave > (printStride*printCount)
                disp(['Now have ' num2str(numHave) '/' num2str(numWant) ' patches']);
                printCount = printCount + 1;
            end
        end
    end
end
patches = patches';
return;
