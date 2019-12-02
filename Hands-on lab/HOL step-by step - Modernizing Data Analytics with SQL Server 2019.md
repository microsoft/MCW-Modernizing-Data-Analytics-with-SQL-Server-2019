![Microsoft Cloud Workshops](https://github.com/Microsoft/MCW-Template-Cloud-Workshop/raw/master/Media/ms-cloud-workshop.png 'Microsoft Cloud Workshops')

<div class="MCWHeader1">
Modernizing Data Analytics with SQL Server 2019
</div>

<div class="MCWHeader2">
Hands-on lab step-by-step
</div>

<div class="MCWHeader3">
December 2019
</div>

Information in this document, including URL and other Internet Web site references, is subject to change without notice. Unless otherwise noted, the example companies, organizations, products, domain names, e-mail addresses, logos, people, places, and events depicted herein are fictitious, and no association with any real company, organization, product, domain name, e-mail address, logo, person, place or event is intended or should be inferred. Complying with all applicable copyright laws is the responsibility of the user. Without limiting the rights under copyright, no part of this document may be reproduced, stored in or introduced into a retrieval system, or transmitted in any form or by any means (electronic, mechanical, photocopying, recording, or otherwise), or for any purpose, without the express written permission of Microsoft Corporation.

Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in this document. Except as expressly provided in any written license agreement from Microsoft, the furnishing of this document does not give you any license to these patents, trademarks, copyrights, or other intellectual property.

The names of manufacturers, products, or URLs are provided for informational purposes only and Microsoft makes no representations and warranties, either expressed, implied, or statutory, regarding these manufacturers or the use of the products with any Microsoft technologies. The inclusion of a manufacturer or product does not imply endorsement of Microsoft of the manufacturer or product. Links may be provided to third party sites. Such sites are not under the control of Microsoft and Microsoft is not responsible for the contents of any linked site or any link contained in a linked site, or any changes or updates to such sites. Microsoft is not responsible for webcasting or any other form of transmission received from any linked site. Microsoft is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement of Microsoft of the site or the products contained therein.

© 2019 Microsoft Corporation. All rights reserved.

Microsoft and the trademarks listed at <https://www.microsoft.com/en-us/legal/intellectualproperty/Trademarks/Usage/General.aspx> are trademarks of the Microsoft group of companies. All other trademarks are property of their respective owners.

**Contents**

<!-- TOC -->

- [Modernizing Data Analytics with SQL Server 2019 hands-on lab step-by-step](#modernizing-data-analytics-with-sql-server-2019-hands-on-lab-step-by-step)
  - [Abstract and learning objectives](#abstract-and-learning-objectives)
  - [Overview](#overview)
  - [Solution architecture](#solution-architecture)
  - [Requirements](#requirements)
  - [Before the hands-on lab](#before-the-hands-on-lab)
    - [Connect with Azure Data Studio](#connect-with-azure-data-studio)
    - [Connect with SQL Server Management Studio](#connect-with-sql-server-management-studio)
  - [Exercise 1: Using data virtualization](#exercise-1-using-data-virtualization)
    - [Task 1: Create external table from Azure SQL Database](#task-1-create-external-table-from-azure-sql-database)
    - [Task 2: Create external table from CSV files](#task-2-create-external-table-from-csv-files)
    - [Task 3: Query and join data from flat files, data from external database systems, and SQL Server](#task-3-query-and-join-data-from-flat-files-data-from-external-database-systems-and-sql-server)
  - [Exercise 2: Using notebooks](#exercise-2-using-notebooks)
    - [Task 1: Introduction to Jupyter notebooks](#task-1-introduction-to-jupyter-notebooks)
    - [Task 2: Querying the SQL Server Master Instance (MI)](#task-2-querying-the-sql-server-master-instance-mi)
    - [Task 3: Virtualizing data with scripts](#task-3-virtualizing-data-with-scripts)
    - [Task 4: Creating and querying a Data Mart](#task-4-creating-and-querying-a-data-mart)
    - [Task 5: Using the powerful Spark engine for data exploration](#task-5-using-the-powerful-spark-engine-for-data-exploration)
  - [Exercise 3: Machine learning](#exercise-3-machine-learning)
    - [Task 1: Train a machine learning model](#task-1-train-a-machine-learning-model)
    - [Task 2: Score and save data as an external table](#task-2-score-and-save-data-as-an-external-table)
  - [Exercise 4: Identify PII and GDPR-related compliance issues using Data Discovery & Classification in SSMS](#exercise-4-identify-pii-and-gdpr-related-compliance-issues-using-data-discovery--classification-in-ssms)
    - [Task 1: Use the Data Discovery & Classification in SSMS](#task-1-use-the-data-discovery--classification-in-ssms)
    - [Task 2: Fix compliance issues with dynamic data masking](#task-2-fix-compliance-issues-with-dynamic-data-masking)
  - [Exercise 5: Exploring intelligent query processing (QP) features](#exercise-5-exploring-intelligent-query-processing-qp-features)
    - [Task 1: Set database compatibility level](#task-1-set-database-compatibility-level)
    - [Task 2: Scalar UDF inlining](#task-2-scalar-udf-inlining)
    - [Task 3: Table variable deferred compilation](#task-3-table-variable-deferred-compilation)
    - [Task 4: Row mode memory grant feedback](#task-4-row-mode-memory-grant-feedback)
  - [Exercise 6: Monitoring the big data cluster](#exercise-6-monitoring-the-big-data-cluster)
    - [Task 1: Use the Big Data Cluster Dashboard](#task-1-use-the-big-data-cluster-dashboard)
    - [Task 2: Monitor and troubleshoot using kubectl commands](#task-2-monitor-and-troubleshoot-using-kubectl-commands)
  - [After the hands-on lab](#after-the-hands-on-lab)
    - [Task 1: Delete the resource group](#task-1-delete-the-resource-group)

<!-- /TOC -->

# Modernizing Data Analytics with SQL Server 2019 hands-on lab step-by-step

## Abstract and learning objectives

Wide World Importers (WWI) has a host of online stores for various product offerings, including traditional product catalogs offered by their physical storefronts, to specialized categories like automotive and consumer technology products. With this expansion, they have generated a significant amount of additional data, and data formats. These new platforms were added without integrating into the OLTP system data or Business Intelligence infrastructures. As a result, "silos" of data stores have developed. In addition to their desire to overcome fragmentation of their actionable insights due to these data silos, they wish to add AI capabilities to their toolset to help grow their business and reduce costs.

In this hands-on lab, you will implement the steps to install and configure a SQL Server 2019 cluster to Linux-based containers in Azure. Using this cluster, you will use data virtualization to unify data from various sources, analyze the data, create and deploy a machine learning model, and finally detect and fix PII and GDPR compliance issues.

At the end of this hands-on lab, you will be better able to build solutions for conducting advanced data analytics at scale with scalable SQL Server 2019 Big Data clusters.

## Overview

Businesses require near real-time insights from ever-larger sets of data. Large-scale data ingestion requires scale-out storage and processing in ways that allow fast response times. In addition to simply querying this data, organizations want full analysis and even predictive capabilities over their data.

While solutions for large-scale data processing exist, they are often batch-based, which has a lag in the time from query to response. Also, batch systems such as Hadoop are complicated to set up and manage. Operational data is often stored in Relational Database systems on-premises, and joining that data to larger-scale cloud systems exposes security weaknesses and brittle architectures.

## Solution architecture

![Preferred solution.](../Media/preferred-solution.png 'Preferred solution diagram')

   WWI's requirements can be fully met with SQL Server 2019 Big Data Clusters (BDC). Kubernetes is responsible for the state of the BDC, and it builds and configures the cluster nodes, assigns pods to nodes, and monitors the health of the cluster. The architecture is composed of an App Pool that hosts applications, an instance of Machine Learning Server, and SSIS packages. It has a Control Plane consisting of a SQL Server Master Instance, and components for managing access to the HDFS cluster, Spark jobs, and metadata. SQL Server instances are distributed within the Compute Pool, under direction of the SQL Server Master Instance. The Storage Pool consists of collocated instances of SQL Server, Apache Spark, and HDFS. These components of the storage pool can be combined to create a data lake to store big data in a highly available-distributed fashion. The Data Pool provides persistent SQL Server storage for the cluster, distributed into shards across the member SQL Server data pool instances.

   This architecture enables line-of-business applications to query the SQL Server Master Instance without requiring code changes. Multiple data sources can be combined with internal SQL Server tables in single queries through either the use of Data Virtualization, enabled by enhanced PolyBase connectors and scaled out through the Compute Pool and other components, or cached and distributed across shards of the Data Pool, enabling a scale-out data mart. Advanced analytics and AI is enabled by Machine Learning Services as well as Apache Spark jobs executed through Jupyter notebooks and other data processing features.

   SQL Server big data clusters architecture:

   ![SQL Server big data clusters architecture diagram](../Whiteboard%20design%20session/media/common-scenario-1.png)

## Requirements

1. Microsoft Azure subscription must be pay-as-you-go or MSDN.
   - Trial subscriptions will not work.
2. PowerShell
3. Python3
4. curl
5. sqlcmd
6. [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest)
7. [azdata](https://docs.microsoft.com/en-us/sql/big-data-cluster/deploy-install-azdata-installer?view=sql-server-ver15)
8. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-with-powershell-from-psgallery)
9. [SQL Server Management Studio](https://go.microsoft.com/fwlink/?linkid=2078638) (SSMS) v18.4 or greater
10. [Azure Data Studio](https://docs.microsoft.com/sql/azure-data-studio/download?view=sql-server-ver15)
    - [Data Virtualization extension for Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/data-virtualization-extension?view=sql-server-ver15)

## Before the hands-on lab

Refer to the Before the hands-on lab setup guide manual before continuing to the lab exercises.

Follow the steps below to connect to your SQL Server 2019 cluster with both Azure Data Studio and SQL Server Management Studio (SSMS).

### Connect with Azure Data Studio

1. On the bottom-left corner of your Windows desktop, locate the search box next to the Start Menu. Type **Azure Data Studio**, then select the Azure Data Studio desktop app in the search results.

   ![The search box has "Azure Data Studio" entered into it and the desktop app is highlighted in the results.](media/launch-azure-data-studio.png 'Launch Azure Data Studio')

2. Within Azure Data Studio, if the Connection dialog isn't automatically displayed, select **Servers** from the top of the left-hand menu, then select **New Connection** from the top toolbar to the right of the menu.

   ![The Servers menu icon is selected, as well as the new connection icon.](media/ads-new-connection-link.png 'Azure Data Studio')

3. Within the Connection dialog, configure the following:

   - **Connection type:** Select Microsoft SQL Server.
   - **Server:** Enter the IP address, followed by port number `31433` to the SQL Server 2019 Big Data cluster. It should have a format of IP separated by a comma from the port, such as: `11.122.133.144,31433`.
   - **Authentication type:** Select SQL Login.
   - **Username:** Enter `admin`.
   - **Password:** Enter the password you used when creating the cluster.
   - **Remember password:** Checked.
   - Leave all other options at their default values.

   ![The Connection form is filled out with the previously mentioned settings entered into the appropriate fields.](media/ads-new-connection.png 'Azure Data Studio - New Connection')

4. Select **Connect**.

### Connect with SQL Server Management Studio

1. On the bottom-left corner of your Windows desktop, locate the search box next to the Start Menu. Type **SQL Server Management Studio**, then select the SQL Server Management Studio desktop app in the search results.

   ![The search box has "SQL Server Management Studio" entered into it and the desktop app is highlighted in the results.](media/launch-ssms.png 'Launch SQL Server Management Studio')

2. Within the Connection dialog that appears, configure the following:

   - **Server name:** Enter the IP address, followed by port number `31433` to the SQL Server 2019 Big Data cluster. It should have a format of IP separated by a comma from the port, such as: `11.122.133.144,31433`.
   - **Authentication:** Select SQL Server Authentication.
   - **Login:** Enter `admin`.
   - **Password:** Enter the password you used when creating the cluster.
   - **Remember password:** Checked.

   ![The Connect form is filled out with the previously mentioned settings entered into the appropriate fields.](media/ssms-connection.png 'SQL Server Management Studio - Connect')

3. Select **Options**.  Then, on the **Connection Properties** tab, check the **Trust server certificate** box.

![The Connection Properties form is filled out with the Trust server certificate option selected.](media/ssms-trust-server-certificate.png 'SQL Server Management Studio - Connection Properties')

4. Select **Connect**.

## Exercise 1: Using data virtualization

Duration: 20 mins

One of the key new features of SQL Server 2019 is data virtualization. What this means is that you can _virtualize_ external data in a SQL Server instance, regardless of source, location, and format, so that it can be queried like any other table, or sets of tables, within your SQL Server instance. In essence, data virtualization helps you create a single "virtual" layer of data from these disparate sources, providing unified data services to support multiple applications and users. A more familiar term we could use is data lake, or perhaps data hub. Unlike a typical data lake, however, you do not have to move data out from where it lives, yet you can still query that data through a consistent interface. This is a huge advantage over traditional ETL (extract-transform-load) processes where data must be moved from its original source to a new destination, oftentimes with some data transformation or mapping. This causes delays, extra storage, additional security, and a fair amount of engineering in most cases. With data virtualization, no data movement is required, which means the data sets are up-to-date, and it is possible to query and join these different data sources through these new capabilities, thanks to the use of new [PolyBase](https://docs.microsoft.com/sql/relational-databases/polybase/polybase-guide?view=sql-server-ver15) connectors. The data sources you can connect to include Cosmos DB, SQL Server (including Azure SQL Database), Oracle, HDFS (for flat files), and DB2.

![Data Virtualization compared to traditional ETL.](media/data-virtualization-vs-etl.png 'ETL vs. Data Virtualization')

The image to the left represents traditional data movement using ETL. Compare that to data virtualization, which does not require data movement and provides a unified layer over top of existing data sources.

In this task, you will experience how to configure data virtualization in SQL Server 2019 by joining data in a single query from a SQL Server 2019 table, an external file stored in HDFS (Hadoop Filesystem), and an external database.

Learn more about using data virtualization with [relational data sources](https://docs.microsoft.com/sql/relational-databases/polybase/data-virtualization?toc=%2fsql%2fbig-data-cluster%2ftoc.json&view=sql-server-ver15) and [CSV files](https://docs.microsoft.com/sql/relational-databases/polybase/data-virtualization-csv?view=sql-server-ver15), using the External Table Wizard.

<!-- ### Task 1: Query and join data from flat files, data from external database systems, and SQL Server -->

### Task 1: Create external table from Azure SQL Database

To start, we will use the External Table Wizard in Azure Data Studio to connect to an external Azure SQL Database.

1. Open Azure Data Studio and connect to your SQL Server 2019 cluster, following the [connection steps](#connect-with-azure-data-studio) above.

2. Expand the Databases folder, right-click on the **sales** database, then select **New Query**.


3. Run the following code.  Make sure to replace the value for the SQL Server.  Change the username and password if you changed it off of the default values.

 ```sql
IF NOT EXISTS
(
	SELECT 1
	FROM sys.symmetric_keys
	WHERE
		name LIKE '%DatabaseMasterKey%'
)
BEGIN
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MySQLBigData2019';
END
GO

IF NOT EXISTS
(
	SELECT 1
	FROM sys.database_scoped_credentials
	WHERE
		name = N'SQLCred'
)
BEGIN
  /*  specify credentials to external data source
   *  IDENTITY: user name for external source.
   *  SECRET: password for external source.
   */
	CREATE DATABASE SCOPED CREDENTIAL SQLCred
	WITH IDENTITY = 'ServerAdmin',
	SECRET = 'MySQLBigData2019';
END
GO

IF NOT EXISTS
(
	SELECT 1
	FROM sys.external_data_sources s
	WHERE
		s.name = N'SQLServerInstance'
)
BEGIN
  /* LOCATION: Location string should be of format '<vendor>://<server>[:<port>]'.
   * PUSHDOWN: specify whether computation should be pushed down to the source. ON by default.
   * CREDENTIAL: the database scoped credential, created above.
   */
	CREATE EXTERNAL DATA SOURCE SQLServerInstance WITH
	(
		LOCATION = 'sqlserver://<YOUR_AZURE_SERVER_NAME>.database.windows.net',
    -- PUSHDOWN = ON | OFF,
    CREDENTIAL = SQLCred,
    CONNECTION_OPTIONS='Database=wwi_commerce' 
	);
END
GO

IF (OBJECT_ID('dbo.Reviews') IS NULL)
BEGIN
	CREATE EXTERNAL TABLE dbo.Reviews
  (
	  [product_id] [bigint] NOT NULL,
	  [customer_id] [bigint] NOT NULL,
	  [review] [nvarchar](1000) NOT NULL,
	  [date_added] [datetime] NOT NULL
  )
  WITH
  (
    LOCATION='wwi_commerce.dbo.Reviews',
    DATA_SOURCE=SqlServerInstance
  );
END
GO

SELECT *
FROM dbo.Reviews;

 ```

4.  Select the Servers link (Ctrl+Shift+D) on the left-hand menu, then expand the Tables list underneath your **sales** database and find the **dbo.Reviews (External)** table. If you do not see it, right-click on the Tables folder, then select Refresh. The "(External)" portion of the table name denotes that it is a virtual data object that was added as an external table.

    ![The Reviews external table is displayed in the sales tables list.](media/ads-reviews-table-in-list.png 'Reviews external table')

5.  Right-click the **dbo.Reviews (External)** table, then select the **Select Top 1000** menu option to display the table contents.

    ![The Select Top 1000 rows menu item is highlighted.](media/ads-reviews-select-top-1000.png 'Select Top 1000')

6.  You should see a SQL query selecting the top 1000 records from the Reviews table and its results. The interesting thing to note is that the query selects the table and fields using the same syntax you would use to select from any other table in the sales database. The fact that the Reviews table is external is completely seamless and transparent to the user. This is the power of data virtualization in SQL Server 2019.

    ![The Reviews query and results are displayed.](media/ads-reviews-query-results.png 'Reviews query results')

    ```sql
    SELECT TOP (1000) [product_id]
        ,[customer_id]
        ,[review]
        ,[date_added]
    FROM [sales].[dbo].[Reviews]
    ```

### Task 2: Create external table from CSV files

The next data source we will be virtualizing is a CSV file that you will upload to HDFS.

1. Within Azure Data Studio, scroll down below the list of SQL Server 2019 databases to find the **Data Services** folder. Expand that folder, then **right-click** on the **HDFS** folder. Select **New Directory**.

   ![The HDFS foler is highlighted and the context menu is displayed.](media/ads-hdfs-new-directory.png 'New directory')

2. In the dialog that appears, type **data** then press 'Enter' to confirm.

3. **Right-click** on the new **data** folder, then select **Upload files**.

   ![The new data folder is highlighted and the context menu is displayed.](media/ads-data-upload-files-link.png 'Upload files')

4. In the folder browser dialog, navigate to the `C:\MCW-Modernizing-data-analytics-with-SQL-Server-2019-master\Hands-on lab\Resources` folder and select **stockitemholdings.csv**.

   ![The file browser is displayed.](media/ads-open-stockitemholdings.png 'Open')

5. Select **Upload**.

6. Expand the **data** subfolder you created, then right-click on the `stockitemholdings.csv` file and select **Create External Table From CSV Files**.

   ![The CSV file and the Create External Table From CSV Files menu item are highlighted.](media/ads-create-external-table-csv.png 'Create External Table From CSV Files')

7. In the Create External Table from CSV dialog, confirm that the **sales** database is selected and that the name of the external table is **stockitemholdings**.

   ![The previously mentioned form is displayed.](media/ads-external-table-csv-wizard-active-connection.png 'Active SQL Server connections')

8. Select **Next**.

9. The next step displays a preview of the first 50 rows CSV data for validation. Select **Next** to continue.

   ![A preview of the CSV data is displayed.](media/ads-external-table-csv-preview.png 'Preview Data')

10. In the next step, you will be able to modify the columns of the external table you intend to create. You are able to alter the column name, change the data type, and allow for Nullable rows. For now, leave everything as-is and select **Next**.

    ![The Modify Columns step is displayed.](media/ads-external-table-csv-modify.png 'Modify Columns')

11. Verify that everything looks correct in the Summary step, then select **Create Table**.

    ![The Summary step is displayed.](media/ads-external-table-csv-create.png 'Summary')

12. As with the previous external table you created, a "Create External Table succeeded" dialog will appear under your task history in a few moments. Select the Servers link (Ctrl+Shift+D) on the left-hand menu, then expand the Tables list underneath your **sales** database and find the **dbo.stockitemholdings (External)** table. If you do not see it, right-click on the Tables folder, then select Refresh. **Right-click** the **dbo.stockitemholdings (External)** table, then choose **Select Top 1000** from the context menu.

    ![The Select Top 1000 rows menu item is highlighted.](media/ads-stockitemholdings-select-top-1000.png 'Select Top 1000')

13. Just as before, you should see a SQL query selecting the top 1000 rows and its query results, this time from the `stockitemholdings` table. Again, the SQL query is the same type of query you would write to select from a table internal to the sales database.

    ![The stockitemholdings query and results are displayed.](media/ads-stockitemholdings-results.png 'Stockitemholdings results')

    ```sql
    SELECT TOP (1000) [StockItemID]
        ,[QuantityOnHand]
        ,[BinLocation]
        ,[LastStocktakeQuantity]
        ,[LastCostPrice]
        ,[ReorderLevel]
        ,[TargetStockLevel]
        ,[LastEditedBy]
        ,[LastEditedWhen]
    FROM [sales].[dbo].[stockitemholdings]
    ```

### Task 3: Query and join data from flat files, data from external database systems, and SQL Server

Now that we have our two external tables added, we will now join those two external tables and two internal tables with a new SQL query to demonstrate how you can seamlessly combine all these data sources without having to copy any files or with separate queries or additional processing of that data.

1. **Right-click** the **sales** database, then select **New Query**.

   ![The sales database and New Query menu item are highlighted.](media/ads-new-query.png 'New Query')

2. Paste the following into the new query window:

   ```sql
   SELECT
    i.i_item_sk AS ItemID,
    i.i_item_desc AS Item,
    c.c_first_name AS FirstName,
    c.c_last_name AS LastName,
    s.QuantityOnHand,
    r.review AS Review,
    r.date_added AS DateReviewed
   FROM dbo.item as i
    INNER JOIN dbo.Reviews AS r ON i.i_item_sk = r.product_id
    INNER JOIN dbo.customer AS c ON c.c_customer_sk = r.customer_id
    INNER JOIN dbo.stockitemholdings AS s ON i.i_item_sk = s.StockItemID;
   ```

3. Select the **Run** button above the query window to execute.

   ![The Run button above the query window is highlighted.](media/ads-run.png 'Run')

4. At the bottom of the query window, you will see results that include columns from the four data sources.

   ![Query results from the four data sets.](media/ads-query-results.png 'Query results')

## Exercise 2: Using notebooks

Duration: 20 mins

Executable, or interactive, notebooks have a long history in science and academia. Notebooks were traditionally provided by applications such as [MATLAB](https://www.mathworks.com/products/matlab.html) and [Wolfram Mathematica](https://www.wolfram.com/mathematica/) to help scientists, students, professors, and mathematicians create self-documenting notebooks that others can use to reproduce experiments. To accomplish this, notebooks contain a combination of runnable code, output, formatted text, and visualizations. Over the past several years, web-based interactive notebooks have gained popularity with data scientists and data engineers to conduct exploratory data analysis and model training using a number of languages, such as Python, Scala, SQL, R, and others.

One of the most popular notebooks in use today are [Jupyter](http://jupyter.org/) notebooks. This is what SQL Server 2019 Big Data clusters use, and what you will be using in the exercises below.

Notebooks are made up of one or more of cells that allow for the execution of the code snippets or commands within those cells. They store commands and the results of running those commands. If you are used to developing software and applications using your favorite IDE, then you will realize that there are some disadvantages to using notebooks in place of a more traditional development platform. For example, you cannot set breakpoints and run in debug mode, allowing you to step through the code and inspect object and environment states during execution. However, there are many advantages notebooks do provide. They offer an environment that allows for exploration, documentation, collaboration, and visualization. When a data scientist creates and shares it with a colleague, they are sharing notes and insights about the data with access to all of the queries, formulas, visualizations, and models. This enables interactive conversations and further exploration, with simple reproducibility by anyone running the notebook in the same or similar environment, without others needing to know a sequence of shell commands and environment variables known only to the original author. This collaborative knowledge exchange within an easy to share self-contained package is far more valuable than simply sharing a static, final report.

### Task 1: Introduction to Jupyter notebooks

1. In Azure Data Studio, choose **File**, then **Open File...**.

2. In the folder browser dialog, navigate to the `C:\MCW-Modernizing-data-analytics-with-SQL-Server-2019-master\Hands-on lab\Resources` folder and select **notebook_00.ipynb**.

   ![The Open File dialog is displayed.](media/ads-open-notebook0.png 'Open File')

3. When the notebook opens, you need to select the **Kernel** you would like to use to run the notebook. Locate the **Kernel** dropdown in the toolbar above the notebook, then select **Python 3**.

   ![The Python 3 kernel is selected.](media/ads-notebook-select-kernel.png 'Kernel dropdown')

4. After selecting the Kernel, you may be prompted to install Python for Notebooks components. If you see this, select **New Python installation**. Select **Install**. This may take **several minutes to complete**.

   ![The dialog is displayed.](media/ads-configure-python-for-notebooks.png 'Configure Python for Notebooks')

   While it is running, you will see the install progress in the **Tasks** tab, and the **Kernel** will display "Changing kernel..." in the dropdown.

   ![The installation status is displayed.](media/ads-configure-python-for-notebooks-running.png 'Tasks')

5. After the Python components are installed, make sure that **Python 3** is your selected **Kernel**, then follow the instructions within the notebook. You can execute each code cell by selecting it and pressing **F5** on your keyboard, or by clicking the Run icon to the left of the cell.

   ![The Run icon is highlighted.](media/ads-notebook-run.png 'Notebook cell')

### Task 2: Querying the SQL Server Master Instance (MI)

In this task, you will learn how to run standard SQL Server Queries against the Master Instance (MI) in a SQL Server big data cluster.

1. In Azure Data Studio, select **File**, then **Open File...**.

2. In the folder browser dialog, navigate to the `C:\MCW-Modernizing-data-analytics-with-SQL-Server-2019-master\Hands-on lab\Resources` folder and select **notebook_01.ipynb**.

3. When the notebook opens, you may need to select the **Kernel** you would like to use to run the notebook. Locate the **Kernel** dropdown in the toolbar above the notebook, then select **SQL** if it is not already set.

4. Follow the instructions within the notebook.

### Task 3: Virtualizing data with scripts

Earlier in this lab, you virtualized data using the UI components within Azure Data Studio to create external tables from an external database and from flat files. In this task, you will use a notebook to create and query Virtualized Data in a SQL Server big data cluster.

- You'll start with creating a text file format, since that's the type of data you are reading in.
- Next, you'll create a data source for the SQL Storage Pool, since that allows you to access the HDFS system in BDC.
- Finally, you'll create an External Table, which uses the previous steps to access the data.

1. In Azure Data Studio, select **File**, then **Open File...**.

2. In the folder browser dialog, navigate to the `C:\MCW-Modernizing-data-analytics-with-SQL-Server-2019-master\Hands-on lab\Resources` folder and select **notebook_02.ipynb**.

3. When the notebook opens, you may need to select the **Kernel** you would like to use to run the notebook. Locate the **Kernel** dropdown in the toolbar above the notebook, then select **SQL** if it is not already set.

4. Follow the instructions within the notebook.

### Task 4: Creating and querying a Data Mart

In this task, you will learn how to create and query a Data Mart using Virtualized Data in a SQL Server big data cluster.

Wide World Importers is interested in ingesting the data from web logs from an HDFS source where they have been streamed. They want to be able to analyze the traffic to see if there is a pattern in time, products, or locations.

The web logs, however, are refreshed periodically. WWI would like to keep the logs in local storage to do deeper analysis.

In this Jupyter Notebook you'll create a location to store the log files as a SQL Server Table in the SQL Data Pool, and then fill it by creating an External Table that reads HDFS.

1. In Azure Data Studio, select **File**, then **Open File...**.

2. In the folder browser dialog, navigate to the `C:\MCW-Modernizing-data-analytics-with-SQL-Server-2019-master\Hands-on lab\Resources` folder and select **notebook_03.ipynb**.

3. When the notebook opens, you may need to select the **Kernel** you would like to use to run the notebook. Locate the **Kernel** dropdown in the toolbar above the notebook, then select **SQL** if it is not already set.

4. Follow the instructions within the notebook.

### Task 5: Using the powerful Spark engine for data exploration

In this task, you will learn how to work with Spark Jobs in a SQL Server big data cluster.

Apache Spark is an open-source processing framework that runs large-scale data analytics applications. Spark is built on an in-memory compute engine, which enables high-performance querying on big data. It takes advantage of a parallel data-processing framework that persists data in-memory and disk if needed. This allows Spark to deliver 100-times faster speed and a common execution model for tasks such as extract, transform, load (ETL), batch, interactive queries and others on data in an Apache Hadoop Distributed File System (HDFS).

Many times, Spark is used to do transformations on data at large scale. In this Jupyter Notebook, you'll read a large text file into a Spark DataFrame, and then save out the top 10 examples as a table using SparkSQL.

1. In Azure Data Studio, select **File**, then **Open File...**.

2. In the folder browser dialog, navigate to the `C:\MCW-Modernizing-data-analytics-with-SQL-Server-2019-master\Hands-on lab\Resources` folder and select **notebook_04.ipynb**.

3. When the notebook opens, you may need to select the **Kernel** you would like to use to run the notebook. Locate the **Kernel** dropdown in the toolbar above the notebook, then select **PySpark** if it is not already set.

4. Follow the instructions within the notebook.

## Exercise 3: Machine learning

Duration: 15 mins

In this exercise, you will use Azure Data Studio to execute a notebook that will enable you to train a model to predict the battery lifetime, apply the model to make batch predictions against a set of vehicle telemetry and save the scored telemetry to an external table that you can query using SQL.

Wide World Importers has refrigerated trucks to deliver temperature-sensitive products. These are high-profit, high-expense items. In the past, there have been failures in the cooling systems and the primary culprit has been the deep-cycle batteries used in the system.

WWI began replacing the batteries every three months as a preventative measure, but this has a high cost. Recently, the taxes on recycling batteries has increased dramatically. The CEO has asked the Data Science team if they can investigate creating a Predictive Maintenance system to more accurately tell the maintenance staff how long a battery will last, rather than relying on a flat 3 month cycle.

The trucks have sensors that transmit data to a file location. The trips are also logged. In this Jupyter Notebook, you'll create, train and store a Machine Learning model using SciKit-Learn, so that it can be deployed to multiple hosts.

### Task 1: Train a machine learning model

1. In Azure Data Studio, select **File**, then **Open File...**.

2. In the folder browser dialog, navigate to the `C:\MCW-Modernizing-data-analytics-with-SQL-Server-2019-master\Hands-on lab\Resources` folder and select **predict-battery-life-with-sqlbdc.ipynb**.

3. Select **Open**.

4. Follow the instructions in the notebook and return to the next step after you have completed the notebook.

   > There may be a kernel error pertaining to there not being a valid SQL connection when you open the notebook. If this happens, close the notebook and Azure Data Studio, then re-launch, reconnect, then re-open the notebook.

### Task 2: Score and save data as an external table

1.  In Azure Data Studio, under Servers, expand your connected cluster, `Data Services`, `HDFS`, `data`.

2.  Right-click the `data` folder and select `Refresh` to see the newly created folder.

    ![Refresh data](media/ads-refresh-data.png 'Refresh data')

3.  You should see `battery-life.csv` as a folder, expand it and then right-click on the CSV file whose name starts with `part-00000-` and select `Create External Table From CSV Files`.

    ![Create External Table](media/ads-battery-create-external-menu.png 'Create External Table')

4.  In Step 1 of the wizard, select the `sales` database and for the `Name for new external table` field provide **battery-life-predictions**. Select **Next**.

    ![Step 1 of the wizard is displayed.](media/ads-predictions-csv-wizard-step1.png 'Step 1')

5.  On Step 2, Preview Data, select **Next**.

6.  On Step 3, for the column `Car_Has_EcoStart` set the Data Type to **char(10)**. Select **Next**.

    ![Step 3 of the wizard is displayed.](media/ads-predictions-csv-wizard-step3.png 'Step 3')

7.  On Step 4, select **Create Table**. Your predictions are now available for SQL querying in the battery-life-predictions table in the sales database.

8.  In Azure Data Studio, Servers, expand your Big Data Cluster, `Databases`, `sales`, right-click `Tables` and then select `Refresh`.

    ![Refresh the sales database tables.](media/ads-refresh-sales.png 'Refresh sales')

9.  Expand `tables`, right-click `battery-life-prediction` and choose **Select Top 1000** to view the data contained by the external table.

    ![Select Top 1000 records.](media/ads-predictions-select-top.png 'Select Top 1000')

10. The vehicle telemetry along with predictions will appear. These are queried from the external table which is sourced from the CSV you created using the notebook.

    ![View data](media/task02-view-data.png 'View data')

## Exercise 4: Identify PII and GDPR-related compliance issues using Data Discovery & Classification in SSMS

Duration: 15 mins

WWI has several databases that include tables containing sensitive data, such as personally identifiable information (PII) like phone numbers, social security numbers, financial data, etc. Since some of their personnel and customer data include individuals who reside within the European Union (EU), they need to adhere to the General Data Protection Regulation ([GDPR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation)) as well. Because of this, WWI is required to provide periodic data auditing reports to identify sensitive and GDPR-related data that reside within their various databases.

With SQL Server Management Studio, they are able to identify, classify, and generate reports on sensitive and GDPR-related data by using the [SQL Data Discovery & Classification](https://docs.microsoft.com/sql/relational-databases/security/sql-data-discovery-and-classification?view=sql-server-ver15) tool. This tool introduces a set of advanced services, forming a new SQL Information Protection paradigm aimed at protecting the data, not just the database:

- **Discovery & recommendations** - The classification engine scans your database and identifies columns containing potentially sensitive data. It then provides you an easy way to review and apply the appropriate classification recommendations, as well as to manually classify columns.
- **Labeling** - Sensitivity classification labels can be persistently tagged on columns.
- **Visibility** - The database classification state can be viewed in a detailed report that can be printed/exported to be used for compliance & auditing purposes, as well as other needs.

### Task 1: Use the Data Discovery & Classification in SSMS

In this task, you will run the SQL Data Discovery & Classification tool against their customer database, which includes personal, demographic, and sales data.

1.  Open SQL Server Management Studio (SSMS) and connect to your SQL Server 2019 cluster.

2.  Right-click on the **sales** database, then choose **Tasks > Classify Data...**.

    ![The sales database, Tasks menu, and Classify Data items are highlighted.](media/ssms-classify-data-link.png 'Data Classification')

3.  When the tool runs, it will analyze all of the columns within all of the tables and recommend appropriate data classifications for each. What you should see is the Data Classification dashboard showing no currently classified columns, and a classification recommendations box at the top showing that there are 44 columns that the tool identified as containing sensitive (PII) or GDPR-related data. **Select** on this classification recommendations box.

    ![The data classification recommendations box is highlighted.](media/ssms-classification-recommendations-box.png 'Data classification recommendations box')

4.  The list of recommendations displays the schema, table, column, type of information, and recommended sensitivity label for each identified column. You can change the information type and sensitivity labels for each if desired. In this case, accept all recommendations by **checking the checkbox** in the recommendations table header.

    ![The recommendations are shown with each checkbox checked.](media/ssms-recommendations.png 'Classification recommendations')

5.  Select **Accept selected recommendations**.

    ![The Accept selected recommendations button is highlighted.](media/ssms-accept-selected-recommendations.png 'Accept selected recommendations')

6.  Select **Save** in the toolbar above to apply your changes.

    ![The Save button is highlighted.](media/ssms-save-classification-changes.png 'Save classification changes')

7.  After the changes are saved, click **View Report**.

    ![The View Report button is highlighted.](media/ssms-view-report.png 'View Report')

8.  What you should see is a report with a full summary of the database classification state. When you right-click on the report, you can see options to print or export the report in different formats.

    ![The report is displayed, as well as the context menu showing export options after right-clicking on the report.](media/ssms-report.png 'SQL Data Classification Report')

### Task 2: Fix compliance issues with dynamic data masking

Some of the columns identified by the Data Discovery & Classification tool as containing sensitive (PII/GDPR) information include phone numbers, email addresses, billing addresses, and credit card numbers. One way to ensure compliance with various rules and regulations that enforce policies to protect such sensitive data is to prevent those who are not authorized from seeing it. An example would be displaying `XXX-XXX-XX95` instead of `123-555-2695` when outputting a phone number within a SQL query result, report, web page, etc. This is commonly called data masking. Traditionally, modifying systems and applications to implement data masking can be challenging. This is especially true when the masking has to apply all the way down to the data source level. Fortunately, SQL Server and its cloud-related product, Azure SQL Database, provides a feature named [dynamic data masking](https://docs.microsoft.com/sql/relational-databases/security/dynamic-data-masking?view=sql-server-ver15) (DDM) to automatically protect this sensitive data from non-privileged users.

Dynamic data masking helps prevent unauthorized access to sensitive data by enabling customers to designate how much of the sensitive data to reveal with minimal impact on the application layer. DDM can be configured on the database to hide sensitive data in the result sets of queries over designated database fields, while the data in the database is not changed. Dynamic data masking is easy to use with existing applications, since masking rules are applied in the query results. Many applications can mask sensitive data without modifying existing queries.

In this task, you will apply dynamic data masking to one of the database fields so you can see how to address the reported compliance issues. To test the data mask, you will create a test user and query the field as that user.

1. Open SQL Server Management Studio (SSMS) and connect to your SQL Server 2019 cluster.

2. Expand the databases list, right-click on **sales**, then select **New Query**.

   ![The sales database and New Query menu item are highlighted.](media/ssms-sales-new-query.png 'New Query')

3. Add a dynamic data mask to the existing `dbo.customer.c_last_name` field by pasting the below query into the new query window:

   ```sql
   ALTER TABLE dbo.customer
   ALTER COLUMN c_last_name ADD MASKED WITH (FUNCTION = 'partial(2,"XXX",0)');
   ```

   > The `partial` custom string masking method above exposes the first two characters and adds a custom padding string after for the remaining characters. The parameters are: `prefix,[padding],suffix`

4. Execute the query by clicking the **Execute** button above the query window, or enter _F5_.

   ![The dynamic data mask query is shown and the Execute button is highlighted above.](media/ssms-execute-ddm-query.png 'Execute query')

5. Clear the query window and replace the previous query with the following to add a dynamic data mask to the `dbo.customer.c_email_address` field:

   ```sql
   ALTER TABLE dbo.customer
   ALTER COLUMN c_email_address ADD MASKED WITH (FUNCTION = 'email()');
   ```

   > The `email` masking method exposes the first letter of an email address and the constant suffix ".com", in the form of an email address: `aXXX@XXXX.com`.

6. Clear the query window and replace the previous query with the following, selecting all rows from the customer table:

   ```sql
   SELECT * FROM dbo.customer
   ```

   ![The query results are shown with no mask applied to the Postal Code field.](media/ssms-ddm-results-no-mask.png 'Query results')

7. Notice that the full last name and email address values are visible. That is because the user you are logged in as a privileged user. Let's create a new user and execute the query again:

   ```sql
   CREATE USER TestUser WITHOUT LOGIN;
   GRANT SELECT ON dbo.customer TO TestUser;

   EXECUTE AS USER = 'TestUser';
   SELECT * FROM dbo.customer;
   REVERT;
   ```

8. Execute the query by clicking the **Execute** button. Notice this time that the Postal Code values are masked (`90XXX`).

   ![The query results are shown with the mask applied to the Postal Code field.](media/ssms-ddm-results-mask.png 'Query results')

## Exercise 5: Exploring intelligent query processing (QP) features

Duration: 15 mins

In this exercise, you will execute a series of SQL scripts in SQL Server Management Studio (SSMS) to explore the improvements to the family of intelligent query processing (QP) features in SQL Server 2019. These features improve the performance of existing workloads with minimal work on your part to implement. The key to enabling these features in SQL Server 2019 is to set the [database compatibility level](https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql-compatibility-level?view=sql-server-ver15) to `150`. You will be executing these queries against the `sales` database.

To learn more, read [intelligent query processing](https://docs.microsoft.com/sql/relational-databases/performance/intelligent-query-processing?view=sql-server-ver15) in SQL databases.

### Task 1: Set database compatibility level

1. To get started, expand databases in the SQL Server Management Studio (SSMS) Object Explorer, right-click the `sales` database, and then select **New Query**.

   ![The sales database and New Query menu item are highlighted.](media/ssms-sales-new-query.png 'New Query')

2. The first query you will run is to set the database compatibility level to `150`, which is the new compatibility level for SQL Server 2019, enabling the most recent intelligent QP features. Copy the SQL script below and paste it into the new query window.

   ```sql
   USE sales;
   GO

   ALTER DATABASE sales
   SET COMPATIBILITY_LEVEL = 150;
   GO
   ```

3. To run the query, select **Execute** in the SSMS toolbar.

   ![The Execute button is highlighted in the SSMS toolbar.](media/ssms-execute-query.png 'Execute')

### Task 2: Scalar UDF inlining

Next, you will run a query to create a user-defined function (UDF) named `customer_category`. This UDF contains several steps to identify the discount price category for each customer. Notice that at the top of the query we run to create this UDF sets the database compatibility level to `150`, which is the new compatibility level for SQL Server 2019, enabling the most recent intelligent QP features. This UDF will be called inline from the two queries that follow in order to show QP improvements on scalar UDF inlining.

1. Paste the following SQL code into your query window, overwriting the current content, and then select **Execute** on the SSMS toolbar.

   ```sql
   USE sales;
   GO

   ALTER DATABASE SCOPED CONFIGURATION
   CLEAR PROCEDURE_CACHE;
   GO

   CREATE OR ALTER FUNCTION
     dbo.customer_category(@CustomerKey INT)
   RETURNS CHAR(10) AS
   BEGIN
     DECLARE @total_amount DECIMAL(18,2);
     DECLARE @category CHAR(10);

     SELECT @total_amount =
     SUM([ws_net_paid_inc_ship])
     FROM [dbo].[web_sales]
     WHERE [ws_bill_customer_sk] = @CustomerKey;

     IF @total_amount < 50000
       SET @category = 'REGULAR';
     ELSE IF @total_amount < 100000
       SET @category = 'GOLD';
     ELSE
       SET @category = 'PLATINUM';

     RETURN @category;
   END
   GO
   ```

   > Scalar UDF inlining automatically transforms [scalar UDFs](https://docs.microsoft.com/sql/relational-databases/user-defined-functions/create-user-defined-functions-database-engine?view=sql-server-2017#Scalar) into relational expressions. It embeds them in the calling SQL query. This transformation improves the performance of workloads that take advantage of scalar UDFs. Scalar UDF inlining facilitates cost-based optimization of operations inside UDFs. The results are efficient, set-oriented, and parallel instead of inefficient, iterative, serial execution plans. This feature is enabled by default under database compatibility level 150. _For more information, see [Scalar UDF inlining](https://docs.microsoft.com/sql/relational-databases/user-defined-functions/scalar-udf-inlining?view=sql-server-2017)_.

2. Right-click on the `sales` database, then select **New Query**. This will open a new query window into which you can paste the following queries. You may wish to reuse the same query window, replacing its contents with each SQL statement blocks below, or follow these same steps to create new query windows for each.

   ![The sales database and New Query menu item are highlighted.](media/ssms-sales-new-query.png 'New Query')

3. The query below selects the top 100 rows from the `customer` table, calling the `customer_category` user-defined function (UDF) inline for each row. It uses the `DISABLE_TSQL_SCALAR_UDF_INLINING` hint to disable the new scalar UDF inlining QP feature. Paste the following query into the empty query window. **Do not execute yet**.

   ```sql
   USE sales;
   GO

   -- Before (show actual query execution plan for legacy behavior)
   SELECT TOP 100
       [c_customer_sk], [c_first_name], [c_last_name],
         dbo.customer_category([c_customer_sk]) AS [Discount Category]
   FROM [dbo].[customer]
   ORDER BY [c_customer_sk]
   OPTION (RECOMPILE, USE HINT('DISABLE_TSQL_SCALAR_UDF_INLINING'));
   ```

4. Select the **Include Actual Execution Plan** (Ctrl+M) button in the toolbar above the query window. This will allow us to view the actual (not estimated) query plan after executing the query.

   ![The Actual Query Plan button is highlighted in the toolbar.](media/ssms-enable-actual-query-plan-customer.png 'Enable Actual Query Plan')

5. Execute the query by selecting **Execute** from the SSMS toolbar.

6. After the query executes, select the **Execution plan** tab. As the plan shows, SQL Server adopts a simple strategy here: for every tuple in the `customer` table, invoke the UDF and output the results (single line from the clustered index scan to compute scalar). This strategy is naïve and inefficient, especially with more complex queries.

   ![This screenshot shows the query execution plan using the legacy method.](media/ssms-udf-inlining-before.png 'Query execution plan with legacy method')

7. Clear the query window, or open a new one, then paste the following query that makes use of the scalar UDF inlining QP feature. If you opened a new query window instead of reusing this one, make sure to select the **Include Actual Execution Plan** button to enable it. **Execute** the query.

   ```sql
   USE sales;
   GO

   -- After (show actual query execution plan for legacy behavior)
   SELECT TOP 100
       [c_customer_sk], [c_first_name], [c_last_name],
         dbo.customer_category([c_customer_sk]) AS [Discount Category]
   FROM [dbo].[customer]
   ORDER BY [c_customer_sk]
   OPTION (RECOMPILE);
   ```

8. After the query executes, select the **Execution plan** tab once again. With scalar UDF inlining, this UDF is transformed into equivalent scalar subqueries, which are substituted in the calling query in place of the UDF.

   ![This screenshot shows the query execution plan using the new QP feature.](media/ssms-udf-inlining-after.png 'Query execution plan with new method')

   > As you can see, the query plan no longer has a user-defined function operator, but its effects are now observable in the plan, like views or inline TVFs. Here are some key observations from the above plan:

   A. SQL Server has inferred the implicit join between `dbo.customer` and `dbo.web_sales` and made that explicit via a join operator.

   B. SQL Server has also inferred the implicit `GROUP BY [Customer Key] on dbo.web_sales` and has used the IndexSpool + StreamAggregate to implement it.

   > Depending upon the complexity of the logic in the UDF, the resulting query plan might also get bigger and more complex. As we can see, the operations inside the UDF are now no longer a black box, and hence the query optimizer is able to cost and optimize those operations. Also, since the UDF is no longer in the plan, iterative UDF invocation is replaced by a plan that completely avoids function call overhead.

### Task 3: Table variable deferred compilation

1. Either highlight and delete everything in the query window, or open a new query window. Paste the following query into the query window. This query makes use of the table variable deferred compilation feature, since the database compatibility level is set to `150`. If you opened a new query window instead of reusing this one, make sure to select the **Include Actual Execution Plan** button to enable it. **Execute** the query.

   ```sql
   USE sales
   GO

   DECLARE @ItemClick TABLE (
     [itemKey] BIGINT NOT NULL,
     [clickDate] BIGINT NOT NULL
   );

   INSERT @ItemClick
   SELECT [wcs_item_sk], [wcs_click_date_sk]
   FROM [dbo].[web_clickstreams]

   -- Look at estimated rows, speed, join algorithm
   SELECT i.[i_item_sk], i.[i_current_price], c.[clickDate]
   FROM dbo.item AS i
   INNER JOIN @ItemClick AS c
     ON i.[i_item_sk] = c.[itemKey]
   WHERE i.[i_current_price] > 90
   ORDER BY i.[i_current_price] DESC
   OPTION (USE HINT('DISABLE_DEFERRED_COMPILATION_TV'));
   GO
   ```

   > The script above assigns a table variable, `@ItemClick`, storing the `itemKey` and `clickDate` fields from the `web_clickstreams` table to be used in an INNER JOIN below.

   > The `DISABLE_DEFERRED_COMPILATION_TV` hint **disables** the table-deferred compilation feature.

   **Old method**

   In prior versions of SQL Server (compatibility level of 140 or lower), the table variable deferred compilation QP feature is not used (more on this below).

   There are two plans. The one you want to observe is the second query plan. Because we disabled the table-deferred compilation feature with the `DISABLE_DEFERRED_COMPILATION_TV` hint, when we mouse over the INNER JOIN to view the estimated number of rows and the output list, which shows the join algorithm. The estimated number of rows is 1. Also, observe the execution time. In our case, it took 10 seconds to complete.

   ![This screenshot shows the query execution plan using the legacy method.](media/ssms-tvdc-old-method.png 'Query execution plan with old method')

   **New method**

   Execute the following updated query, which removes the hint we used in the previous query to disable the table-deferred compilation feature:

   ```sql
   USE sales
   GO

   DECLARE @ItemClick TABLE (
     [itemKey] BIGINT NOT NULL,
     [clickDate] BIGINT NOT NULL
   );

   INSERT @ItemClick
   SELECT [wcs_item_sk], [wcs_click_date_sk]
   FROM [dbo].[web_clickstreams]

   -- Look at estimated rows, speed, join algorithm
   SELECT i.[i_item_sk], i.[i_current_price], c.[clickDate]
   FROM dbo.item AS i
   INNER JOIN @ItemClick AS c
     ON i.[i_item_sk] = c.[itemKey]
   WHERE i.[i_current_price] > 90
   ORDER BY i.[i_current_price] DESC;
   GO
   ```

   After the query above executes, select the **Execution plan** tab once again. Since our database compatibility level is set to 150, notice that the join algorithm is a hash match, and that the overall query execution plan looks different. When you hover over the INNER JOIN, notice that there is a high value for estimated number of rows and that the output list shows the use of hash keys and an optimized join algorithm. Once again, observe the execution time. In our case, it took 6 seconds to complete, which is approximately half the time it took to execute without the table variable deferred compilation feature.

   ![This screenshot shows the query execution plan using the new method.](media/ssms-tvdc-new-method.png 'Query execution plan with new method')

   > Table variable deferred compilation improves plan quality and overall performance for queries that reference table variables. During optimization and initial compilation, this feature propagates cardinality estimates that are based on actual table variable row counts. This accurate row count information optimizes downstream plan operations. Table variable deferred compilation defers compilation of a statement that references a table variable until the first actual run of the statement. This deferred compilation behavior is the same as that of temporary tables. This change results in the use of actual cardinality instead of the original one-row guess. _For more information, see [Table variable deferred compilation](https://docs.microsoft.com/sql/t-sql/data-types/table-transact-sql?view=sql-server-2017#table-variable-deferred-compilation)._

### Task 4: Row mode memory grant feedback

1. Either highlight and delete everything in the query window, or open a new query window. Paste the following query to simulate out-of-date statistics on the `web_sales` table, followed by a query that executes a hash match. If you opened a new query window instead of reusing this one, make sure to select the **Include Actual Execution Plan** button to enable it. **Execute** the query.

   ```sql
   USE sales;
   GO

   -- Simulate out-of-date stats
   UPDATE STATISTICS dbo.web_sales
   WITH ROWCOUNT = 1;
   GO

   SELECT
     ws.[ws_order_number], ws.ws_quantity,
     i.[i_current_price], i.[i_item_desc]
   FROM    dbo.web_sales AS ws
   INNER HASH JOIN dbo.[item] AS i
     ON ws.[ws_item_sk] = i.[i_item_sk]
   WHERE   i.[i_current_price] > 10
     AND ws.[ws_quantity] > 40;
   ```

2. After the query executes, select the **Execution plan** tab. Hover over the Hash Match step of the execution plan. You should see a warning toward the bottom of the Hash Match dialog showing spilled data. Also observe the execution time. In our case, this query took 16 seconds to execute.

   ![The Hash Match dialog shows spilled data warnings.](media/ssms-memory-grant-feedback-old.png 'Query execution plan showing spilled data')

3. Either highlight and delete everything in the query window, or open a new query window. Paste the following query to execute the select query that contains the hash match once more. If you opened a new query window instead of reusing this one, make sure to select the **Include Actual Execution Plan** button to enable it. **Execute** the query.

   ```sql
   USE sales;
   GO

   SELECT
     ws.[ws_order_number], ws.ws_quantity,
     i.[i_current_price], i.[i_item_desc]
   FROM    dbo.web_sales AS ws
   INNER HASH JOIN dbo.[item] AS i
     ON ws.[ws_item_sk] = i.[i_item_sk]
   WHERE   i.[i_current_price] > 10
     AND ws.[ws_quantity] > 40;
   ```

4. After the query executes, select the **Execution plan** tab. Hover over the Hash Match step of the execution plan. You may no longer see a warning about spilled data. If you do, the **number of pages Hash wrote** should have decreased. This happens as the STATISTICS table is updated with each run.

    ![The Hash Match dialog shows spilled data warnings, but with fewer written pages.](media/ssms-memory-grant-feedback-pages-decreased.png "Query execution plan showing fewer pages.")

5. Execute the query 2-3 more times. Each time, select the **Execution plan** tab and hover over the Hash Match step of the execution plan. After a few executions, you should **no longer** see a warning about spilled data.

   ![The Hash Match dialog no longer contains spilled data warnings.](media/ssms-memory-grant-feedback-fix.png 'Query execution plan with no spilled data')

   > So what happened? A query's post-execution plan in SQL Server includes the minimum required memory needed for execution and the ideal memory grant size to have all rows fit in memory. Performance suffers when memory grant sizes are incorrectly sized. Excessive grants result in wasted memory and reduced concurrency. Insufficient memory grants cause expensive spills to disk. By addressing repeating workloads, batch mode memory grant feedback recalculates the actual memory required for a query and then updates the grant value for the cached plan. **When an identical query statement is executed**, the query uses the revised memory grant size, reducing excessive memory grants that impact concurrency and fixing underestimated memory grants that cause expensive spills to disk. Row mode memory grant feedback expands on the batch mode memory grant feedback feature by adjusting memory grant sizes for both batch and row mode operators. _For more information, see [Row mode memory grant feedback](https://docs.microsoft.com/sql/relational-databases/performance/adaptive-query-processing?view=sql-server-2017#row-mode-memory-grant-feedback)._

## Exercise 6: Monitoring the big data cluster

Duration: 20 mins

When you need to monitor and troubleshoot your big data cluster, some of your options are quite different than what you may be used to in a typical Windows-based, or even Linux installation. No longer are you viewing Windows event logs or other familiar locations to view metrics and system-level information about your SQL environment. This is because the services that comprise your big data cluster are distributed across multiple Kubernetes pods. If you are unfamiliar with Kubernetes or Docker containers, then you may not know where to start.

On the other hand, monitoring and managing SQL Server 2019 itself is very much the [same process as you would normally perform for any SQL Server system](https://docs.microsoft.com/en-us/sql/relational-databases/database-lifecycle-management?view=sql-server-ver15). You have the same type of services, surface points, security areas, and other control factors as in a stand-alone installation of SQL server. The tools you have available for managing the Master Instance in the SQL Server BDC are the same as managing a stand-alone installation, including SQL Server Management Studio, command-line interfaces, Azure Data Studio, and third party tools.

For the cluster components, you have three primary interfaces to use: The cluster administration portal, kubectl (Kubernetes tool), and the Kubernetes dashboard. For this exercise, we will focus on reviewing the first two.

### Task 1: Use the Big Data Cluster dashboard

Azure Data Studio includes a SQL Server Big Data Cluster dashboard which allows you to monitor and troubleshoot your SQL Server 2019 Big Data cluster.

The tab allows you to:

- View cluster details for your SQL Server, HDFS, and Spark clusters
- Monitor deployment status
- View available service endpoints
- Drill down information on pods, including accessing Grafana dashboards and Kibana logs

1. Open up Azure Data Studio and connect to your SQL Server Big Data Cluster's master instance.  Right-click on the master instance and select **Manage**.

  ![The Azure Data Studio context menu for our SQL Server Big Data Cluster, with Manage highlighted.](media/ads-management-manage.png "Manage")

2. On the instance management dashboard, click the **SQL Server Big Data Cluster** tab.  Then, on the SQL Server Big Data Cluster tab, click on the **Cluster Dashboard** button.  This will open up a new Big Data Cluster dashboard.

  ![The SQL Server Big Data Cluster tab, which contains a Cluster Dashboard button to click.](media/ads-management-bdc-tab.png "Cluster Dashboard")

3. The Big Data Cluster overview contains a brief overview of your Big Data Cluster's health, services, and service endpoints.  For now, click on the SQL Server link.

  ![The SQL Server Big Data Cluster overview, which contains a SQL Server link to click.](media/ads-management-bdc-overview.png "Big Data Cluster overview")

4. The SQL Server details section shows information on your master instance, as well as your compute, data, and storage pods.  Click on the **View** link under SQL Metrics.  This will open a browser window and connect to Grafana.

  ![In SQL Server cluster details, click the View link under SQL Metrics.](media/ads-management-bdc-sql-metrics.png "View in Grafana")

Grafana will appear, along with details on your SQL Server instance.  Spend some time viewing the available metrics and graphs on the Grafana dashboard.  You can also change between instances by selecting the appropriate instance in the Host drop-down list.
  
  ![SQL Server Big Data Cluster master instance metrics in Grafana.](media/ads-management-grafana.png "SQL Server Metrics from Grafana")

5. Return to the Big Data Cluster Dashboard.  Then, click the **View** link under Node Metrics.  This will once again take you to Grafana, but this time you will see the Host Node Metrics dashboard,  which contains details on the Azure Kubernetes Services nodes which make up your service cluster.

  ![In SQL Server cluster details, click the View link under SQL Metrics.](media/ads-management-bdc-node-metrics.png "View in Grafana")

These measures will be important for troubleshooting Azure Kubernetes Service issues, as well as uptime and health checks.

  ![Azure Kubernetes Service host node metrics in Grafana.](media/ads-management-grafana-host-node.png "Host Node Metrics from Grafana")

6. Return to the Big Data Cluster Dashboard.  Then, click the **View** link under Logs.  This will take you to Kibana.

  ![In SQL Server cluster details, click the View link under Logs.](media/ads-management-bdc-logs.png "View in Kibana")

Kibana is a log visualization product which is part of the Elasticsearch-Logstash-Kibana (ELK) stack of open-source log management tools.  SQL Server Big Data Clusters use Logstash to move log data into Elasticsearch, a product which specializes in indexing logs and other documents.  From there, Kibana allows us to view what is in the logs, reviewing and visualizing results.

  ![Logged messages concerning the master SQL Server instance in the past 15 minutes.](media/ads-management-kibana.png "Kibana")

7. Return to the Big Data Cluster Dashboard.  Then, review node metrics and logs for other services, including HDFS and Spark.  These links will take you to Grafana and Kibana, respectively, and will provide measures and information for these services.

8. After you have reviewed Grafana and Kibana, return to the Big Data Cluster Dashboard.  Then, click the **Big data cluster overview** link and then the **Troubleshoot** button.

  ![In the SQL Server Big Data Cluster Dashboard, click the Troubleshoot button.](media/ads-management-troubleshoot.png "Troubleshoot")

This brings up a Jupyter notebook designed to troubleshoot basic availability scenarios.

  ![The Big Data Cluster troubleshooter, with links to other notebooks.](media/ads-management-tsg.png "A troubleshooting guide")

Review the notebook and click on links to additional notebooks and Standard Operating Procedures, such as SOP007, which returns version information. 

  ![A Standard Operating Procedure notebook for determining version information for tools.](media/ads-management-tsg-sop007.png "Version information Standard Operating Procedure guide")

You can also view the entire set of notebooks in Azure Data Studio by clicking the Jupyter Books button.  This will show the **Operations and Support - SQL Server 2019 Big Data Clusters** collection of Jupyter notebooks.  Review these notebooks to learn more about how to troubleshoot individual components of a Big Data Cluster.

  ![The set of notebooks available for SQL Server 2019 Big Data Clusters.](media/ads-management-jupyter-books.png "Jupyter Books")

### Task 2: Monitor and troubleshoot using kubectl commands

> For all of the commands you will execute, replace **CLUSTER_NAMESPACE** with the big data cluster namespace you defined when deploying your cluster.  By default, this is **mssql-cluster**.

Before executing these commands, you will need to make sure you are authenticated to Azure. If not, sign in using **az login**.

1. Open a new Windows command prompt.

2. Execute the following kubectl command to show the status of all the pods in your SQL Server big data cluster. Remember, **replace** CLUSTER_NAMESPACE with your own namespace.

   ```bash
   kubectl get pods -n CLUSTER_NAMESPACE
   ```

   ![Get pods command.](media/kubectl-get-pods.png 'Command prompt')

3. Now, let's get some more details about one of the pods. In the list from the previous output, you should see a pod named **master-0**. Use the `describe` command to get a detailed description of a specific pod in json format. It includes details such as the current Kubernetes node that the pod is placed on, the containers running within the pod, and the image used to bootstrap the containers. It also shows other details, such as labels, status, and persisted volumes claims that are associated with the pod. If any errors have occurred, you can sometimes see the error in the recent events for the pod.

   ```bash
   kubectl describe pod master-0 -n CLUSTER_NAMESPACE
   ```

   ![Describe pod command shows no errors in recent events.](media/kubectl-describe-pod.png 'Command prompt')

   In our case, the `master-0` pod shows no errors in recent events.

4. As you saw in the previous section, you can view the logs through Kibana from the SQL Server Big Data Cluster Dashboard. However, sometimes you want quick access to download all the logs for containers running within a pod. Run the command below to output the logs for all containers running in the `master-0` pod to a new file named `master-0-pod-logs.txt`.

   ```bash
   kubectl logs master-0 --all-containers=true -n CLUSTER_NAMESPACE > master-0-pod-logs.txt
   ```

5. A useful command that you may run relatively often is the `get svc` command. This returns details about your big data cluster services, including their type, IP, and ports. We've referred to this command a few times throughout the lab to show how you can retrieve the external IP address and port for services such as the cluster admin portal, Knox, and the SQL master instance.

   ```bash
   kubectl get svc -n CLUSTER_NAMESPACE
   ```

6. The command to retrieve service details is very similar to the one you ran to retrieve details about a pod. You can use this command to get a detailed description about a service in JSON format, such as IP, external IP, port, labels, selector, etc. In this case, we will retrieve service details for `master-svc-external`. Simply swap the service name for another to view details about that service.

   ```bash
   kubectl describe service master-svc-external -n CLUSTER_NAMESPACE
   ```

7. Besides retrieving useful information about pods, containers, and services, you can execute commands in a container as well. It is necessary at times to perform certain tasks by logging into a container, like checking if a certain file exists or restarting services in the container. You use this by executing the `kubectl exec` command. The syntax is as follows: `kubectl exec -it <pod_name> -c <container_name> -n <namespace_name> -- /bin/bash <command name>`. Execute the following command to log in to the `mssql-server` container within the `master-0` pod and restart the SQL Server process (remember to replace CLUSTER_NAMESPACE with your namespace):

   ```bash
   kubectl exec -it master-0  -c mssql-server -n CLUSTER_NAMESPACE -- /bin/bash
   supervisorctl restart mssql-server
   ```

   ![Kubectl exec command.](media/kubectl-exec.png 'Command prompt')

## After the hands-on lab

Duration: 10 mins

In this exercise, you will delete any Azure resources that were created in support of the lab. You should follow all steps provided after attending the Hands-on lab to ensure your account does not continue to be charged for lab resources.

### Task 1: Delete the resource group

1. Using the [Azure portal](https://portal.azure.com), navigate to the Resource group you used throughout this hands-on lab by selecting Resource groups in the left menu.
2. Search for the name of your resource group, and select it from the list.
3. Select Delete in the command bar, and confirm the deletion by re-typing the Resource group name, and selecting Delete.

You should follow all steps provided _after_ attending the Hands-on lab.
