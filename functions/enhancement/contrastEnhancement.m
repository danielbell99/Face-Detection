% CONTRAST ENHANCEMENT USING POWER LAW

% Power Law Transfer Function:
% output_value = (short)[(input_value)^γ / 255^γ-1]

function [ImagesOut] = contrastEnhancement(ImagesIn,gamma)
% Transfer & Wrap-around function, calls upon enhanceBrightness() per image
% Iinimages - array of n images for task

ImagesOut = []; % stores enhanced images
% -- Image Extraction --
for idx = 1 : 18 : length(ImagesIn) % extract 1 image at a time for task
    Iin = ImagesIn(:,idx:(idx+17)); % image = 18 cols
    ImagesOut = [ImagesOut, enhanceContrastPL(Iin, gamma)]; % append to array for return
    % imshow(Iin)
end
testContrastEnhancement(ImagesIn(:,1:18)) % 1st original face/nonFace image
end

function Iout = enhanceContrastPL(Iin,gamma)
Iin = uint8(Iin);
Iout = intlut(Iin, contrast_PL_LUT(gamma));
end

function Lut = contrast_PL_LUT(gamma)
Lut = [1:256]; % gamma = 1 | no change
if gamma > 1 || gamma < 1
    for i = 1:256
        Lut(i) = i.^gamma / 255.^(gamma-1); % Transfer function
    end
end
Lut = uint8(Lut); % imposes 256 upperbound
end

function testContrastEnhancement(img)
% Compares sample original photo to post-processing
subplot(2,4,1), imshow(img)
subplot(2,4,2), plot(contrast_PL_LUT(2)) % darker
subplot(2,4,3), imshow(enhanceContrastPL(img,2))
subplot(2,4,4), histogram(enhanceContrastPL(img,2), 'BinLimits', [0 256], 'BinWidth', 1)
end