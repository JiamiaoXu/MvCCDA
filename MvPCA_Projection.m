function [Y]= MvPCA_Projection(X,x_mean, x_var, W_pca, pca_dim)%pca_dim,b_engergy,energy_ratio)
num_view = size(x_mean,2);
Y = cell(1,num_view);

for i=1:num_view
    x_mean_i = x_mean(:,i);
    x_var_i = x_var(:,i);
    W_pca_i = W_pca{i};
    W_pca{i} = W_pca_i(:,1:pca_dim);
    Y{i} = (W_pca{i})'*ZeroMeanOneVar(X{i},x_mean_i,x_var_i);
end