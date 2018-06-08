detectionFile = '.\testData\CF647 KRas_8.txt';

outputFolder = '.\output';

FramesToSim = 10; % Truncate to this many frames maximum.  Good for testing.
                  % Set to 'inf' to do all

% Noise and gain characteristics
% Can be found or imported from experimental metadata
% These reasonable for an EMCCD
noise.CamOffset = 100;
noise.ReadNoiseRMS = 0.1;
noise.EMNoise = 1.4;
noise.DarkCurrent = 0.00025;
noise.SpuriousBackground = 0.005;
noise.OnChipGain = 200;
noise.QE = 0.85;
noise.NominalExTime = 0.05; % sec

% End of user-set parameters
%-----------------------------------------------------------------------%
data = Import1File(detectionFile);

% Truncate
dt = data.Data;
dt(dt(:,2) > FramesToSim,:) = [];

nFrames = max(dt(:,2));

imgStack = zeros(data.Footer{2}(5)*data.Footer{2}(3), data.Footer{2}(6)*data.Footer{2}(4), nFrames);

% Generate 'pure' frames at proper spacing, but no noise
% Stack in units of pixels x pixels x frames
% Amplitude in pixels
for k = 1:nFrames
    
    imgStack(:,:,k) = makeFrame(dt(dt(:,2) == k, :), data.Footer);
    
end

% Add noise into these frames
for k = 1:nFrames
    
   imgStack(:,:,k) = addNoiseToFrame(imgStack(:,:,k), noise);
    
end

% Write images to folder
leadingZeros = num2str(ceil(log10(max(data.Data(:,2)))));
for k = 1:nFrames
    
    fmtStr = strcat('%0', leadingZeros, 'd');
    writeName = sprintf(sprintf('img_%s.tif', fmtStr), k);
    imwrite(uint16(imgStack(:,:,k)), fullfile(outputFolder, writeName), 'TIFF');
    
end


