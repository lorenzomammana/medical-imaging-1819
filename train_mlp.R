library(neuralnet)
library(mxnet)
require(tictoc)
library(ROCR) 
library(caret)

# Carico il dataset
dataset <- read.csv("C:/Users/loren/Desktop/medical-imaging-1819/datasetextended.csv")
maxs <- apply(dataset, 2, max)
mins <- apply(dataset, 2, min)

# Riscalo le features nel range [0, 1]
scaled <- as.data.frame(scale(dataset, center = mins, scale = maxs - mins))

k = 10
outs = NULL

# Fermo il training se l'accuracy non cambia
mx.callback.train.stop <- function(tol = 1e-3, 
                                   mean.n = 1e2, 
                                   period = 100, 
                                   min.iter = 1000
) {
  function(iteration, nbatch, env, verbose = TRUE) {
    if (nbatch == 0 & !is.null(env$metric)) {
      continue <- TRUE
      acc.train <- env$metric$get(env$train.metric)$value
      if (is.null(env$acc.log)) {
        env$acc.log <- acc.train
      } else {
        if ((abs(acc.train - mean(tail(env$acc.log, mean.n))) < tol &
             abs(acc.train - max(env$acc.log)) < tol &
             iteration > min.iter) | 
            acc.train == 1) {
          cat("Training finished with final accuracy: ", 
              round(acc.train * 100, 2), " %\n", sep = "")
          continue <- FALSE 
        }
        env$acc.log <- c(env$acc.log, acc.train)
      }
    }
    if (iteration %% period == 0) {
      cat("[", iteration,"]"," training accuracy: ", 
          round(acc.train * 100, 2), " %\n", sep = "") 
    }
    return(continue)
  }
}

tic("Tempo richiesto:")

# Setto i seed per la riproducibilità
set.seed(03042019)
mx.set.seed(03042019)
confmat = NULL
f.score_positive = NULL
f.score_negative = NULL
precision_positive = NULL
precision_negative = NULL
recall_positive = NULL
recall_negative = NULL

# Plot delle roc curve di ogni fold con k = 10
if (k == 10)
{
  plot.new()
  dev.new(width=800, height=400)
  par(mfrow=c(2, 5))
}


folds = createFolds(factor(scaled$label), k = k, list = FALSE)
for (i in 1:k)
{
  
  train <- scaled[folds != i,]
  test <- scaled[folds == i,]
  train.x = data.matrix(train[, 1:(length(train) - 1)])
  train.y = train$label
  test.x = data.matrix(test[, 1:(length(test) - 1)])
  test.y = test$label
  # Modello della rete
  # Addestro su cpu, ma è possibile farlo anche su gpu
  # Richiede mxnet con cuda
  model = mx.mlp(
    train.x,
    train.y,
    array.layout = "rowmajor",
    hidden_node = c(36),
    out_node = 2,
    dropout = 0.5,
    activation = "sigmoid",
    out_activation = "softmax",
    num.round = 2000,
    array.batch.size = 32,
    learning.rate = 0.1,
    momentum = 0.9,
    eval.metric = mx.metric.accuracy,
    epoch.end.callback = mx.callback.train.stop(),
    ctx = mx.cpu(0)
  )
  
  preds = predict(model, test.x, array.layout = "rowmajor")
  pred.label = max.col(t(preds)) - 1
  accuracy = mean(pred.label == test.y)
  outs[i] = accuracy
  confmat = table(pred.label, test.y)
  
  # Precision: tp/(tp+fp):
  precision_positive[i] = confmat[2,2]/sum(confmat[2,1:2])
  
  # Recall: tp/(tp + fn):
  recall_positive[i] = confmat[2,2]/sum(confmat[1:2,2])
  
  # F-Score: 2 * precision * recall /(precision + recall):
  f.score_positive[i] =  2 * precision_positive[i] * recall_positive[i] / (precision_positive[i] + recall_positive[i])
  
  # Precision: tn/(tn+fn):
  precision_negative[i] = confmat[1,1]/sum(confmat[1,1:2])
  
  # Recall: tn/(tn + fp):
  recall_negative[i] = confmat[1,1]/sum(confmat[1:2,1])
  
  # F-Score: 2 * precision * recall /(precision + recall):
  f.score_negative[i] =  2 * precision_negative[i] * recall_negative[i] / (precision_negative[i] + recall_negative[i])
  
  roc_preds = ROCR::prediction(labels = as.numeric(test.y), predictions = as.numeric(pred.label))
  
  perf.rocr = performance(roc_preds, measure = "auc", x.measure = "cutoff")
  perf.tpr.rocr = performance(roc_preds, "tpr", "fpr")
  
  plot(perf.tpr.rocr, colorize = T, main = paste("AUC:", (perf.rocr@y.values)))
}






