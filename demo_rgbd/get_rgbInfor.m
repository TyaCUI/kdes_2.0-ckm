function impath = get_rgbInfor(impath)
% change depth impath to rgb impath
parfor i = 1:length(impath)
    tmp_path = impath{i};
    tmp_path(end-12:end-8) = [];
    impath{i}= tmp_path;
end
end

