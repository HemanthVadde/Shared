from sqlalchemy.engine import create_engine


def create_dbengine(dbtype,host,username,password,dbname):
	db = dbtype.lower()
	if db == 'oracle':
		engine_str = "{db} + cx_oracle + ://{username}:{password}@{host}/?service_name={dbname}"
	elif db == 'postgresql':
		engine_str = "{db}}+psycopg2://{username}:{password}@{host}/{dbname}"
	elif db == 'mssql':
		engine_str = "{db}}+pyodbc://{username}:{password}@{host}/{dbname}"
	elif db == 'mysql':
		engine_str = "{db}}+pymysql://{username}:{password}@{host}/{dbname}?charset=utf8mb4"
	else:
		raise EXCEPTION("Please pass propert database types. Currently supports only oracle, postgresql, mssql & mysql")
	engine = create_engine(engine_str)
	return engine
