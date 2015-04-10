function [ data_proj, base, base_energy] = m_pca(data)
%M_PCA Summary of this function goes here
%   Detailed explanation goes here

%if size(data,2) < size(data,1), data = data'; end

[COEFF, SCORE, LATENT] = princomp(data);
%[COEFF, SCORE, LATENT] = pca(data);

base = COEFF;
data_proj = SCORE;
base_energy = LATENT;

end

