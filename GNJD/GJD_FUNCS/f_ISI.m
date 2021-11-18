function [ISI,J_ISI] = f_ISI(A,W)
%% Evaluation of results obtained by GJD algorithms
%% Inputs: 
% - A: true loading matrices arranged as A = [A1; A2; A3;...AK]
% - W: estimated unloading matrices arranged as W = [W1; W2; ... WK]
%% Outputs:
% - ISI:   inter-symbol_interference (ISI) for each separate estimate, it
%          takes into account the accurary only
% - J_ISI: joint-ISI taking account of both accuracy and permutation of the
%          estimates
[L,N] = size(A);
K = L/N;
ISI = zeros(K,1);
A = permute(reshape(A,[N,K,N]),[1,3,2]); 
W = permute(reshape(W,[N,K,N]),[1,3,2]);
abs_G_2 = zeros(N,N);
for kk = 1:K
    temp_A = A(:,:,kk);     
    temp_W = W(:,:,kk);
    G = temp_W * temp_A;
    abs_G = abs(G);
    abs_G_2 = abs_G_2 + abs_G;
    term_1 = abs_G./repmat(max(abs_G,[],2),[1,N]);
    term_1 = sum(sum(term_1,2) - ones(N,1));
    term_2 = abs_G./repmat(max(abs_G,[],1),[N,1]);
    term_2 = sum(sum(term_2,1) - ones(1,N));
    ISI(kk) = (term_1 + term_2)/(2*N*(N-1));    
end
term_1 = abs_G_2./repmat(max(abs_G_2,[],2),[1,N]);
term_1 = sum(sum(term_1,2) - ones(N,1));
term_2 = abs_G_2./repmat(max(abs_G_2,[],1),[N,1]);
term_2 = sum(sum(term_2,1) - ones(1,N));
J_ISI = (term_1 + term_2)/(2*N*(N-1));