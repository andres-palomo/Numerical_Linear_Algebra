clear; clc; close all;

n = 80;
[U,X] = qr(randn(n));
[V,X] = qr(randn(n));
S=diag(2.^(-1:-1:-n));
A = U*S*V;
[Qc, Rc] = CSG(A);
[Qm, Rm] = MSG(A);

figure;
semilogy(diag(Rc), 'r.-'); hold on;
semilogy(diag(Rm), 'b.-');
legend('Classical GS', 'Modified GS');
title('Diagonal entries of R'); grid on;

function [Q,R] = CSG(A)
    m = size(A,1);
    n = size(A,2);
    Q = zeros(m,n);
    V = zeros(m,n);
    R = zeros(n,n);
    Q(:,1) = A(:,1)/norm(A(:,1));
    for j = 1:n
        V(:,j) = A(:,j);
        for i = 1:j-1
            R(i,j) = Q(:,i)' * A(:,j);
            V(:,j) = V(:,j) - R(i,j) * Q(:,i);
        end
        R(j,j) = norm(V(:,j));
        Q(:,j) = V(:,j) / R(j,j);
    end
end

function [Q,R] = MSG(A)
    m = size(A,1);
    n = size(A,2);
    Q = zeros(m,n);
    V = zeros(m,n);
    R = zeros(n,n);
    Q(:,1) = A(:,1)/norm(A(:,1));
    for j = 1:n
        V(:,j) = A(:,j);
        for i = 1:j-1
            R(i,j) = Q(:,i)' * V(:,j);
            V(:,j) = V(:,j) - R(i,j) * Q(:,i);
        end
        R(j,j) = norm(V(:,j));
        Q(:,j) = V(:,j) / R(j,j);
    end
end 