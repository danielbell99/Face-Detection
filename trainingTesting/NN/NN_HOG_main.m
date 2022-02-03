addpath('src');
addpath('functions/featureExtraction');

IMG_HEIGHT = 27
IMG_WIDTH = 18

% -- Load training images from dataset --
[train_images, train_labels] = loadDataset('face_train.cdataset');

% -- Apply HOG Feature Extractor to training images --
hog_train_images = hog(train_images);

% -- Train the model --
model = NNTraining(hog_train_images, train_labels);

% -- Load testing images from dataset --
[test_images, test_labels] = loadDataset('face_test.cdataset');

figure('Name','Test Images')
for i=1:size(test_images,1)
    test_image = uint8(reshape(test_images(i,:),IMG_HEIGHT,IMG_WIDTH)); %reshape image back to normal size
    subplot(6,10,i), imshow(test_image), title(['Label: ', num2str(test_labels(i))])
end

% -- Apply HOG Feature Extractor to testing images
hog_test_images = hog(test_images)

% -- Test the model --
tic
for i=1:size(test_images,1)
    test_image = hog_test_images(i,:);
    predictions(i,1) = NNTesting(test_image,model);
end
toc

figure
NNEval = Evaluation(test_images, test_labels, predictions, "Nearest Neighbour Classification");
