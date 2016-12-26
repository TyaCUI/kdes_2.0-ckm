function params = initParams()
%%%%%%%%%%%%%%%%%%%%%%%%%
%   Description:
%   initialize some parameters of CKM
%

params.dataDir = '';%'/Data3/NYU_Depth_V1/for_classification/';
params.datasetDir = '../images/rgbdsubset/';%'/Data3/NYU_Depth_V1/clips/';
params.feaDir = '../kdesfeatures/ckm/';

params.rfSize = 16; % size of sample patches 
params.numFilters=1000 %1000; % codebook
params.numPatches =5000%400000;  % total num. of sample patches
params.setImgSize=[240 320]; % rescale all the images
params.pyramids = [1 2 3]; % 1x1 2x2 3x3, pyramids of bow model
