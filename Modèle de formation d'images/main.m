% Spécifier les dimensions de l'image et le rayon du cercle
X = 1195;
Y = 1599;
R = 20;

% Créer l'image avec le cercle blanc à l'intérieur
PSF = create_circle_image(X, Y, R);
barns = imread("barns.jpg");

res = TFconvolution(barns, PSF, 512,512);

imagesc(res)

function res = TFconvolution(im1, im2, lignes, colonnes)
    im1 = double(im1);
    im2 = double(im2);

    [M, N] = size(im1);
    [P, Q] = size(im2);

    taille_lignes = M + P - 1;
    taille_colonnes = N + Q - 1;

    F1 = fft2(im1, taille_lignes, taille_colonnes);
    F2 = fft2(im2, taille_lignes, taille_colonnes);

    convolution = F1 .* F2;

    res = ifft2(convolution);
end

function PSF = create_circle_image(X, Y, R)
    img = zeros(X, Y);

    center_x = floor(X / 2);
    center_y = floor(Y / 2);

    [X_grid, Y_grid] = meshgrid(1:Y, 1:X);

    distances = sqrt((X_grid - center_x).^2 + (Y_grid - center_y).^2);

    img(distances <= R) = 1;
    
    PSF = abs(fftshift(fft2(ifftshift(img)))).^2;
end
