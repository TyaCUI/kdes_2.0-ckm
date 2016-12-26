clc;clear;

imdir='../images/rgbdsubset';
[imlabel,impath]=get_im_label2(imdir);
num=1;
%rgbd_label={};
%rgbd_impath={};
%rgbd_depath={};
for i=1:length(impath)
    if strcmp(impath{i}(end-2:end),'txt')
        rgbd_label{num}=load(impath{i});
        num=num+1;
    else if strcmp(impath{i}(end-8),'_')
            rgbd_impath{num}=impath{i};
        else if strcmp(impath{i}(end-8),'h')
                rgbd_depath{num}=impath{i};
            end
        end
    end   
end
save('rgbd_info.mat','rgbd_impath','rgbd_depath','rgbd_label');
disp('Done.');
