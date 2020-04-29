
FROM microsoft/mssql-server-linux:latest


RUN mkdir /var/opt/sqlserver


COPY DatabaseC.mdf /var/opt/sqlserver
COPY DatabaseC_log.ldf /var/opt/sqlserver


ENV ACCEPT_EULA=Y


ENV MSSQL_PID=Enterprise


ENV MSSQL_BACKUP_DIR="/var/opt/sqlserver"
ENV MSSQL_DATA_DIR="/var/opt/sqlserver"
ENV MSSQL_LOG_DIR="/var/opt/sqlserver"


ENV MSSQL_TCP_PORT=15666


HEALTHCHECK --interval=10s  \
	CMD /opt/mssql/bin/sqlservr & \
	/opt/mssql-tools/bin/sqlcmd -S localhost,15666 -U sa -P $SA_PASSWORD \
		-Q "CREATE DATABASE [DatabaseC] ON (FILENAME = '/var/opt/sqlserver/DatabaseC.mdf'),(FILENAME = '/var/opt/sqlserver/DatabaseC_log.ldf') FOR ATTACH"
