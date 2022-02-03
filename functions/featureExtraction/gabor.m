function [features] = gabor(ImagesIn)
%function that takes in images and returns their gabor feature vectors
features=[];

%apply gabor feature vector function to each image
for idx = 1 : size(ImagesIn,1) % extract 1 image at a time for task
    Iin = uint8(reshape(ImagesIn(idx,:),27,18)); %reshape image back to original size
    feature_vector = gabor_feature_vector(Iin); %feature vector for image
    features = [features;feature_vector]; % append to array for return
end
end
