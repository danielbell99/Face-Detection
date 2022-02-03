addpath('data')
addpath('functions/featureExtraction');
addpath('Images/face')
addpath('Images/non-face')
addpath('src')
addpath('functions/SVM-KM')
addpath('trainingTesting/SVM');

IMG_HEIGHT=27;
IMG_WIDTH=18;


%% Train HOG
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

trainHOG=hog(train_images);
trainSVM=SVMTraining(trainHOG, train_labels);

%% Test HOG
[testingImages,testingLabels]=loadDataset('face_test.cdataset');

figure('Name','Test Images')
for i=1:size(testingImages,1)
    testImage = uint8(reshape(testingImages(i,:),IMG_HEIGHT,IMG_WIDTH)); %reshape image back to normal size
    subplot(6,10,i), imshow(testImage), title(['Label: ', num2str(testingLabels(i))])
end

testHOG=hog(testingImages);
numImages=size(testHOG,1);
result=zeros(numImages,1);
tic
for i=1:numImages
    Image=testHOG(i,:);
    result(i)=SVMTesting(Image,trainSVM);
end
toc

figure
SVMResult = Evaluation(testingImages, testingLabels, result, "SVM Classification");
