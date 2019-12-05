@echo off
setlocal ENABLEDELAYEDEXPANSION
REM sample files upload CMD script
setlocal enableextensions
setlocal enabledelayedexpansion
set KNOX_IP=%1
set KNOX_PASSWORD=%2
set KNOX_PORT=%3
if NOT DEFINED KNOX_IP goto :usage
if NOT DEFINED KNOX_PASSWORD goto :usage
if NOT DEFINED KNOX_PORT set KNOX_PORT=30443

set KNOX_ENDPOINT=%KNOX_IP%:%KNOX_PORT%

for %%F in (curl.exe) do (
    echo Verifying %%F is in path & CALL WHERE /Q %%F || GOTO exit
)

pushd "%tmp%"
md %TMP_DIR_NAME% >NUL
cd %TMP_DIR_NAME%

REM Create HDFS directories
echo Creating HDFS directories to store file data...
%DEBUG% curl -i -L -k -u root:!KNOX_PASSWORD! -X PUT "https://%KNOX_ENDPOINT%/gateway/default/webhdfs/v1/partner_customers?op=MKDIRS"
%DEBUG% curl -i -L -k -u root:!KNOX_PASSWORD! -X PUT "https://%KNOX_ENDPOINT%/gateway/default/webhdfs/v1/partner_products?op=MKDIRS"
%DEBUG% curl -i -L -k -u root:!KNOX_PASSWORD! -X PUT "https://%KNOX_ENDPOINT%/gateway/default/webhdfs/v1/web_logs?op=MKDIRS"

REM Download source files
echo Downloading source files...
%DEBUG% curl -G "https://cs7a9736a9346a1x44c6xb00.blob.core.windows.net/backups/customers.csv" -o customers.csv
%DEBUG% curl -G "https://cs7a9736a9346a1x44c6xb00.blob.core.windows.net/backups/stockitemholdings.csv" -o products.csv
%DEBUG% curl -G "https://cs7a9736a9346a1x44c6xb00.blob.core.windows.net/backups/web_clickstreams.csv" -o web_clickstreams.csv

REM Upload the data files to HDFS
echo Uploading data files to HDFS...
%DEBUG% curl -i -L -k -u root:!KNOX_PASSWORD! -X PUT "https://%KNOX_ENDPOINT%/gateway/default/webhdfs/v1/partner_customers/customers.csv?op=create&overwrite=true" -H "Content-Type: application/octet-stream" -T "customers.csv"
%DEBUG% curl -i -L -k -u root:!KNOX_PASSWORD! -X PUT "https://%KNOX_ENDPOINT%/gateway/default/webhdfs/v1/partner_products/products.csv?op=create&overwrite=true" -H "Content-Type: application/octet-stream" -T "products.csv"
%DEBUG% curl -i -L -k -u root:!KNOX_PASSWORD! -X PUT "https://%KNOX_ENDPOINT%/gateway/default/webhdfs/v1/web_logs/web_clickstreams.csv?op=create&overwrite=true" -H "Content-Type: application/octet-stream" -T "web_clickstreams.csv"
:: del /q customers.*
:: del /q products.*
:: del /q web_clickstreams.*

REM %DEBUG% del /q *.out *.err *.csv
echo .
echo Sample file uploads completed successfully.

popd
endlocal
exit /b 0
goto :eof

:exit
    echo Sample file uploads failed.
    echo Output and error files are in directory [%TMP%\%TMP_DIR_NAME%].
    exit /b 1

:usage
    echo USAGE: %0 ^<KNOX_IP^> ^<KNOX_PASSWORD^>
    exit /b 0