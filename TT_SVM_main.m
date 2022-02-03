clear all
close all

addpath('src');
addpath('functions/featureExtraction');
addpath('functions/enhancement');
addpath('functions/SVM-KM');
addpath('trainingTesting/SVM');

IMG_HEIGHT=27;
IMG_WIDTH=18;

% -- Load training images from dataset --
[train_images, train_labels]=loadDataset('face_train.cdataset');

%% PRE-PROCESSING

% -- Brightness Enhancement --
%train_images = brightnessEnhancement(train_images, 5); % images overwritten by brightness enhancement versions

% -- Contrast Enhancement --
train_images = contrastEnhancement(train_images, 2);

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

%%
% PCA (always done before Training NN)
%[eigenVectors, eigenvalues, meanX, Xpca]=PrincipalComponentAnalysis(trainImages, 2);


eigVector_index = 2;
h = 64;
w = 64;

%weights = [-3*sqrt(eigenvalues(eigVector_index)), 6*sqrt(eigenvalues(eigVector_index))/200: 3*sqrt(eigenvalues(eigVector_index))];

%disp('Number of Elements')
%meanX=reshape(meanX,[],1); % Merge all data into one column
%numel(meanX)
%numel(h)
%numel(w)

% ERROR w/ reshape()
% figure
% for b=weights
%     faceReconstruct = meanX + b*eigenVectors(:,eigVector_index)';
%     faceReconstructImage = reshape(faceReconstruct,[h w]);
%     imagesc(faceReconstructImage), colormap(gray), axis equal, axis off, drawnow
% end


% -- Train the model --
model=SVMTraining(train_images, train_labels);

% -- Load testing images from dataset --
[testImages, testLabels]=loadDataset('face_test.cdataset');

figure('Name','Test Images')
for i=1:size(testImages,1)
    test_image = uint8(reshape(testImages(i,:),IMG_HEIGHT,IMG_WIDTH)); %reshape image back to normal size
    subplot(6,10,i), imshow(test_image), title(['Label: ', num2str(testLabels(i))])
end

% -- Test the model --
tic
for i=1:size(testImages,1)
    test_image = testImages(i,:);
    predictions(i,1) = SVMTesting(test_image,model);
end
toc

figure
SVMEval = Evaluation(testImages, testLabels, predictions, "Nearest Neighbour Classification");
