function prediction = KNNTesting(ImageTest, modelNN, k)
    
    dataset = modelNN.neighbours; % get trainImages
    
    % Obtaining EuclindeanDistance for each TrainImage and TestImage
    for i=1:size(dataset,1) 
        distance(i) = EuclideanDistance(ImageTest, modelNN.neighbours(i));
    end
    
    predictions = [];
    for i=1:k
        [val, idx] = min(distance);
        distance(idx) = [];
        pred = modelNN.labels(idx);
        predictions = [predictions; pred];
    end
    
    prediction = mode(predictions);
       
end