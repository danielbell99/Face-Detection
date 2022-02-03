clear all
close all

addpath('src');
addpath('functions/featureExtraction');
addpath('trainingTesting/SVM')
addpath('functions/detection');
addpath('functions/SVM-KM')

% -- Load training images from dataset --
[train_images, train_labels] = loadDataset('face_train.cdataset');

%enhance contrast to images and add to training dataset
for i=1:size(train_images,1)
    test_image = uint8(reshape(train_images(i,:),27,18)); %reshape image back to normal size
    %test_image = enhanceContrastPL(test_image,10);
    test_image = imadjust(test_image);
    vector = reshape(test_image,[1, size(test_image, 1) * size(test_image, 2)]);
    vector = double(vector);
    train_images(i+188,:) = vector;
    train_labels(i+188) = train_labels(i);
end

hog_features = hog(train_images)

% -- Train the model --
model = SVMTraining(hog_features, train_labels);

% -- Load testing images --
test_images{1} = imread('images/im1.jpg');
test_images{2} = imread('images/im2.jpg');
test_images{3} = imread('images/im3.jpg');
test_images{4} = imread('images/im4.jpg');

for i=1:length(test_images)
    
    figure
    thisImg = cell2mat(test_images(i));
    thisImg = adapthisteq(thisImg);
    imshow(thisImg);
    
    tic
    boxes = SVM_HOG_Detector(thisImg, model);   % get bounding boxes for image     
    boxes = nonMaximaSuspression(boxes, 0.1);   % discard excess bounding boxes
    
    % display bounding boxes on the image
    for i = 1:size(boxes, 1) 
        rectangle('Position', [boxes(i, 1), boxes(i, 2), boxes(i, 3) - boxes(i, 1), boxes(i, 4) - boxes(i, 2)], 'LineWidth', 2, 'EdgeColor', 'magenta');
    end
    toc
   
end

