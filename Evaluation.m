function [scores] = Evaluation(ImagesIn, labels, predictions, modelName)
    % Wrap-around function    
    [TN, FN, FP, TP] = ConfusionMatrix(labels, predictions);
    scores = modelScores(labels, predictions, TN, FN, FP, TP);
    
    evalClassifications(ImagesIn, labels, predictions, modelName);
end

function [TN, FN, FP, TP] = ConfusionMatrix(labels, predictions)
    % Confusion Matrix
    cm = confusionmat(labels, predictions);
    confusionchart(cm) % Plots the True Class vs. Predicted Class as Matrix

    TN = cm(1,1); % True Negative
    FN = cm(2,1); % False Negative
    FP = cm(1,2); % False Positive
    TP = cm(2,2); % True Positive
end

function scores = modelScores(labels, predictions, TN, FN, FP, TP)

    scores.accuracy = modelAccuracy(labels, predictions);
    scores.precision = TP/(TP + FP);
    scores.recall = TP/(TP + FN);
    scores.specificity = TN/(TN + FP);
    scores.fMeasure = (TP*2)/((TP*2) + FN + FP); % 2*(precision * recall)/(precision + recall)
    scores.falseAlarmRate = 1 - scores.specificity; % FP / (FP+TN);
    
    printScores(scores);
end

function accuracy = modelAccuracy(labels, predictions)
    numImages = length(predictions);
    comparison = (labels == predictions); % how many were correctly classified vs. falsely classified
    accuracy = sum(comparison)/numImages;
end

function printScores(scores)
    % Prints Evaluations in Command Window
    fprintf('Accuracy Score: %.2f%%\n', (scores.accuracy*100)); % 2 decimal places
    fprintf('Precision Score: %.2f%%\n', scores.precision*100);
    fprintf('Recall Score: %.2f%%\n', scores.recall*100);
    fprintf('Specificity Score: %.2f%%\n', scores.specificity*100);
    fprintf('F-measure Score: %.2f%%\n', scores.fMeasure*100);
    fprintf('False Alarm Rate Score: %.2f%%\n', scores.falseAlarmRate*100);
end

function evalClassifications(ImagesIn, labels, predictions, modelName)
    comparison = (labels == predictions);

    % Displays 100 Correctly Classified images
    figure('Name', 'Correct Classification')
    count = 0;
    i = 1;
    while (count < 100) && (i <= length(comparison))
        if comparison(i)
            count = count + 1;
            subplot(6,10,count)
            img = reshape(ImagesIn(i,:),27,18);
            imshow(uint8(img))
            title(num2str(predictions(i)))
        end
        i = i + 1;
    end

    % Displays 100 Incorrectly Classified images
    figure('Name', 'Incorrect Classification')
    count = 0;
    i = 1;
    while (count < 100) && (i <= length(comparison))
        if ~comparison(i) % Negation operatore - extracts incorrectly classified images from set
            count = count + 1;
            subplot(6,10,count)
            img = reshape(ImagesIn(i,:),27,18);
            imshow(uint8(img))
            title(num2str(predictions(i)))
        end
        i = i + 1;
    end

end