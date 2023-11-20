%% clear environment
tic;
close all;
clear;
clc;
format compact;

%% load data
X=load('HB-IMF1.txt');
alpha = 2000;
tau = 0;
K = 3;
DC = 0;
init = 1;
tol = 1e-7;
[u, u_hat, omega] = MVMD_new(X, alpha, tau, K, DC, init, tol);
% flip the matrix to make the residual as last column
x11=fliplr(u(:,:,1)'); 
x12=fliplr(u(:,:,2)');