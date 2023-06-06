import warnings

import mlflow.sklearn
import numpy as np
from mlflow.models.signature import infer_signature
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score


def eval_metrics(actual, pred):
    rmse = np.sqrt(mean_squared_error(actual, pred))
    mae = mean_absolute_error(actual, pred)
    r2 = r2_score(actual, pred)
    return rmse, mae, r2


def metrics(y, predict):
    (rmse, mae, r2) = eval_metrics(y, predict)
    print("  RMSE: %s" % rmse)
    print("  MAE: %s" % mae)
    print("  R2: %s" % r2)

    mlflow.log_metric("rmse", rmse)
    mlflow.log_metric("r2", r2)
    mlflow.log_metric("mae", mae)


def score(lr, X, y):
    score = lr.score(X, y)

    print("Score: %s" % score)
    mlflow.log_metric("score", score)


def save_model(lr, X, predictions):
    signature = infer_signature(X, predictions)
    mlflow.sklearn.log_model(lr, "model",
                             registered_model_name="my-sklearn-model",
                             signature=signature)
    print("Model saved in run %s" % mlflow.active_run().info.run_uuid)


def train():
    X = np.array([-2, -1, 0, 1, 2, 1]).reshape(-1, 1)
    y = np.array([0, 0, 1, 1, 1, 0])
    lr = LogisticRegression()
    lr.fit(X, y)

    predictions = lr.predict(X)

    metrics(y, predictions)

    score(lr, X, y)

    save_model(lr, X, predictions)


if __name__ == "__main__":
    warnings.filterwarnings("ignore")
    train()
