function fea = extractFeatures(imPath, dePath, centroids, params, type)
%%%%%%%%%%%%%%%%%%%%%%%%%
%   Description:
%   extract CKM features
%  
%
numCentroids = size(centroids,1);

% compute features for each image
fea = zeros(length(imPath), numCentroids*sum(params.pyramids.^2));
parfor imIdx=1:length(imPath) 
    if (mod(imIdx,100) == 0) 
        fprintf('Extracting features: %d / %d\n', imIdx, length(imPath)); 
    end
    switch type
        case 0 
            img = imread([imPath{imIdx}]);
            img = double(imresize(img, params.setImgSize));
        case 1
            img = imread([imPath{imIdx}]);
            img = rgb2gray(img);
            img = double(imresize(img, params.setImgSize));
        case 2
            img = swapbytes(imread([dePath{imIdx}]));
            img = double(imresize(img, params.setImgSize));
        case 3
            img = depthtonormal([dePath{imIdx}]);
            img = double(imresize(img, params.setImgSize));
    end 

    % get all possible patches
    patches = [];
    for ch = 1:size(img,3)
        patches = [patches; im2col(img(:,:,ch), [params.rfSize params.rfSize])];
    end
    patches = double(patches');    

    % normalize for contrast
    patches = bsxfun(@minus, patches, params.whiten.M) * params.whiten.P;

    % compute 'triangle' activation function
    xx = sum(patches.^2, 2);
    cc = sum(centroids.^2, 2)';
    xc = patches * centroids';

    z = sqrt( bsxfun(@plus, cc, bsxfun(@minus, xx, 2*xc)) ); % distances
    [v,inds] = min(z,[],2);
    mu = mean(z, 2); % average distance to centroids for each patch
    patches = max(bsxfun(@minus, mu, z), 0);
    % patches is now the data matrix of activations for each patch

    % reshape to numCentroids-channel image
    prows = params.setImgSize(1)-params.rfSize+1;
    pcols = params.setImgSize(2)-params.rfSize+1;
    patches = reshape(patches, prows, pcols, numCentroids);

    % pool over quadrants
    q = [];
    for pyramid = params.pyramids
        len_r = round(prows/pyramid);
        len_c = round(pcols/pyramid);         
        for c_cell = 1:pyramid
            for r_cell = 1:pyramid
                q_tmp = sum(sum(patches((r_cell-1)*len_r+1:min(r_cell*len_r, prows), (c_cell-1)*len_c+1:min(c_cell*len_c, pcols), :), 1),2);
                q = [q q_tmp(:)'];
            end
        end
    end
    % concatenate into feature vector
    fea(imIdx,:) = q;
end
fea_mean = mean(fea);
fea_sd = sqrt(var(fea)+0.01);
fea = bsxfun(@rdivide, bsxfun(@minus, fea, fea_mean), fea_sd);
%scale the features, also can try 'power'
%fea = scaleFea(fea, 'linear'); 
%fea = sparse(fea);


