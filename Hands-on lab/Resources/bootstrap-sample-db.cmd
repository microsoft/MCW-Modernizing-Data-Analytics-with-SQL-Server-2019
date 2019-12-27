@echo off
REM bootstrap sample database CMD script
setlocal enableextensions
setlocal enabledelayedexpansion
set CLUSTER_NAMESPACE=%1
set SQL_MASTER_IP=%2
set SQL_MASTER_ADMIN_PASSWORD=%3
set KNOX_IP=%4
set KNOX_PASSWORD=%5
set AW_WWI_SAMPLES=%6
set SQL_MASTER_PORT=%7
set KNOX_PORT=%8
set STARTUP_PATH=%~dp0
set TMP_DIR_NAME=%~nx0

if NOT DEFINED CLUSTER_NAMESPACE goto :usage
if NOT DEFINED SQL_MASTER_IP goto :usage
if NOT DEFINED SQL_MASTER_ADMIN_PASSWORD goto :usage
if NOT DEFINED KNOX_IP goto :usage
if NOT DEFINED KNOX_PASSWORD set KNOX_PASSWORD=%SQL_MASTER_ADMIN_PASSWORD%
if NOT DEFINED AW_WWI_SAMPLES set AW_WWI_SAMPLES=no
if NOT DEFINED SQL_MASTER_PORT set SQL_MASTER_PORT=31433
if NOT DEFINED KNOX_PORT set KNOX_PORT=30443

set SQL_MASTER_INSTANCE=%SQL_MASTER_IP%,%SQL_MASTER_PORT%
set KNOX_ENDPOINT=%KNOX_IP%:%KNOX_PORT%

for %%F in (sqlcmd.exe bcp.exe kubectl.exe curl.exe) do (
    echo Verifying %%F is in path & CALL WHERE /Q %%F || GOTO exit
)

pushd "%tmp%"
md %TMP_DIR_NAME% >NUL
cd %TMP_DIR_NAME%

if NOT EXIST tpcxbb_1gb.bak (
    echo Downloading sample database backup file...
    %DEBUG% curl -G "https://sqlchoice.blob.core.windows.net/sqlchoice/static/tpcxbb_1gb.bak" -o tpcxbb_1gb.bak
)

set SQLCMDSERVER=%SQL_MASTER_INSTANCE%
set SQLCMDUSER=admin
set SQLCMDPASSWORD=%SQL_MASTER_ADMIN_PASSWORD%
for /F "usebackq tokens=1,2" %%v in (`sqlcmd -I -b -h-1 -W -Q "SET NOCOUNT ON; SELECT @@SERVERNAME, SERVERPROPERTY('IsHadrEnabled');"`) do (
	SET MASTER_POD_NAME=%%v
	SET HADR_ENABLED=%%w
)

REM Copy the backup file, restore the database, create necessary objects and data file
echo Copying sales database backup file to SQL Master instance...
%DEBUG% kubectl cp tpcxbb_1gb.bak %CLUSTER_NAMESPACE%/%MASTER_POD_NAME%:var/opt/mssql/data/ -c mssql-server || goto exit

REM Download and copy the sample backup files
if /i "%AW_WWI_SAMPLES%" EQU "--install-extra-samples" (
    set FILES=AdventureWorks2016_EXT.bak AdventureWorksDW2016_EXT.bak
    for %%f in (!FILES!) do (
        if NOT EXIST %%f (
                echo Downloading %%f sample database backup file...
                %DEBUG% curl -L -G "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/%%f" -o %%f
        )
        echo Copying %%f database backup file to SQL Master instance...
        %DEBUG% kubectl cp %%f %CLUSTER_NAMESPACE%/%MASTER_POD_NAME%:var/opt/mssql/data/ -c mssql-server || goto exit

        echo Removing database backup file...
        %DEBUG% kubectl exec %MASTER_POD_NAME% -n %CLUSTER_NAMESPACE% -c mssql-server -i -t -- bash -c "rm -rvf /var/opt/mssql/data/%%f"
    )

    set FILES=WideWorldImporters-Full.bak WideWorldImportersDW-Full.bak
    for %%f in (!FILES!) do (
        if NOT EXIST %%f (
            echo Downloading %%f sample database backup file...
            %DEBUG% curl -L -G "https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/%%f" -o %%f
        )
        echo Copying %%f database backup file to SQL Master instance...
        %DEBUG% kubectl cp %%f %CLUSTER_NAMESPACE%/%MASTER_POD_NAME%:var/opt/mssql/data/ -c mssql-server || goto exit

        echo Removing database backup file...
        %DEBUG% kubectl exec %MASTER_POD_NAME% -n %CLUSTER_NAMESPACE% -c mssql-server -i -t -- bash -c "rm -rvf /var/opt/mssql/data/%%f"
    )
)

