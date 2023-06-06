#make deploy-locally run_id=66e741a6205e42cc9ad424d392834907 (example)

run_id?=run_no_set

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

deploy-locally:
	@( \
		mlflow models serve --model-uri runs:/$(run_id)/model --env-manager=local -p 1234; \
	)

predictions:
	@( \
		curl -d '{"dataframe_split": {"columns":[0],"index":[0,1,2],"data":[[1],[-1], [3]]}}' \
		-H 'Content-Type: application/json' \
		localhost:1234/invocations; \
	)