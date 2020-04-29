
FROM microsoft/mssql-server-linux:latest


RUN mkdir /var/opt/sqlserver


COPY DatabaseB.mdf /var/opt/sqlserver
COPY DatabaseB_log.ldf /var/opt/sqlserver


ENV SA_PASSWORD=Testing1122
ENV ACCEPT_EULA=Y


HEALTHCHECK --interval=10s  \
	CMD /opt/mssql/bin/sqlservr & \
	/opt/mssql-tools/bin/sqlcmd -S . -U sa -P Testing1122 \
		-Q "CREATE DATABASE [DatabaseB] ON (FILENAME = '/var/opt/sqlserver/DatabaseB.mdf'),(FILENAME = '/var/opt/sqlserver/DatabaseB_log.ldf') FOR ATTACH"