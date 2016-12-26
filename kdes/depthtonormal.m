function normal = depthtonormal(depthpath)
% Convert depth values to surface normals
% Written by Liefeng Bo on March 2012

normalpath = [depthpath(1:end-13) 'normal.mat'];

if exist(normalpath, 'file')
    % directly load surface normals
    load(normalpath);
else
    %% compute surface normals on the fly
    im = imread(depthpath);
    im = double(im);
    topleft = fliplr(load([depthpath(1:end-13) 'loc.txt']));
    pcloud = depthtocloud(im, topleft);
    pcloud = pcloud/1000; % normalized to meter
    normal = pcnormal(pcloud);
    save(normalpath, 'normal');
end

