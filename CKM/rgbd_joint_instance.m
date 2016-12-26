clear;

% add paths
addpath('../liblinear-1.5-dense-float/matlab');
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

instance = 1;
if instance

   % generate training and test indexes
   indextrain = 1:length(rgbdILabel);
   indextest = find(rgbdVLabel == 2);
   indextrain(indextest) = [];

   % generate training and test samples
   load rgbdfea_joint;
   trainfea = rgbdfea_joint(:, indextrain);
   trainlabel = rgbdILabel(:, indextrain);
   clear rgbdfea_joint;

   disp('Performing liblinear ... ...');
   [trainfea, minvalue, maxvalue] = scaletrain(trainfea, 'power');
   lc = 10;
   % classify with liblinear
   option = ['-s 1 -c ' num2str(lc)];
   model = train(trainlabel',trainfea',option);
   load rgbdfea_joint;
   testfea = rgbdfea_joint(:, indextest);
   testlabel = rgbdILabel(:, indextest);
   clear rgbdfea_joint;
   testfea = scaletest(testfea, 'power', minvalue, maxvalue);
   [predictlabel, accuracy, decvalues] = predict(testlabel', testfea', model);
   acc_i = mean(predictlabel == testlabel');
   save('./results/joint_acc_i.mat', 'acc_i', 'predictlabel', 'testlabel');

   % print and save classification accuracy
   disp(['Accuracy of Liblinear is ' num2str(mean(acc_i))]);
end


