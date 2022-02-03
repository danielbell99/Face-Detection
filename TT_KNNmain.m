clear all
close all

addpath('src');
addpath('functions/featureExtraction');
addpath('trainingTesting/KNN');

IMG_HEIGHT = 27
IMG_WIDTH = 18

% -- Load training images from dataset --
[train_images, train_labels] = loadDataset('face_train.cdataset')

% -- Brightness Enhancement --
% train_images = brightnessEnhancement(train_images, 5);

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

% -- Train the model --
model = KNNTraining(train_images, train_labels)

% -- Load testing images from dataset --
[test_images, test_labels] = loadDataset('face_test.cdataset')

% figure('Name','Test Images')
% for i=1:size(test_images,1)
%     test_image = uint8(reshape(test_images(i,:),IMG_HEIGHT,IMG_WIDTH)); %reshape image back to normal size
%     subplot(6,10,i), imshow(test_image), title(['Label: ', num2str(test_labels(i))])
% end

% -- Test the model --
k = [1,3, 5, 7, 10];
for i=1:size(k,2)
    tic
    for j=1:size(test_images,1)
        test_image = test_images(j,:);
        predictions(j,1) = KNNTesting(test_image,model,k(i));
    end
    toc
    figure
    fprintf('\nEvaluation for k = %d \n', k(i))
    NNEval = Evaluation(test_images, test_labels, predictions, "Nearest Neighbour Classification");
end

