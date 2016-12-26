% initialize the parameters of kdes
kdes_params.grid = 8;   % kdes is extracted every 8 pixels
kdes_params.patchsize = 16;  % patch size
load('../kdes/lbpkdes_dep_params');
kdes_params.kdes = lbpkdes_dep_params;

% initialize the parameters of data
data_params.datapath = rgbd_depath;
data_params.tag = 1;
data_params.minsize = 45;  % minimum size of image
data_params.maxsize = 300; % maximum size of image
data_params.savedir = ['../kdesfeatures/kernel/rgbd' 'lbpkdes_dep'];
data_params.root_savedir = '../kdesfeatures/kernel/';

% extract kernel descriptors
mkdir_bo(data_params.savedir);
rgbdkdespath = get_kdes_path(data_params.savedir);
if ~length(rgbdkdespath)
   gen_kdes_batch(data_params, kdes_params);
   rgbdkdespath = get_kdes_path(data_params.savedir);
end

featag = 1;
if featag
   % learn visual words using K-means
   % initialize the parameters of basis vectors
   basis_params.samplenum = 20; % maximum sample number per image scale
   basis_params.wordnum = 1000; % number of visual words
   fea_params.feapath = rgbdkdespath;
   rgbdwords = visualwords(fea_params, basis_params);
   basis_params.basis = rgbdwords;

   % constrained kernel SVD coding
   disp('Extract image features ... ...');
   % initialize the params of emk
   emk_params.pyramid = [1 2 3];
   emk_params.ktype = 'rbf';
   emk_params.kparam = 0.1;
   fea_params.feapath = rgbdkdespath;
   rgbdfea = cksvd_emk_batch(fea_params, basis_params, emk_params);      
   save([data_params.root_savedir 'rgbdfea_depth_lbpkdes'], 'rgbdfea', '-v7.3');
else
   load([data_params.root_savedir 'rgbdfea_depth_lbpkdes']);
end