REM If HADR is enabled then port-forward 1533 temporarily to connect to the primary directly
REM Default timeout for port-forward is 5 minutes so start command in background & it will terminate automatically
if /i "%HADR_ENABLED%" EQU "1" (
    %DEBUG% start kubectl port-forward pods/%MASTER_POD_NAME% 1533:1533 -n %CLUSTER_NAMESPACE%
    SET SQLCMDSERVER=127.0.0.1,1533
)

echo Configuring sample database(s)...
%DEBUG% sqlcmd -i "%STARTUP_PATH%bootstrap-sample-db.sql" -o "bootstrap.out" -I -b -v SA_PASSWORD="%KNOX_PASSWORD%" || goto exit

REM remove files copied into the pod:
echo Removing database backup file...
%DEBUG% kubectl exec %MASTER_POD_NAME% -n %CLUSTER_NAMESPACE% -c mssql-server -i -t -- bash -c "rm -rvf /var/opt/mssql/data/tpcxbb_1gb.bak"

for %%F in (web_clickstreams inventory customer) do (
    if NOT EXIST %%F.csv (
        echo Exporting %%F data...
        if /i %%F EQU web_clickstreams (set DELIMITER=,) else (SET DELIMITER=^|)
        %DEBUG% bcp sales.dbo.%%F out "%%F.csv" -S %SQLCMDSERVER% -U%SQLCMDUSER% -P%SQL_MASTER_ADMIN_PASSWORD% -c -t"!DELIMITER!" -o "%%F.out" -e "%%F.err" || goto exit
    )
)

if NOT EXIST product_reviews.csv (
    echo Exporting product_reviews data...
    %DEBUG% bcp "select pr_review_sk, replace(replace(pr_review_content, ',', ';'), char(34), '') as pr_review_content from sales.dbo.product_reviews" queryout "product_reviews.csv" -S %SQLCMDSERVER% -U%SQLCMDUSER% -P%SQL_MASTER_ADMIN_PASSWORD% -c -t, -o "product_reviews.out" -e "product_reviews.err" || goto exit
)

REM Copy the data file to HDFS
echo Uploading web_clickstreams data to HDFS...
%DEBUG% curl -L -k -u root:%KNOX_PASSWORD% -X PUT "https://%KNOX_ENDPOINT%/gateway/default/webhdfs/v1/clickstream_data?op=MKDIRS" || goto exit
%DEBUG% curl -L -k -u root:%KNOX_PASSWORD% -X PUT "https://%KNOX_ENDPOINT%/gateway/default/webhdfs/v1/clickstream_data/web_clickstreams.csv?op=create&overwrite=true" -H "Content-Type: application/octet-stream" -T "web_clickstreams.csv" || goto exit
:: del /q web_clickstreams.*

echo.
echo Uploading product_reviews data to HDFS...
%DEBUG% curl -L -k -u root:%KNOX_PASSWORD% -X PUT "https://%KNOX_ENDPOINT%/gateway/default/webhdfs/v1/product_review_data?op=MKDIRS" || goto exit
%DEBUG% curl -L -k -u root:%KNOX_PASSWORD% -X PUT "https://%KNOX_ENDPOINT%/gateway/default/webhdfs/v1/product_review_data/product_reviews.csv?op=create&overwrite=true" -H "Content-Type: application/octet-stream" -T "product_reviews.csv" || goto exit
:: del /q product_reviews.*

REM %DEBUG% del /q *.out *.err *.csv
echo .
echo Bootstrap of the sample database completed successfully.
echo You can now login using "root" and Knox password to get the unified experience in Azure Data Studio.
echo Data files for Oracle setup are located at [%TMP%\%TMP_DIR_NAME%].

popd
endlocal
exit /b 0
goto :eof

:exit
    echo Bootstrap of the sample database failed.
    echo Output and error files are in directory [%TMP%\%TMP_DIR_NAME%].
    exit /b 1

:usage
    echo USAGE: %0 ^<CLUSTER_NAMESPACE^> ^<SQL_MASTER_IP^> ^<SQL_MASTER_ADMIN_PASSWORD^> ^<KNOX_IP^> [^<KNOX_PASSWORD^>] [--install-extra-samples] [SQL_MASTER_PORT] [KNOX_PORT]
    echo Default ports are assumed for SQL Master instance ^& Knox gateway unless specified.
    exit /b 0
