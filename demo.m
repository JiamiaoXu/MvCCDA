clear
clc

%% parameters set
alpha = 2.3849;
lambda1 = 0.6;   
lambda2 = 0.002;    
lambda3 = 0.0005;

sigma = 2000;   % gaussian kernel parameters
dim = 45;       % the dimensionality of subspace (it is equal to the number of classses)
pca_dim = 80;   % PCA dimensions
num_view = 5;   % the number of views£¨or domains£©

%% load data 
data = load('pie.mat');
Tr_data = data.Tr_data;      % training data    
Tr_Labels = data.Tr_Labels;  % the labels of training data
Te_data = data.Te_data;      % test data
Te_Labels = data.Te_Labels;  % the labels of test data
[Tr_data, Te_data] = preprocessing(Tr_data, Te_data, pca_dim);  %Preprocessing via Principal Component Analysis

%% training
[Z, P] = proposed_method(Tr_data, Tr_Labels, alpha, lambda1, lambda2, lambda3, sigma, dim, num_view);%, Te_data, Te_Labels);

%% testing
Y_Test = cell(1, num_view);
for v = 1 : num_view
   Y_Test{v} = P{v}.'* Te_data{v};
end
[accuracy, average]  = testing(Y_Test, Te_Labels);
disp(['The accuracy is ', num2str(average)]);

