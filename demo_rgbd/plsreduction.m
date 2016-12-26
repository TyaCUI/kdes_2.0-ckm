function  instance_feats = plsreduction(instance_feats, instance_labels, plsncomps)
[xloading,~] = plsregress(instance_feats, instance_labels, plsncomps);
instance_feats = instance_feats * xloading;
%tr_fea_pls = model' * tr_fea;
%ts_fea_pls = model' * ts_fea;
% tr_fea_pls = inv(model'*model)*model' * tr_fea;
% ts_fea_pls = inv(model'*model)*model' * ts_fea;
% [~,~,~,~,~,~,~,stats] = plsregress(tr_fea', label, plsncomps);
% tr_fea_pls = (stats.W)' * tr_fea;
% ts_fea_pls = (stats.W)' * ts_fea;
% tr_fea_pls = inv(stats.W'*stats.W)*stats.W' * tr_fea;
% ts_fea_pls = inv(stats.W'*stats.W)*stats.W' * ts_fea;
% save([fea_path VOCclasses{nClass} '_PLS_model_C_SVC_ave.mat'],
% 'stats.W', '-v7.3');