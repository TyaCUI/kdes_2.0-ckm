addpath('../liblinear-1.5-dense/matlab');
addpath('../helpfun');
addpath('../kdes');
addpath('../emk');
addpath('../kdesfeatures/kernel');

load rgbd_info.mat
%load('../kdesfeatures/kernel/rgbdfea_depth_gradkdes.mat')
%[pc,score,latent,tsquare] = princomp((full(rgbdfea))');
%rgbdfea = (rgbdfea' * XLOADINGS)';
%rgbdfea = sparse(rgbdfea);
%rgbdfea = plsreduction(full(rgbdfea'), rgbdCLabel', 30);
category = 1;
if category
   trail = 1;
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
       load rgbdfea_depth_lbpkdes;
       trainhmp = rgbdfea(:,ttrainindex);
       clear rgbdfea;
       [trainhmp, minvalue, maxvalue] = scaletrain(trainhmp, 'power');
       trainlabel = rgbdCLabel(ttrainindex); % take category label

       % classify with liblinear
       lc = 10;
       option = ['-q 1 -s 1 -c ' num2str(lc)];
       model = train(trainlabel',trainhmp',option);
       load rgbdfea_depth_lbpkdes;
       testhmp = rgbdfea(:,ttestindex);
       clear rgbdfea;
      % testhmp = rgbdfea(:,ttestindex);       
       testhmp = scaletest(testhmp, 'power', minvalue, maxvalue);
       testlabel = rgbdCLabel(ttestindex); % take category label
       [predictlabel, accuracy, decvalues] = predict(testlabel', testhmp', model);
       acc_c(i,1) = mean(predictlabel == testlabel');
       save('./results/depth_lbpkdes_acc_c.mat', 'acc_c', 'predictlabel', 'testlabel');

       % print and save results
       disp(['Accuracy of Liblinear is ' num2str(mean(acc_c))]);
   end
end

instance = 1;
if instance

   % generate training and test indexes
   indextrain = 1:length(rgbdILabel);
   indextest = find(rgbdVLabel == 2);
   indextrain(indextest) = [];

   % generate training and test samples
   load rgbdfea_depth_lbpkdes;
   trainhmp = rgbdfea(:, indextrain);
   trainlabel = rgbdILabel(:, indextrain);
   clear rgbdfea;
   [trainhmp, minvalue, maxvalue] = scaletrain(trainhmp, 'power');

   disp('Performing liblinear ... ...');
   lc = 10;
   % classify with liblinear
   option = ['-s 1 -c ' num2str(lc)];
   model = train(trainlabel',trainhmp',option);
   load rgbdfea_depth_lbpkdes;
   testhmp = rgbdfea(:, indextest);
   testlabel = rgbdILabel(:, indextest);
   clear rgbdfea;
   testhmp = scaletest(testhmp, 'power', minvalue, maxvalue);
   [predictlabel, accuracy, decvalues] = predict(testlabel', testhmp', model);
   acc_i = mean(predictlabel == testlabel');
   save('./results/depth_lbpkdes_acc_i.mat', 'acc_i', 'predictlabel', 'testlabel');

   % print and save classification accuracy
   disp(['Accuracy of Liblinear is ' num2str(mean(acc_i))]);
end
