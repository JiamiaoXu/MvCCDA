function [x_mean, x_var, eig_value, W_pca] = MvPCA(X_multiview)
num_view = size(X_multiview,2);
dim = size(X_multiview{1},1);
x_mean = zeros(dim,num_view,'double');
x_var = zeros(dim,num_view,'double');
eig_value = zeros(dim,num_view,'double');
W_pca = cell(1,num_view);

pca_options.b_unified = 0;
if pca_options.b_unified == 1
    X_Train_pca = [];
    for i=1:num_view
        X_Train_pca = [X_Train_pca X_multiview{i}];
    end
    [x_mean_i x_var_i W_pca_i eig_value_i] = PCA(X_Train_pca);
    for i=1:num_view
        x_mean(:,i) = x_mean_i;
        x_var(:,i) = x_var_i;
        eig_value(1:length(eig_value_i),i) = eig_value_i;
        W_pca{i} = W_pca_i;
    end
else
    for i=1:num_view
        [x_mean_i x_var_i W_pca_i eig_value_i] = PCA(X_multiview{i});
        x_mean(:,i) = x_mean_i;
        x_var(:,i) = x_var_i;
        eig_value(1:length(eig_value_i),i) = eig_value_i;
        W_pca{i} = W_pca_i;
    end
end
