function modelNN = NNTraining(ImagesIn, labels)
    modelNN.neighbours = ImagesIn; % Assigns each processed image as new Neighbour
    modelNN.labels = labels; % Assigns each output label to respective Neighbours
end