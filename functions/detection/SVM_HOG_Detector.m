function boundingBoxes = SVM_HOG_Detector(image, model)
    
addpath('SVM-KM')

    [imgHeight, imgWidth] = size(image);
    
    boxHeight = 27; % width and height of bounding box
    boxWidth = 18;

    boxIdx = 1;     % bounding boxes indexes
    stepSize = 1;   % iteration step
    % crop image at every box location
    for y=1:stepSize:imgHeight-boxHeight
        for x=1:stepSize:imgWidth-boxWidth

            % crop the image and apply hog feature extraction
            croppedImage = image(y:boxHeight+y, x:boxWidth+x);
            hog = hog_feature_vector(croppedImage);
            
            % get prediction and confidence score for cropped image
            [prediction, confidenceScore] = SVMTesting(hog, model);
            
            if (prediction == 1) 
                % create bounding box for detected face 
                boundingBoxes(boxIdx, 1) = x;
                boundingBoxes(boxIdx, 2) = y;
                boundingBoxes(boxIdx, 3) = x + boxWidth;
                boundingBoxes(boxIdx, 4) = y + boxHeight;
                boundingBoxes(boxIdx, 5) = confidenceScore;
                boxIdx = boxIdx + 1;
            end
        end
    end
end

