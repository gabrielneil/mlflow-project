run_id?=run_no_set
project_model=sklearn_mlops
deployment_port=1234
install:
	@( \
		python -m venv venv; \
		source venv/bin/activate; \
		python -m pip install --no-cache-dir -r requirements.txt; \
	)

start-ui:
	@( \
		mlflow ui -p 5001; \
	)

train:
	@( \
		python training/train.py; \
	)

deploy-production-model-locally:
	@( \
		mlflow models serve -m models:/my-sklearn-model/Production --env-manager=local -p $(deployment_port); \
	)

deploy-experiment-model-locally: #make deploy-experiment-model-locally run_id=66e741a6205e42cc9ad424d392834907 (example)
	@( \
		mlflow models serve --model-uri runs:/$(run_id)/model --env-manager=local -p $(deployment_port); \
	)

predictions:
	@( \
		curl -d '{"dataframe_split": {"columns":[0],"index":[0,1,2],"data":[[1],[-1], [3]]}}' \
		-H 'Content-Type: application/json' \
		localhost:$(deployment_port)/invocations; \
	)

build-docker:
	@( \
		mlflow models build-docker --model-uri "models:/my-sklearn-model/1" --name $(project_model); \
	)

run-docker:
	@( \
		docker run -p $(deployment_port):8080 $(project_model); \
	)

stop-docker:
	@( \
		docker stop 38471a44c880; \
	)