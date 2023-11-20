clear;
clc;

%% main function for calculating MPE
load HBU.mat;
X = HBU;
% IMF in row
X = transpose(X); 
% X is time series, m: number of series, n: length of series
[m,n]=size(X);  

scale = 100;
% pes saves pe value of each series with different scale factor s£¬each row correponds to a series
pes = zeros(scale,m); 
for s=1:scale
    disp('s=');
    disp(s);
    % calculate PE value
    M = 3;  % embedding dimention
    T = 1;  % delay time
    Xcoarse=CoarseGrained(X,s,m,n);
    pe=zeros(1,m);
    for i=1:m
        [pe(i),~] = PermutationEntropy(Xcoarse(i,:),M,T);
    end
    disp(pe);
    pes(s,:)=pe;
end

% Take average on scale factor=1:10
mMPE = transpose(mean(pes(1:10, :)));
    
% Multi-scale PE function
function Xcoarse = CoarseGrained(X,s,m,n)

l = floor(n/s);
Xcoarse = zeros(m,l); % initialization
for i=1:m   
    xi = X(i,:); 
    for j=1:l
        %disp(j);
        %disp(xi((j-1)*s+1:j*s));
        Xcoarse(i,j) = mean(xi((j-1)*s+1:j*s));
    end  
end

end

%% Permutation Entropy Algorithmm
function [pe ,hist] = PermutationEntropy(y,m,t)

%  Calculate the permutation entropy(PE)
%  Proposer of PE£ºBandt C£¬Pompe B. Permutation entropy:a natural complexity measure for time series[J]. Physical Review Letters,2002,88(17):174102.

%  Input:   y: time series;
%           m: order of permuation entropy
%           t: delay time of permuation entropy

% Output: 
%           pe:    permuation entropy
%           hist:  the histogram for the order distribution
ly = length(y);
permlist = perms(1:m);
[h,~]=size(permlist);
c(1:length(permlist))=0;

 for j=1:ly-t*(m-1)
     [~,iv]=sort(y(j:t:j+t*(m-1)));
     for jj=1:h
         if (abs(permlist(jj,:)-iv))==0
             c(jj) = c(jj) + 1 ;
         end
     end
 end
hist = c;
c=c(c~=0);
p = c/sum(c);
pe = -sum(p .* log(p));
% normalization
pe=pe/log(factorial(m));

end


