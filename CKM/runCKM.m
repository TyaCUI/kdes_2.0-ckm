function runCKM()
%%%%%%%%%%%%%%%%%%%%%%%%%
%   Description:
%   extract CKM features from RGB(type=0), grayscale(type=1), 
%   depth(type=2), surface normals(type=3).
%
if matlabpool('size') == 0
    matlabpool open local 16; % based on your computer
end
params = initParams();
[imPathAll, rgbd_imPath, rgbd_dePath,rgbdCLabel, rgbdILabel, rgbdVLabel] = initDatabase(params);
%addpath('../../omp-liblinear/matlab-omp/')
addpath('../liblinear-1.5-dense-float/matlab');
addpath('../helpfun');
addpath('../kdes')
load([params.dataDir 'rgbd_info.mat'])
for type = 0:3
    [dictionaries, params] = pretrain(rgbd_imPath, rgbd_dePath, rgbdILabel, params, type);   
    switch type
        case 0 % rgb
	    disp('extract rgbFea_CKM')
            if exist([params.feaDir 'rgbFea_CKM.mat'],'file')
	    else
            rgbFea = extractFeatures(rgbd_imPath, rgbd_dePath, dictionaries, params, type);
            save([params.feaDir 'rgbFea_CKM.mat'], 'rgbFea', '-v7.3');
            clear rgbFea
	    end
        case 1 % gray
            disp('extract grayFea_CRNN')
	    if exist([params.feaDir 'grayFea_CKM.mat'],'file')
            else
            grayFea = extractFeatures(rgbd_imPath, rgbd_dePath, dictionaries, params, type);
            save([params.feaDir 'grayFea_CKM.mat'], 'grayFea', '-v7.3');
            clear grayFea
            end
        case 2 % depth
            disp('extract depthFea_CRNN')
	    if exist([params.feaDir 'depthFea_CKM.mat'],'file')
            else
            depthFea = extractFeatures(rgbd_imPath, rgbd_dePath, dictionaries, params, type);
            save([params.feaDir 'depthFea_CKM.mat'], 'depthFea', '-v7.3');
            clear depthFea
            end
        case 3 % normal
            disp('extract normalFea_CRNN')
 	    if exist([params.feaDir 'normalFea_CKM.mat'],'file')
            else
            normalFea = extractFeatures(rgbd_imPath, rgbd_dePath, dictionaries, params, type);
            save([params.feaDir 'normalFea_CKM.mat'], 'normalFea', '-v7.3');
            clear normalFea
            end
    end
end
if matlabpool('size') ~= 0
    matlabpool close;
end
