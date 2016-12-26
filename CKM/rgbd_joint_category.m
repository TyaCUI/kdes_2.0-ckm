clear;

% add paths
addpath('../liblinear-1.5-dense/matlab');
addpath('../helpfun');
addpath('../kdes');
addpath('../emk');
addpath('../kdesfeatures/ckm');
load rgbd_info.mat
% combine all kernel descriptors
rgbdfea_joint = [];
load rgbFea_CKM.mat;
rgbdfea_joint = [rgbdfea_joint; rgbFea'];
load grayFea_CKM.mat;
rgbdfea_joint = [rgbdfea_joint; grayFea'];
load depthFea_CKM.mat;
rgbdfea_joint = [rgbdfea_joint; depthFea'];
load normalFea_CKM.mat;
rgbdfea_joint = [rgbdfea_joint; normalFea'];
save -v7.3 rgbdfea_joint rgbdfea_joint rgbdCLabel rgbdILabel rgbdVLabel;

category = 1;
if category
   trail = 5;
   for i = 1:trail
       % generate training and test samples
       ttrainindex = [];
       ttestindex = [];
       labelnum = unique(rgbdCLabel);
       for j = 1:length(labelnum)
           trainindex = find(rgbdCLabel == labelnum(j));
           rgbdILabel_unique = unique(rgbdILabel(trainindex));
           perm = randperm(length(rgbdILabel_unique));
           subindex = find(rgbdILabel(trainindex) == rgbdILabel_unique(perm(1)));
           testindex = trainindex(subindex);
           trainindex(subindex) = [];
           ttrainindex = [ttrainindex trainindex];
           ttestindex = [ttestindex testindex];
       end
       load rgbdfea_joint;
       trainfea = rgbdfea_joint(:,ttrainindex);
       clear rgbdfea_joint;
%       save('trainfea_before.mat','trainfea');
       [trainfea, minvalue, maxvalue] = scaletrain(trainfea, 'power'); 
       trainlabel = rgbdCLabel(ttrainindex); % take category label

       % classify with liblinear
       lc = 10;
       option = ['-s 1 -c ' num2str(lc)];
%       save('trainfea.mat','trainfea','trainlabel','option');
       model = train(trainlabel',trainfea',option);
       load rgbdfea_joint;
       testfea = rgbdfea_joint(:,ttestindex);
       clear rgbdfea_joint;
       testfea = scaletest(testfea, 'power', minvalue, maxvalue);
       testlabel = rgbdCLabel(ttestindex); % take category label
       [predictlabel, accuracy, decvalues] = predict(testlabel', testfea', model);
      
       acc_c(i,1) = mean(predictlabel == testlabel');
       save('./results/joint_acc_c.mat', 'acc_c', 'predictlabel', 'testlabel');

       % print and save results
       disp(['Accuracy of Liblinear is ' num2str(mean(acc_c))]);
   end
end

