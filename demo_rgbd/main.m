% written by Liefeng Bo on 03/27/2012 in University of Washington

clear;
if matlabpool('size') == 0
    matlabpool open local 2
end

% add paths
addpath('../liblinear-1.5-dense-float/matlab');
%addpath('~/runCoTrain_RGBD/omp-liblinear/matlab-omp/');
addpath('../helpfun/');
addpath('../kdes');
addpath('../emk');

load('./rgbd_info.mat')
% feature extraction method
%parfor i=1:numel(rgbd_depath)
%    rgbd_depath{i} =rgbd_depath{i};
%end
%-------------------------------------depth image-------------------------------------------%
if ~exist('../kdesfeatures/kernel/rgbdfea_depth_gradkdes.mat', 'file')
    disp('Extracting rgbd_depth_gradkdes')
    rgbd_depth_gradkdes;
end
if ~exist('../kdesfeatures/kernel/rgbdfea_depth_lbpkdes.mat', 'file')
    disp('Extracting rgbd_depth_lbpkdes')
    rgbd_depth_lbpkdes;
end
if ~exist('../kdesfeatures/kernel/rgbdfea_pcloud_sizekdes.mat', 'file')
    disp('Extracting rgbd_pcloud_sizekdes')
    rgbd_pcloud_sizekdes;
end
if ~exist('../kdesfeatures/kernel/rgbdfea_pcloud_normalkdes.mat', 'file')
    disp('Extracting rgbd_pcloud_normalkdes')
    rgbd_pcloud_normalkdes;
end
%-------------------------------------rgb image-------------------------------------------%
%parfor i=1:numel(nyu_impath)
%    nyu_impath{i} = nyu_impath{i};
%end

if ~exist('../kdesfeatures/kernel/rgbdfea_rgb_gradkdes.mat', 'file')
    disp('Extracting rgbd_rgb_gradkdes')
    rgbd_rgb_gradkdes;
end
if ~exist('../kdesfeatures/kernel/rgbdfea_rgb_lbpkdes.mat', 'file')
    disp('Extracting rgbd_rgb_lbpkdes')
    rgbd_rgb_lbpkdes;
end
if ~exist('../kdesfeatures/kernel/rgbdfea_rgb_nrgbkdes.mat', 'file')
    disp('Extracting rgbd_rgb_nrgbkdes')
    rgbd_rgb_nrgbkdes;
end


if matlabpool('size') ~= 0
    matlabpool close
end
