function frame = makeFrame(dt, Footer)

img = zeros(Footer{2}(5)*Footer{2}(3), Footer{2}(6)*Footer{2}(4));

% Convert photons and PSF width to amplitude
% integral{-inf, inf) of A * e^(-x^2 / sigma^2) dx = A * sigma * sqrt(pi) 
% A = Nphotons / (psfSigma * sqrt(pi))
gaussAmp = dt(:,8)./(((dt(:,11)/Footer{2}(1)/1000) * sqrt(pi)));

x_yInPix = dt(:,5:6)/Footer{2}(1)/1000; % Assume square pixels, convert to um

% Add in each point detected here in series
for k = 1:size(dt, 1)
    
    img = img + gauss_2D([gaussAmp(k), x_yInPix(k,:), dt(k, 11)/Footer{2}(1)/1000, dt(k, 11)/Footer{2}(1)/1000, 0], ...
                            0:255);                 
end

frame = img;
    
    
