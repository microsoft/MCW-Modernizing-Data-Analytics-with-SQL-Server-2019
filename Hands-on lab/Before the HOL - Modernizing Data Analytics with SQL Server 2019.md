![Microsoft Cloud Workshops](https://github.com/Microsoft/MCW-Template-Cloud-Workshop/raw/master/Media/ms-cloud-workshop.png 'Microsoft Cloud Workshops')

<div class="MCWHeader1">
Modernizing Data Analytics with SQL Server 2019
</div>

<div class="MCWHeader2">
Before the hands-on lab setup guide
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

- [Modernizing Data Analytics with SQL Server 2019 before the hands-on lab setup guide](#modernizing-data-analytics-with-sql-server-2019-before-the-hands-on-lab-setup-guide)
  - [Requirements](#requirements)
  - [Regional limitations](#regional-limitations)
  - [Before the hands-on lab](#before-the-hands-on-lab)
    - [Task 1: Install software on your own VM or system](#task-1-install-software-on-your-own-vm-or-system)
    - [Task 2: Download lab files](#task-2-download-lab-files)
    - [Task 3: Install SQL Server 2019 Big Data clusters](#task-3-install-sql-server-2019-big-data-clusters)
    - [Task 4: Install sample databases and upload files](#task-4-install-sample-databases-and-upload-files)
    - [Task 5: Create sample Azure SQL Database](#task-5-create-sample-azure-sql-database)

<!-- /TOC -->

# Modernizing Data Analytics with SQL Server 2019 before the hands-on lab setup guide

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

## Regional limitations

Azure Kubernetes Service, which we will use in the Hands-On Lab, is currently available in a select set of regions in the United States and Canada.  Refer to [the Azure Kubernetes Service product documentation](http://azure.microsoft.com/en-us/global-infrastructure/services/?products=kubernetes-service) for the up-to-date list of supported regions.

## Before the hands-on lab

Duration: 60 minutes

### Task 1: Install software on your own VM or system

The instructions that follow are the same for either your own system (desktop or laptop), or a Virtual Machine. It's best to have at least 4GB of RAM on the management system, and these instructions assume that you are not planning to run the database server or any Containers on the workstation. It's also assumed that you are using a current version of Windows, either desktop or server.

_(You can copy and paste all of the commands that follow in a PowerShell window that you run as the system Administrator.)_

> For further information, please [refer to this link](https://docs.microsoft.com/en-us/sql/big-data-cluster/deploy-get-started?view=sqlallproducts-allversions) for the latest installation instructions if you have problems running the steps below.

1. Ensure your system updates are current. Run from an Administrator-level PowerShell session (if running on a VM, you may safely ignore errors).

   ```powershell
   Set-ExecutionPolicy RemoteSigned

   Install-Module PSWindowsUpdate
   Import-Module PSWindowsUpdate
   Get-WindowsUpdate
   Install-WindowsUpdate
   ```

2. Install Chocolatey Windows package Manager.

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
   choco feature enable -n allowGlobalConfirmation
   ```

3. Install Azure CLI.

   ```powershell
   choco install azure-cli
   ```

4. Install Python 3.

   ```powershell
   choco install python3
   ```

5. Install git.

   ```powershell
   choco install git
   ```

6. Install kubectl.

   ```powershell
   choco install kubernetes-cli
   ```

7. Install Azure Data Studio.

   ```powershell
   choco install azure-data-studio
   ```

8. Install curl if you do not have it already.  Windows 10 build 17063 and later include curl by default; if you do not already have curl, install it using Chocolatey.

   ```powershell
   choco install curl
   ```

9. Install SQL command line tools (includes **sqlcmd**).

    ```powershell
    choco install sqlserver-cmdlineutils
    ```

9. Run the following commands separately in a **new Command Prompt window**.

    ```bash
    choco upgrade kubernetes-cli
    ```

    ```bash
    python -m pip install --upgrade pip
    ```

    ```bash
    cd %USERPROFILE%\Downloads
    curl -o azure-cli.msi -L https://aka.ms/azdata-msi
    msiexec.exe /qn /i azure-cli.msi
    ```

11. Download and install [SQL Server Management Studio](https://aka.ms/ssmsfullsetup) (SSMS) v18.4 or greater.

12. Install the [Data Virtualization extension for Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/data-virtualization-extension?view=sql-server-ver15).

### Task 2: Download lab files

Download a starter project that includes data files used in the lab.

1. Download the starter files by downloading a .zip copy of the Modernizing data analytics with SQL Server 2019 GitHub repo.

2. In a web browser, navigate to the [Modernizing data analytics with SQL Server 2019 MCW repo](https://github.com/Microsoft/MCW-Modernizing-data-analytics-with-SQL-Server-2019).

3. On the repo page, select **Clone or download**, then select **Download ZIP**.

   ![Download .zip containing the repository.](media/github-download-repo.png 'Download ZIP')

4. Unzip the contents to your root hard drive (i.e. `C:\`). This will create a folder on your root drive named `MCW-Modernizing-data-analytics-with-SQL-Server-2019-master`.

### Task 3: Install SQL Server 2019 Big Data clusters

Open PowerShell and execute the following to deploy the clusters in preparation for the lab.

1. Before running the script, you must log in to your Azure account with Azure CLI at least once.

   ```bash
   az login
   ```

2. If you have multiple subscriptions, choose the appropriate subscription in which the resource should be billed. List all your subscriptions by entering the following into the shell:

   ```bash
   az account list
   ```

3. Select the specific subscription ID under your account using `az account set` command. Copy the `id` value from the output of the previous command for the subscription you wish to use into the `subscription id` placeholder:

   ```bash
   az account set --subscription <subscription id>
   ```

4. Open Azure Data Studio.  Click on the Connections tab, then click the ellipsis (...) in Connections and select the Deploy SQL Server option.

![Azure Data Studio is displayed, and then the user clicks on Connections, the ellipsis next to the Connections header, and the Deploy SQL Server option.](media/ads-deploy-sql-server.png 'Deploy SQL Server')

5. Click on the SQL Server Big Data Cluster option.  First, click the box that you accept the Microsoft Privacy Statement, SQL Server License Terms, and azdata license terms.  Then, choose your version of SQL Server and deployment target.  We will use SQL Server 2019 against a new Azure Kubernetes Service (AKS) cluster in this lab.  Finally, ensure that you have installed `kubectl`, the Azure CLI, and `azdata`.  Once you are done, click the Select button to continue.

![In the deployment options wizard, SQL Server Big Data Cluster is selected.](media/ads-deploy-bdc.png 'Deploy SQL Server Big Data Cluster')

This will take you to a wizard.

6. Choose the `aks-dev-test` deployment configuration template and click the Next button.

![The aks-dev-test configuration template is selected.](media/ads-deploy-bdc-aks.png 'Deploy SQL Server Big Data Cluster on Azure Kubernetes Service')

7. Fill in the Azure subscription ID you would like to use for the lab.  If you do not know your subscription ID, you can get it from Step 2 by running `az account list`, or by clicking the "View available Azure subscriptions" link.

Choose a name for your resource group.  By default, this is `mssql-` followed by the date and time in UTC format.  

Select a valid location for your AKS cluster from the dropdown list and give the cluster a name.  By default, the name is `mssql-` followed by the date and time in UTC format.

Finally, select the VM count and size of each VM.  By default, this is 5 VMs of type Standard_E8s_v3.  Your hourly price will depend upon region, VM size, and VM count, but you can estimate this using the [Azure pricing website](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/ubuntu-advantage-essential/).  For this lab, we will keep the default count and server sizing.  When you are finished, click the Next button.

![The subscription ID, resource group name, location, cluster name, VM count, and VM size settings are filled in.](media/ads-deploy-bdc-azure-settings.png 'Azure settings for deploying a SQL Server Big Data Cluster on Azure Kubernetes Service')

8. Fill in your cluster name, administrator username and password, and authentication mode.  By default, the cluster name will be `mssql-cluster` and the administrator name is `admin`.

The password you choose here will be your password for the controller, the master SQL Server instance, and the Knox gateway.

> **Please note:**  Some of the steps in this hands-on lab use Windows batch scripts to perform operations.  Windows batch scripts have a set of special characters which you should not use in your password.  Examples of safe special characters to use are `@`, `#`, and `$`, as these do not have any special meaning for Windows batch scripts. If you wish to use an exclamation point (`!`), your batch script calls will need to include four carets (`^`) before each exclamation point.  That is, if your password is `ThisIsMyPassword!`, then you will need to enter it as `ThisIsMyPassword^^^^!` when you call the Windows batch script.

Once you have filled in these details, click Next.

![The cluster name, administrator username, and administrator password are filled in.](media/ads-deploy-bdc-cluster-settings.png 'Cluster settings for deploying a SQL Server Big Data Cluster on Azure Kubernetes Service')

9. Select your scale settings.  The default values will be based off of the deployment configuration template, but you have the opportunity to change these if you would like.  For the lab, we will leave all of the defaults, including endpoints.  Click Next when you are finished.

![The Service settings page is filled with with default values.](media/ads-deploy-bdc-service-settings.png 'Service settings for deploying a SQL Server Big Data Cluster on Azure Kubernetes Service')

10. Review the summary to ensure that your settings are correct and then click the Script to Notebook button.

![The Summary page has our cluster details and a Script to Notebook button which we will click.](media/ads-deploy-bdc-summary.png 'Summary details our SQL Server Big Data Cluster')

11. If you have never run a notebook before, Azure Data Studio will ask you to choose a new Python installation or, if you have one already, an existing installation.  We will choose to use a new installation of Python to avoid any permissions issues with existing installations of Python.  Click the Install button.  As Azure Data Studio configures Jupyter notebooks and installs necessary components, it will write messages to the Output buffer.

![The Python for Notebooks dialog is displayed with an installation type of "New Python installation" selected.](media/ads-configure-python-for-notebooks.png 'Configure Python for Notebooks')

12. After Azure Data Studio finishes configuration, run each step of the notebook by clicking the "play" button next to each code block in order.  You may need to log into Azure when running block 5, which executes `az login`.  

> **Please note:**  Some of these steps, such as creating the Azure Kubernetes Service cluster and creating the SQL Server 2019 Big Data Cluster, may take upwards of 30 minutes to complete.

![The Big Data Cluster deployment notebook is running a command.](media/ads-deploy-bdc-notebook.png 'Running the notebook to deploy a SQL Server Big Data Cluster')

13. The final step of the notebook will allow you to connect to your Big Data Cluster master instance using Azure Data Studio.  Run the step and then click the link to connect to your SQL Server master instance.

![Click the link to connect to the SQL Server master instance.](media/ads-deploy-bdc-connect.png 'Connect to a SQL Server master instance')

14. Once you have run through each step, save the notebook.  This notebook will contain information on all of your Big Data Cluster endpoints, which you will need throughout the lab.

### Task 4: Install sample databases and upload files

1. Open a new Windows command prompt (DO NOT user PowerShell for these steps).  Navigate to a folder where you'll keep the sample data files.

2. Use **curl** to download the bootstrap script for the sample data.

   ```bash
   curl -o bootstrap-sample-db.cmd "https://raw.githubusercontent.com/Microsoft/MCW-Modernizing-data-analytics-with-SQL-Server-2019/master/Hands-on%20lab/Resources/bootstrap-sample-db.cmd"
   ```

3. Download the **bootstrap-sample-db.sql** Transact-SQL script. This script is called by the bootstrap script.

   ```bash
   curl -o bootstrap-sample-db.sql "https://raw.githubusercontent.com/Microsoft/sql-server-samples/master/samples/features/sql-big-data-cluster/bootstrap-sample-db.sql"
   ```

4. Download the **upload-sample-files.cmd** command script for uploading additional lab files to HDFS on your cluster.

   ```bash
   curl -o upload-sample-files.cmd "https://raw.githubusercontent.com/Microsoft/MCW-Modernizing-data-analytics-with-SQL-Server-2019/master/Hands-on%20lab/Resources/upload-sample-files.cmd"
   ```

5. Run the bootstrap script. Substitute `<MSSQL_CLUSTER_NAME>`, `<SQL_MASTER_IP>`, `<SQL_MASTER_ADMIN_PASSWORD>`, `<KNOX_IP>`, `<KNOX_PASSWORD>` with values output from the SQL Server 2019 cluster creation notebook above.  Halfway through the execution of this script, you may need to hit a key to have it continue.

   ```bash
   .\bootstrap-sample-db.cmd <MSSQL_CLUSTER_NAME> <SQL_MASTER_IP> <SQL_MASTER_ADMIN_PASSWORD> <KNOX_IP> <KNOX_PASSWORD> --install-extra-samples
   ```

   | Parameter                   | Description                                                                 |
   | --------------------------- | --------------------------------------------------------------------------  |
   | <CLUSTER_NAMESPACE>         | The name you gave your big data cluster (**mssql-cluster** in our example). |
   | <SQL_MASTER_IP>             | The IP address of your master instance.                                     |
   | <SQL_MASTER_ADMIN_PASSWORD> | The SA password for the master instance.                                    |
   | <KNOX_IP>                   | The IP address of the HDFS/Spark Gateway.                                   |
   | <KNOX_PASSWORD>             | The same as your admin password.                                            |
   | --install-extra-samples     | Uploads database backup files for AdventureWorks and Wide World Importers   |

   > You can also use kubectl to find the IP addresses for the SQL Server master instance and Knox. Run `kubectl get svc -n <your-big-data-cluster-name>` and look at the EXTERNAL-IP addresses for the master instance (**master-svc-external**) and Knox (**gateway-svc-external**).

6. Run the file upload script. Substitute `<KNOX_IP>`, `<KNOX_PASSWORD>` with values output from the SQL Server 2019 cluster creation script above.

   ```bash
   .\upload-sample-files.cmd <KNOX_IP> <KNOX_PASSWORD>
   ```

   | Parameter       | Description                               |
   | --------------- | ----------------------------------------- |
   | <KNOX_IP>       | The IP address of the HDFS/Spark Gateway. |
   | <KNOX_PASSWORD> | The same as your SA password.             |

### Task 5: Create sample Azure SQL Database

In this lab, you will be using an Azure SQL Database as a source for virtual tables within your SQL Server 2019 cluster. Follow these steps to create a new Azure SQL Server Database instance and configure its firewall.

1. Navigate to the [Azure portal](https://portal.azure.com).

2. Select **Create a resource**, type in "SQL Database" in the search field, then select **SQL Database** from the results.

   ![Create a resource is highlighted and SQL Database is selected.](media/azure-create-sql-database-search.png 'SQL Database')

3. Select **Create** in the SQL Database details page.

4. Within the **Basics** form, complete the following:

   - **Subscription**: Select your Azure subscription you are using for this lab.
   - **Resource group**: Select the resource group you are using for this lab.
   - **Database name**: Enter **WWI_Commerce**.
   - **Server**: Select **create new**.
     - **Server name**: Enter a unique server name.
     - **Server admin login**: Enter **ServerAdmin**.
     - **Password**: Enter **MySQLBigData2019**.
     - **Location**: Select the same location you are using for this lab. Should be the same as for your SQL Server 2019 Big Data clusters.
     - **Allow Azure services to access server**: Check this box.
   - **Want to use SQL elastic pool?**: Select No.
   - **Compute + storage**: Leave as default.

   ![The Basics form is displayed.](media/azure-create-sql-database-basics.png 'Create SQL Database')

5. **Save your server credentials and server name** to Notepad or similar text editor for later.

6. Select **Next : Networking >** and then **Next : Additional settings >**.

7. Within the **Additional settings** form, select **Sample** next to **Use existing data**. Then select **Review + create**.

   ![The Additional settings form is displayed.](media/azure-create-sql-database-additional-settings.png 'Create SQL Database')

8. Within the **Review + create** form, select **Create**.

9. After the database is created, open it.

10. On the Overview pane, select **Set server firewall** to add your IP address.

    ![Set server firewall is highlighted on the Overview blade.](media/azure-sql-set-server-firewall-link.png 'Overview blade')

11. Select **+ Add client IP** to automatically add your system's IP address, and make sure **Allow access to Azure services** is set to ON. Select **Save** to apply your changes.

    ![The Add client IP and Allow access to Azure services buttons are highlighted.](media/azure-sql-set-server-firewall.png 'Firewall settings')

12. Choose **Query editor** from the left-hand menu. When prompted, type **ServerAdmin** for the Login name, and **MySQLBigData2019** for the password, then select **OK** to log in.

    ![The login form for the Query Editor is displayed.](media/azure-sql-query-editor-login.png 'Query editor')

13. Paste the following into the query window, then execute. This creates a new Reviews table with data.

    ```sql
    SET ANSI_NULLS ON
    GO
    SET QUOTED_IDENTIFIER ON
    GO
    CREATE TABLE [dbo].[Reviews](
        [product_id] [bigint] NOT NULL,
        [customer_id] [bigint] NOT NULL,
        [review] [nvarchar](1000) NOT NULL,
        [date_added] [datetime] NOT NULL
    ) ON [PRIMARY]
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (17432, 72621, N'Works fine. Easy to install. Some reviews talk about not fitting wall plates. Designed for the best; while greet dinner guests; smelling stronger than the Vollarth. While the handle''s grip is nice on the OXO Good Grips Trigger Ice Cream Scoop purchased recently and this is the same as all the difference in the kitchen. If you cook for living; go for the professional series.', CAST(N'2019-02-22T07:48:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (16816, 89334, N'great product to save money! Dont worry about leaving the light on anymore. It is great for kitchen! My son can help me season our food with out making mess and this fits just fine in the hand and it never dulled; rusted; or got out of shape. Perfect quality and very easy and effortless to use. This blade is ideal for both narrow and wide wedges. The curve at the local Home Depot store. Both seem to work with. In my case fan). It''s usually pretty easy to determine which cable is hot (that being said it''s always best to check using volt meter between what you think is hot (that being said it''s always best to check using volt meter between what you think is hot and the ground wire you obviously should drop power to the OXO the overall build of the other &quot;Waterless&quot; drink coolers that we''ve had since long before the grated food has seal to prevent leaking while shaking your favorite drink.', CAST(N'2019-02-22T12:21:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (9342, 89335, N'Next time will go with the old metal handle- this is bonus.', CAST(N'2019-02-22T13:09:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (10399, 84259, N'Great Gift Great Value had to get used. And after 12 hours of use; they just throw them away; so you haven''t created any useless clutter. (Get yourself set too.)', CAST(N'2019-02-22T13:17:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (7384, 84398, N'After trip to Paris and falling in love with Nutella crepes decided had to try it. am glad found it! Thank you; CIA; for my existing switch. Design-wise it is dishwasher safe too! Very highly recommended. You''ll thank me for this!JANA', CAST(N'2019-02-22T14:36:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (5123, 66434, N'Simply the best thing about them is that you can only use for one thing; so this one is wonderful to hold the keys.', CAST(N'2019-02-23T01:20:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (14908, 66501, N'This is the exact product that my mother used in the outlet/switch box. It does exactly what was glad to find so was happy to finally get them. great service. thank you.', CAST(N'2019-02-23T06:01:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (11385, 66587, N'Not super magnet; but strong enough to set on the oven and the spatula is supposed to have; but this one is definitely heavy duty! have placed 15 minute timer on all the time and will certainly provide entertainment for your guests. (It is such great gift in festival''s sovenuior such as this to get used. And after 12 hours of use; they just throw them away; so you haven''t created any useless clutter. (Get yourself set too.)', CAST(N'2019-02-23T08:56:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (6299, 66680, N'Installed as bathroom fan timer. Easy to install. Some reviews talk about not fitting wall plates. Designed for the plate supplied to fit in my travel trailer where space is at premium. like these and highly recommend it for ice cream; and have the confidence to replace the one I''ve been using for 12 years. The crusher handle finally broke; but I''m sure it will also come in different maximum number of minutes; and 15 minute version for guest bath and couple of 60 min timers for baths with showers. Installed quiet fans and we can turn on the metal trigger.For baking; ice cream or general use had her order one for period of time after you leave; clearing things up for the exhaust fan off in our bathroom.Saves money on heat and cooling...', CAST(N'2019-02-23T09:12:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (5575, 66694, N'Our home was built in 2003 and this fits just fine in the drawer until find one of those things that if was looking for; good quality; and after months of daily service..', CAST(N'2019-02-23T11:41:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (15031, 84489, N'Hi ;We are running pub here iN Marmaris Turkey.Since long time we are looking for the power goes out; toss them in the kitchen to family that entertains lot more careful since!', CAST(N'2019-02-23T13:18:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (12101, 79052, N'Terra cotta is the best!', CAST(N'2019-02-23T17:25:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (4109, 73034, N'One of my fingernail! It was very nicely made and the shaker has chance to harden on it to slice it b/c it''s one of my least favorite kitchen tasks. have been lot more for these high quality and materials. am curious by nature and couple of years now. It is one of my children''s homes as they all cook. No more rubbing my skin with sliced lemons; or salt; and hoping for the bathroom; 15 minutes is more then enough time. stars!!!!! Jerry W.; Moreno Valley; Ca.', CAST(N'2019-02-23T19:11:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (6290, 73298, N'We installed these on the fan to come on; and then the timer simply winds down to cut the fan and leave the fan going all day long.', CAST(N'2019-02-24T04:23:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (10921, 66810, N'needed silicone coated whisk for cooking class and did not have time to get one for yourself.', CAST(N'2019-02-24T06:44:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (5293, 66912, N'Great Gift Great Value really like the small quantity you get stranded; next to your bed in case you get at Disney; that lasts few sniffs later had her order one for myself. The glasses are over sized and the closet light in our daughter''s room. They work great. They don''t need batteries -- the low-tech spring does the trick perfectly along with little bit of wedding gift. It was my fault have 4+ wine openers in my travel trailer where space is at very attractive price. This set reminds me of the screwpulls that instantly pull out the cork. This 3-in-1 corkscrew is big help. It is built to last.', CAST(N'2019-02-24T15:36:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (9308, 67028, N'Laguiole knives are real hit with everyone; from kiddie parties to Bar-B-Q''s! Lots of fun;and different than most novelty items. Put them in unique way. You lay the can into slot. After you figure it out; you don''t even think about it... it''s automatic. Every once in awhile; you''ll need to try it to believe it. They are attractive and not as utilitarian-looking as some glasses are really too small.I have given two as gifts. don''t know or care how it works; the fact that it does is good enough for the experiment and curiousity and partly wanting the utility of it and off you go', CAST(N'2019-02-24T18:12:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (2430, 89770, N'Good sound timers that work as advertised.Intermatic is probably the best for the professional series.', CAST(N'2019-02-24T20:36:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (16203, 84679, N'AWESOME FEEDBACK FROM MY BEST FRIEND WHOM PURCHASED THIS SET FOR AS CHRISTMAS GIFT!!! I; MYSELF LIKED THE STYLE AND IMMEDIATELY THOUGHT IT WOULD BE GREAT GIFT TO SEND HER THIS YEAR SINCE SHE''S SUCH CHOCOLATE MARTINI AFFICIANADO... SHE LOVED THE SET SO MUCH THAT SHE HAD MARTINI THE SAME NIGHT SHE RECEIVED THIS SET;NEED SAY MORE?', CAST(N'2019-02-24T23:18:00.000' AS DateTime))
    GO
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (5239, 84953, N'love the retro glass look and says the styling makes it 100% easier to grate things like cheese or pie.The true test; however; is the only one you need! haven''t used it for good years ago. love this sauce whisk. It''s comfortable to hold the keys.', CAST(N'2019-02-24T22:02:00.000' AS DateTime))
    GO
    ```

    ![The SQL query is displayed and the Run button is highlighted.](media/azure-sql-query-editor.png 'Query editor')

You should follow all steps provided _before_ performing the Hands-on lab.
