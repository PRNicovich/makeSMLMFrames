function noisedFrame = addNoiseToFrame(img, noise)

% Roughly following EMCCD simple model from here:
% https://arxiv.org/pdf/1506.07929.pdf

% Shot noise on photons/pixel
img = poissrnd(img);

% Convert to photoelectrons
img = (img/noise.QE);

% Dark current from e-/pixel/sec to e-
darkCurrentNoise = (noise.DarkCurrent*noise.NominalExTime)*ones(size(img, 1), size(img, 2));
    
% Spurious noise (clock-induced charge) from e-/pixel to e-
spuriousNoise = noise.SpuriousBackground*ones(size(img, 1), size(img, 2));
    
% Readout Noise
readoutNoise = noise.ReadNoiseRMS*ones(size(img, 1), size(img, 2));

totalNoise = poissrnd(darkCurrentNoise + spuriousNoise + readoutNoise);

% Total noise for EMCCD includes noise from gain register
noisedFrame = poissrnd(noise.OnChipGain*(totalNoise + img) + noise.CamOffset);

% Note - for sCMOS this would be something like:
% noisedFrame = totalNoise + peakSignal


