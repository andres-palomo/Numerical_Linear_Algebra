clc
clear

grayA = imresize(double(rgb2gray(imread('schwebebahn','jpg'))), [240 160]);
cmap_gray = gray(256);

drops = [75 50 25];

figure
subplot(1, 4, 1)
show_matrix(grayA, cmap_gray)
title('Original')

for k = 1:3
    B = svd_compress(grayA, drops(k));
    subplot(1, 4, k+1)
    show_matrix(B, cmap_gray)
    title(sprintf('%d%% of singular values dropped', drops(k)))
end

function show_matrix(M, cmap)
    pcolor(M);
    shading interp;
    colormap(cmap);
    axis ij      % pcolor puts row 1 at the bottom; this flips it so the image is not upside down
    axis image   % keep correct aspect ratio
    axis off
end

