sleep 15s
 
/opt/mssql-tools/bin/sqlcmd -S localhost,15666 -U sa -P Testing1122 \
-Q "CREATE DATABASE [DatabaseC] ON (FILENAME = '/var/opt/sqlserver/DatabaseC.mdf'),(FILENAME = '/var/opt/sqlserver/DatabaseC_log.ldf') FOR ATTACH"