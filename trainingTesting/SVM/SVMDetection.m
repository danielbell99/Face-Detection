function [prediction, maxi] = SVMDetection(img, model)

    if strcmp(model.type, "binary")
        pred = ClassificationSVM(model, img);
        if pred > 0 % Binary Classification
            prediction=1;
        else
            prediction=0;
        end
        maxi = pred;
    else
        [pred, NegLoss, Pb] = predict(model.classifier, img);
        maxi = max(Pb);
        prediction = (round(pred)-1);
    end

end