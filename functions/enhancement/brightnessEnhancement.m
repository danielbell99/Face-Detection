% BRIGHTNESS ENHANCEMENT

function [ImagesOut] = brightnessEnhancement(ImagesIn, c)
% Transfer & Wrap-around function, calls upon enhanceBrightness() per image
% Increase (c > 0) or decrease (c < 0)
% Iinimages - array of n images for task
% c - constant for all pixel values to be recalculated (intersection of y-axis)

ImagesOut = []; % stores enhanced images
% -- Image Extraction --
for idx = 1 : 18 : length(ImagesIn) % extract 1 image at a time for task
    Iin = ImagesIn(:,idx:(idx+17)); % image = 18 cols
    ImagesOut = [ImagesOut, enhanceBrightness(Iin, c)]; % append to array for return
    % imshow(Iin)
end
testBrightnessEnhancement(ImagesIn(:,1:18)) % 1st original face/nonFace image
end

function Lut = brightnessLUT(c)
% Matlab is 1-indexed (ie. 255 + 1 = Lut 256 elements)
Lut = [1:256] + c;
Lut = uint8(Lut); % ensure Look-up table is same datatype (imposes 256 upperbound)
end

function Iout = enhanceBrightness(Iin,c)
Lut = brightnessLUT(c);
Iin = uint8(Iin); % enforces matrix as int8
Iout = intlut(Iin,Lut);
end

function testBrightnessEnhancement(img)
% Compares sample original photo to post-processing
figure
subplot(1,5,1), imshow(img)
subplot(1,5,2), plot(brightnessLUT(50))
subplot(1,5,3), imshow(enhanceBrightness(img,50))
subplot(1,5,4), histogram(enhanceBrightness(img,50), 'BinLimits', [0 256], 'BinWidth', 1)
end