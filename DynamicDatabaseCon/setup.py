from setuptools import setup

version = '1.0.0'

setup(name='DynamicDatabaseCon',
      version=version,
      description='To establish database conection for different databases',
      py_modules=['dynamicdatabasecon', ],
      install_requires = [
        'sqlalchemy',
        'cx_oracle',
        'psycopg2',
        'pyodbc',
        'pymysql'
      ])