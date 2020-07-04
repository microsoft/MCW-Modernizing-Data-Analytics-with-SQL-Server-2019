![Microsoft Cloud Workshops](https://github.com/Microsoft/MCW-Template-Cloud-Workshop/raw/master/Media/ms-cloud-workshop.png 'Microsoft Cloud Workshops')

<div class="MCWHeader1">
Modernizing Data Analytics with SQL Server 2019
</div>

<div class="MCWHeader2">
Before the hands-on lab setup guide
</div>

<div class="MCWHeader3">
March 2020
</div>

Information in this document, including URL and other Internet Web site references, is subject to change without notice. Unless otherwise noted, the example companies, organizations, products, domain names, e-mail addresses, logos, people, places, and events depicted herein are fictitious, and no association with any real company, organization, product, domain name, e-mail address, logo, person, place or event is intended or should be inferred. Complying with all applicable copyright laws is the responsibility of the user. Without limiting the rights under copyright, no part of this document may be reproduced, stored in or introduced into a retrieval system, or transmitted in any form or by any means (electronic, mechanical, photocopying, recording, or otherwise), or for any purpose, without the express written permission of Microsoft Corporation.

Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in this document. Except as expressly provided in any written license agreement from Microsoft, the furnishing of this document does not give you any license to these patents, trademarks, copyrights, or other intellectual property.

The names of manufacturers, products, or URLs are provided for informational purposes only and Microsoft makes no representations and warranties, either expressed, implied, or statutory, regarding these manufacturers or the use of the products with any Microsoft technologies. The inclusion of a manufacturer or product does not imply endorsement of Microsoft of the manufacturer or product. Links may be provided to third party sites. Such sites are not under the control of Microsoft and Microsoft is not responsible for the contents of any linked site or any link contained in a linked site, or any changes or updates to such sites. Microsoft is not responsible for webcasting or any other form of transmission received from any linked site. Microsoft is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement of Microsoft of the site or the products contained therein.

© 2020 Microsoft Corporation. All rights reserved.

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

- Microsoft Azure subscription must be pay-as-you-go or MSDN.
  - Trial subscriptions will not work.
- PowerShell
- Python3
- curl
- sqlcmd
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest)
- [azdata](https://docs.microsoft.com/en-us/sql/big-data-cluster/deploy-install-azdata-installer?view=sql-server-ver15)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-with-powershell-from-psgallery)
- [SQL Server Management Studio](https://go.microsoft.com/fwlink/?linkid=2078638) (SSMS) v18.4 or greater
- [Azure Data Studio](https://docs.microsoft.com/sql/azure-data-studio/download?view=sql-server-ver15)

## Regional limitations

Azure Kubernetes Service, which we will use in the Hands-On Lab, is currently available in a select set of regions. Refer to [the Azure Kubernetes Service product documentation](http://azure.microsoft.com/en-us/global-infrastructure/services/?products=kubernetes-service) for the up-to-date list of supported regions.

## Before the hands-on lab

Duration: 60 minutes

### Task 1: Install software on your own VM or system

The instructions that follow are the same for either your own system (desktop or laptop), or a Virtual Machine. It's best to have at least 4GB of RAM on the management system, and these instructions assume that you are not planning to run the database server or any Containers on the workstation. It's also assumed that you are using a current version of Windows, either desktop or server.

> **Note**: You can copy and paste all of the commands that follow in a PowerShell window that you run as the system Administrator

> **Note**: For further information, please [refer to this link](https://docs.microsoft.com/en-us/sql/big-data-cluster/deploy-get-started?view=sqlallproducts-allversions) for the latest installation instructions if you have problems running the steps below.

1. Open the [Azure Portal](https://portal.azure.com).

2. Create a new resource group called `mod-data-INIT` in a [supported AKS region](https://docs.microsoft.com/en-us/azure/aks/availability-zones).

3. Under **Settings**, select **Export template**.

   ![The resource group left menu is displayed with Export template item highlighted.](media/before-hol-azure-region-setup.png 'select export template')

4. In the menu, select **Deploy**.

5. Select **Build your own template in the editor**.

6. Copy then paste the **/hands-on-lab/template.json** file contents to the window, then select **Save**.

7. Check the **I agree...** checkbox.

8. Select **Purchase**.

9. Navigate to the **Overview** dialog of the resource group, select **Deployments**, wait for the **Microsoft.template** deployment to succeed.  You can select it to review its progress.

   ![From the Resource group left menu, Deployments is highlighted. The deployment with the name Microsoft.Template is highlighted in the listing of deployments.](media/before-hol-azure-deploy-status.png 'Review the deployment process')

10. Select the **dev-1-nsg** network security group, in the list of newly created resources.

11. In the **Settings** section, select **Inbound Security rules**.

12. Select **+Add**.

13. For the source, select **IP Addresses**.

14. For the source ip, type your client IP Address.
    - You can get this by looking at your router, or using a service such as google by doing a search for `what is my ip`.
    
15. For the destination port range, type `3389`

16. For the name, type `Port_3389`

17. Select **Add**.

18. Select the **dev-1** vm, in the list of newly created resources.

      ![In the list of resources in the resource group, the virtual machine dev-1 is highlighted.](media/before-hol-azure-vm.png 'Select the dev-1 virtual  machine')

19. Select **Connect -> RDP** in the top menu navigation.

20. Select **Download RDP file**, then connect to the virtual machine.

21. Open Internet Explorer, download and install [Google Chrome](https://www.google.com/chrome).

22. Set Google Chrome to the default browser.

23. Ensure your system updates are current. Run from an Administrator-level Windows PowerShell session (if running on a VM, you may safely ignore errors). This could take up to 30 minutes to complete.

      ```powershell
      Set-ExecutionPolicy RemoteSigned

      Install-Module PSWindowsUpdate
      Import-Module PSWindowsUpdate
      Get-WindowsUpdate
      Install-WindowsUpdate
      ```

24. Install Chocolatey Windows package Manager.

      ```powershell
      Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
      choco feature enable -n allowGlobalConfirmation
      ```

25. Install Azure CLI.

      ```powershell
      choco install azure-cli
      ```

26. Install Python 3.

      ```powershell
      choco install python3
      ```

27. Install git.

      ```powershell
      choco install git
      ```

28. Install kubectl.

      ```powershell
      choco install kubernetes-cli
      ```

29. Install Azure Data Studio.

      ```powershell
      choco install azure-data-studio
      ```

30. Install curl if you do not have it already.  Windows 10 build 17063 and later include curl by default; if you do not already have curl, install it using Chocolatey.

      ```powershell
      choco install curl
      ```

31. Install SQL command line tools (includes **sqlcmd**).

    ```powershell
    choco install sqlserver-cmdlineutils
    ```

32. Install SQL Management Studio.

    ```powershell
    choco install sql-server-management-studio
    ```

33. Run the following commands separately in a **new Command Prompt window**.

    ```bash
    python -m pip install --upgrade pip

    pip3 install -U requests
    ```

    ```bash
    cd %USERPROFILE%\Downloads
    curl -o azdata.msi -L https://aka.ms/azdata-msi
    msiexec.exe /qn /i azdata.msi
    ```

34. Install the [Data Virtualization extension for Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/data-virtualization-extension?view=sql-server-ver15).
    - Open **Azure Data Studio**.
    - Click **View->Extensions**.
    - Select the **Data Virtualization** extension, then select **Install**.

### Task 2: Download lab files

Download a starter project that includes data files used in the lab.

1. Download the starter files by downloading a .zip copy of the Modernizing data analytics with SQL Server 2019 GitHub repo.

2. In a web browser, navigate to the [Modernizing data analytics with SQL Server 2019 MCW repo](https://github.com/Microsoft/MCW-Modernizing-data-analytics-with-SQL-Server-2019).

3. On the repo page, select **Code**, then select **Download ZIP**.

   ![On the repo page, the Clone or Download button is expanded with the Download Zip button selected.](media/github-download-repo.png 'Download ZIP')

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

4. Switch to **Azure Data Studio**.

5. Select the **Connections** tab, then select the ellipsis (...) in Connections.

6. Select the **New Deployment** option.

   ![Azure Data Studio is displayed. In the CONNECTIONS section, the ellipsis next to the Connections header is expanded, and the Deploy SQL Server option is selected.](media/ads-deploy-sql-server.png 'Deploy SQL Server')

7. On the Select the deployment options, set the following values, then choose the **Select** button to continue:
   - For deployment template, select **SQL Server Big Data Cluster**.
   - Check the checkbox to accept the Microsoft Privacy Statement, SQL Server License Terms, and azdata license terms. Choose the **Select** button to continue.
   - Choose the following SQL Server Options:
     - **Version**: Select **SQL Server 2019**.
     - **Deployment Target**: Select **New Azure Kubernetes Service Cluster**.
   - In the Required tools section, ensure **kubectl**, **Azure CLI**, and **azdata** are present in the table.
  
   ![In the Select the deployment options screen, options are set to the previous values. The Select button is highlighted.](media/ads-deploy-bdc.png 'Deploy SQL Server Big Data Cluster')

   > **Note**: If the **Install tools** button is present, click it to install anything that may not have been installed in the above steps.

8. On the Step 1 Deployment configuration template panel, select **aks-dev-test**, and select **Next** to continue.

   ![The aks-dev-test configuration template is selected from the Step 1 Deployment Configuration Template panel. The Next button is highlighted.](media/ads-deploy-bdc-aks.png 'Deploy SQL Server Big Data Cluster on Azure Kubernetes Service')

9. On the Step 2 Azure Settings panel, set the following values, then select **Next** to continue:
   - **Subscription id**: Enter your subscription id that you are using for this lab. If you do not know your Subscription id, use the **View available Azure subscriptions** link located to the right of the textbox.
   - **New resource group name**: **mod-data-int**.
   - **Location**: Select a valid location for your AKS cluster from the dropdown list.
   - **AKS cluster name**: Give the cluster a name. By default, the name is `mssql-` followed by the date and time in UTC format.
   - **VM count**: Leave this as the default of **5**.
   - **VM size**: Leave this as the default of **Standard_E8s_v3**.

   ![On the Step 2 Azure settings panel, the form is filled in with the previously defined values. The Next button is highlighted.](media/ads-deploy-bdc-azure-settings.png 'Azure settings for deploying a SQL Server Big Data Cluster on Azure Kubernetes Service')

   > **Note**: Your hourly price will depend upon region, VM size, and VM count, but you can estimate this using the [Azure pricing website](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/ubuntu-advantage-essential/).

10. On the Step 3 Cluster settings panel, set the following values, then select **Next** to continue:
    - **Cluster name**: Retain the default `mssql-cluster`.
    - **Admin username**: Retain the default `admin`.
    - **Password**: Set a password that you will remember. The password you choose here will be your password for the controller, the master SQL Server instance, and the Knox gateway.
    - **Authentication mode**: **Basic**.
  
      ![On the Step 3 Cluster settings panel, the form is filled in with the previously defined values. The Next button is highlighted.](media/ads-deploy-bdc-cluster-settings.png 'Cluster settings for d4ploying a SQL Server Big Data Cluster on Azure Kubernetes Service')

      > **Please note:**  Some of the steps in this hands-on lab use Windows batch scripts to perform operations.  Windows batch scripts have a set of special characters which you should not use in your password.  Examples of safe special characters to use are `@`, `#`, and `$`, as these do not have any special meaning for Windows batch scripts. If you wish to use an exclamation point (`!`), your batch script calls will need to include four carets (`^`) before each exclamation point.  That is, if your password is `ThisIsMyPassword!`, then you will need to enter it as `ThisIsMyPassword^^^^!` when you call the Windows batch script.

11. Review the scale settings, we will **leave all of the defaults**, including endpoints for the labs. The default values will be based off of the deployment configuration template, but you have the opportunity to change these if you would like. When finished, select the **Next** button.
   ![The Step 4 Service settings page is filled with with default values. The Next button is highlighted.](media/ads-deploy-bdc-service-settings.png 'Service settings for deploying a SQL Server Big Data Cluster on Azure Kubernetes Service')

12. On the Step 5 Summary panel, review the summary to ensure that your settings are correct. Once finished, select the **Script to Notebook** button.
   ![The Summary page has our cluster details and a Script to Notebook button which we will select.](media/ads-deploy-bdc-summary.png 'Summary details our SQL Server Big Data Cluster')

13. If you have never run a notebook before, Azure Data Studio will ask you to choose a new Python installation or, if you have one already, an existing installation.  We will choose to use a new installation of Python to avoid any permissions issues with existing installations of Python.  Choose the **Install** button.  As Azure Data Studio configures Jupyter notebooks and installs necessary components, it will write messages to the Output buffer.
   ![The Configure Python for Notebooks dialog is displayed with an installation type of "New Python installation" selected and the Install button is highlighted.](media/ads-configure-python-for-notebooks.png 'Configure Python for Notebooks')

14. After Azure Data Studio finishes configuration, run each step of the notebook by selecting the "play" button next to each code block in order. It may take a few moments to start the python kernel and execute the first step, you can watch the `output` window for status.
       - If prompted to upgrade python packages, select **Yes**.
       - You may need to log into Azure when running block 5, which executes `az login`.  
  
      > **Note**: When you get to the `az aks create` command, you may run into an error when creating the cluster.  This is a known [issue](https://github.com/Azure/azure-cli/issues/9585) that may be resolved in the latest Azure CLI (April 2020+).  If you receive an error, you will need to add new steps to create a service principal and then prompt for the client id and secret to create the cluster.

      ```python
      run_command('az ad sp create-for-rbac --skip-assignment')

      client_id = input("Enter the client id (appId above) : ")
      client_secret = input("Enter the client secret (password above): ")

      # Update the az aks create command
      run_command(f'az aks create --name {aks_cluster_name} --resource-group {azure_resource_group} --generate-ssh-keys --node-vm-size {azure_vm_size} --node-count {azure_vm_count} --service-principal {client_id} --client-secret {client_secret}')
      ```

      > **Note**:  Some of these steps, such as creating the Azure Kubernetes Service cluster and creating the SQL Server 2019 Big Data Cluster, may take upwards of 30 minutes to complete.  Read each respective step to determine commands you can run to check the status.

      ![The Big Data Cluster deployment notebook is shown with the Run cell command highlighted as an example of how to run a cell.](media/ads-deploy-bdc-notebook.png 'Running the notebook to deploy a SQL Server Big Data Cluster')

15. The final step of the notebook will allow you to connect to your Big Data Cluster master instance using Azure Data Studio. Run the step and then select the link to connect to your SQL Server master instance.

   ![In the notebook in the Connect to SQL Server Master instance in Azure Data Studio section, the Click here to connect to SQL Server master instance link is highlighted.](media/ads-deploy-bdc-connect.png 'Connect to a SQL Server master instance')

16. Once you have run through each step, save the notebook.  This notebook will contain information on all of your Big Data Cluster endpoints, which you will need throughout the lab.

### Task 4: Install sample databases and upload files

1. Open a new Windows Explorer window.  Navigate to the Hands-on lab's Resources folder. If you followed along with Step 4 of Task 2, it will be at `C:\MCW-Modernizing-data-analytics-with-SQL-Server-2019-master\Hands-on lab\Resources\`.

   - Review the contents of the script file.

2. Switch to Windows command prompt.

3. Run the script named **bootstrap-sample-db.cmd**. Substitute `<MSSQL_CLUSTER_NAME>`, `<SQL_MASTER_IP>`, `<SQL_MASTER_ADMIN_PASSWORD>`, `<KNOX_IP>`, `<KNOX_PASSWORD>` with values output from the SQL Server 2019 cluster creation notebook above.  Halfway through the execution of this script, you may need to hit a key to have it continue.  This script will download and restore a database called `sales` to your Big Data cluster.

   ```bash
   cd "C:\MCW-Modernizing-data-analytics-with-SQL-Server-2019-master\Hands-on lab\Resources\"

   .\bootstrap-sample-db.cmd <MSSQL_CLUSTER_NAME> <SQL_MASTER_IP> <SQL_MASTER_ADMIN_PASSWORD> <KNOX_IP> <KNOX_PASSWORD> --install-extra-samples
   ```

   | Parameter                   | Description                                                                 |
   | --------------------------- | --------------------------------------------------------------------------  |
   | <CLUSTER_NAMESPACE>         | The name you gave your big data cluster (**mssql-cluster** in our example). |
   | <SQL_MASTER_IP>             | The IP address of your master SQL Server Master Instance                                      |
   | <SQL_MASTER_ADMIN_PASSWORD> | The SA password for the master instance (Password you entered above).                                    |
   | <KNOX_IP>                   | The IP address of the gateway to access HDFS files, Spark.                                   |
   | <KNOX_PASSWORD>             | The same as your admin password  (Password you entered above).
   | --install-extra-samples     | Uploads database backup files for AdventureWorks and Wide World Importers   |

   > **Note**: You can also use kubectl to find the IP addresses for the SQL Server master instance and Knox. Run `kubectl get svc -n <your-big-data-cluster-name>` and look at the EXTERNAL-IP addresses for the master instance (**master-svc-external**) and Knox (**gateway-svc-external**).

4. Run the script named **upload-sample-files.cmd**. Substitute `<KNOX_IP>`, `<KNOX_PASSWORD>` with values output from the SQL Server 2019 cluster creation script above.  This script will copy various sample files used in the labs.

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

2. Select the **WWI_Commerce** database resource.

3. On the Overview pane, select **Set server firewall** to add your IP address.

    ![On the Overview pane of the SQL database, the Set server firewall item is highlighted on the toolbar.](media/azure-sql-set-server-firewall-link.png 'Overview blade')

4. Select **+ Add client IP** to automatically add your system's IP address, and make sure **Allow access to Azure services** is set to **ON**.

5. Select **Save** to apply your changes.

    ![On the Firewall settings screen, the + Add client IP button is highlighted in the toolbar, and the toggle for Allow access to Azure services is set to **ON**.](media/azure-sql-set-server-firewall.png 'Firewall settings')

6. Choose **Query editor** from the left-hand menu. When prompted, type **ServerAdmin** for the Login name, and **MySQLBigData2019** for the password, then select **OK** to log in.

    ![In the left menu of the SQL Database resource, the Query editor item is selected. In the content pane, a SQL server authentication form is displayed populated with the above values and the OK button is selected.](media/azure-sql-query-editor-login.png 'Query editor')

7. Paste the following into the query window, then execute. This creates a new Reviews table with data.

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
    INSERT [dbo].[Reviews] ([product_id], [customer_id], [review], [date_added]) VALUES (15031, 84489, N'Hi ;We are running pub here in Marmaris Turkey.Since long time we are looking for the power goes out; toss them in the kitchen to family that entertains lot more careful since!', CAST(N'2019-02-23T13:18:00.000' AS DateTime))
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
