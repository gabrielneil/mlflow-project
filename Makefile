install:
	@( \
		python -m venv venv; \
		source venv/bin/activate; \
		python -m pip install --no-cache-dir -r requirements.txt; \
	)

start:
	@( \
		mlflow ui -p 5001; \
	)
