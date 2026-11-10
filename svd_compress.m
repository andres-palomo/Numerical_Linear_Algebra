function compressedA = svd_compress(A, drop_percentage)
    [U, S, V] = svd(A, 'econ');
    r = size(S, 1);
    numToDrop = floor(r * drop_percentage / 100);
    retainedRank = max(1, r - numToDrop);
    compressedA = U(:, 1:retainedRank) * S(1:retainedRank, 1:retainedRank) * V(:, 1:retainedRank)';
end