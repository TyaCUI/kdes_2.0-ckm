 
This MATLAB package implements kernel descriptors proposed in [1-2] and Convolutional K-means Descriptor in [3].

download rgb-d dataset and put it in images folder and change the name as "rgbdsubset".

1. To run kernel descriptor for rgb-d:
	1) cd demo_rgbd
	2) run initDatabase.m to generate rgbd_info.mat
	3) run main.m to generate features
	4) run rgbd_joint_category.m to train and  test the category detection results; run rgbd_joint_instance.m to train and test the instance detection results; run test_svm_classification to test a certain feature.
	5) the results is in the results folder; the features are in kdesfeatures/kernel.

2. To run CKM for rgb-d:
	1) cd CKM
	2) run runCKM.m
	3) run rgbd_joint_category.m to train and  test the category detection results; run rgbd_joint_instance.m to train and test the instance detection results; run test_svm_classification to test a certain feature.
	4) the results is in the results folder; the features are in kdesfeature
s/kernel.

[1] Liefeng Bo, Xiaofeng Ren and Dieter Fox, Kernel Descriptors for Visual Recognition, Advances in Neural Information Processing Systems (NIPS), 2010.
[2] Liefeng Bo, Xiaofeng Ren and Dieter Fox, Depth Kernel Descriptors for Object Recognition, in IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS), 2011.
[3] M. Blum, J. T. Springenberg, J. Wulfing, M. Riedmiller, A learned feature descriptor for object recognition in rgb-d data, in: ICRA, 2012.


There are 11 directories in the package:

- CKM: Feature extraction and demo scripts to show the usage of CKM for image recognition.
- demo_rgb: Demo scripts to show the usage of kernel descriptors for image recognition.
- demo_rgbd: Demo scripts to show the usage of kernel descriptors for RGB-D object recognition
- emk: Efficient match kernels that generate image/object level features based on kernel descriptors. 
  Please download the emk package from http://www.cs.washington.edu/homes/lfb/software/EMK.htm.
  Copy the subfolder /emk_1.0/emk/ to kdes_2.0/emk/.
- helpfun: Helpful functions such as K-Means and power transformations.
- images: Directory of storing training and test data.
- kdes: Kernel descriptors for RGB and depth images.
- kdesfeatures: CKM and Kdes features.
- liblinear-1.5-dense: Liblinear in the dense format, modified by Xiaofeng Ren.
- liblinear-1.5-dense-float: Liblinear in the dense float format, modified by Xiaofeng Ren.
- lsvm: A Matlab version of linear SVMs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
This software is developed by Liefeng Bo at the University of Washington. Please contact lfb@cs.washington.edu if you found any bugs.

The CKM feature is implemented by Yanhua Cheng at Institue of Automation, Chinese Academy of Sciences.

The following are the links to the datasets used to evaluate kernel descriptors in demos.

-RGBD Object Dataset: assumed to be in images/rgbdsubset
The dataset is available at http://www.cs.washington.edu/rgbd-dataset

-Bird200: assumed to be in images/bird200
The dataset is available at http://vision.caltech.edu/visipedia/CUB-200.html

-Caltech101: assumed to be in images/caltech101
The dataset is available at http://vision.stanford.edu/resources_links.html

-Cifar10: assumed to be in images/cifar10
The dataset is available at http://www.cs.toronto.edu/~kriz/cifar.html

-Extended Yaleface: assumed to be in images/yaleface38
The dataset is available at http://vision.ucsd.edu/~leekc/ExtYaleDatabase/ExtYaleB.html

-USPS: assumed to be in images/usps
The dataset is available at http://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets

-Scene15: assumed to be in images/scene15
The dataset is available at http://www.cs.unc.edu/~lazebnik

-UIUC-Sports: assumed to be in images/sports
The dataset is available at http://vision.stanford.edu/lijiali/event_dataset


