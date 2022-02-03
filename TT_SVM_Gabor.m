addpath('data')
addpath('functions/featureExtraction');
addpath('Images/face')
addpath('Images/non-face')
addpath('src')
addpath('functions/SVM-KM')
addpath('trainingTesting/SVM');

IMG_HEIGHT = 27
IMG_WIDTH = 18

%% Train Gabor
[train_images, train_labels]=loadDataset('face_train.cdataset');

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

trainGabor=gabor(train_images);
trainSVM=SVMTraining(trainGabor, train_labels);

%% Test Gabor
[testImages, testLabels] = loadDataset('face_test.cdataset');
figure('Name','Test Images')
for i=1:size(testImages,1)
    testImage = uint8(reshape(testImages(i,:),IMG_HEIGHT,IMG_WIDTH)); %reshape image back to normal size
    subplot(6,10,i), imshow(testImage), title(['Label: ', num2str(testLabels(i))]);
end

tic
testGabor=gabor(testImages);
for i=1:size(testImages,1)
    test_image = testGabor(i,:);
    predictions(i,1)=SVMTesting(test_image,trainSVM);
end
toc

figure
SVMResult=Evaluation(testImages, testLabels, predictions, 'SVM Classification');
