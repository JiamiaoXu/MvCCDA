function [Tr_data, Va_data] = preprocessing(Tr_data, Va_data, pca_dim)

    [x_mean x_var eig_value W_pca] = MvPCA(Tr_data);
    Tr_data = MvPCA_Projection(Tr_data, x_mean, x_var, W_pca, pca_dim);
    Va_data = MvPCA_Projection(Va_data, x_mean, x_var, W_pca, pca_dim);
    
end