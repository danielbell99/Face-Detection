function [eigenVectors, eigenvalues, meanX, Xpca] = PrincipalComponentAnalysis(X, ndim)
% X - Training dataset (no. Samples x no. Features)
% ndim - no. dimensions requested

% Mean sample
meanX = mean(X);

% Subtract Mean from each sample
A = X - mean(X);

% Scatter Matrix - covariance
S = cov(A);


[eigenVectors, D] = eig(S); % EigenVector
eigenvalues = diag(D); % EigenValue

% Descending order
eigenvalues = eigenvalues(end:-1:1);
eigenVectors = fliplr(eigenVectors);


if nargin < 2
    % if - no. Dimensions isn't reqested
    % then - evaluate the no. PCs needed to represent 95% Total Variance
    
    eigsum = cumsum(eigenvalues);
    eigsum = eigsum / eigsum(end);
    
    index = find(eigsum >= 0.95); % consider those of >= 95% Varience
    ndim = index(1);
    
end

% Return
eigenVectors = eigenVectors(:,1:ndim); % Optimal no. dimensions
eigenvalues = eigenvalues(1:ndim); % Highest lot of EignValues

% Transform data to the PCA space
Xpca = A * eigenVectors;

end