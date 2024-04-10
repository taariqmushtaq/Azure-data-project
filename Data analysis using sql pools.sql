
/*In Synapse Studio, go to the Develop hub
Create a new SQL script.
Paste the following code into the script*/

--this will show the top 100 rows of the data in the parquet file--
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://tariqaccount.dfs.core.windows.net/users/flightsdata.parquet',
        FORMAT='PARQUET'
    ) AS [result]


/*External data sources that represent the named references for storage accounts.
Database scoped credentials that enable you to specify how to authenticate to external data source.
Database users with the permissions to access some data sources or database objects.
Utility views, procedures, and functions that you can use in the queries*/

--Create a database for the custom objects because these custom objects are not stored in the master database--
--thats why we create new database Data Exploration DB--

CREATE DATABASE DataExplorationDB 
                COLLATE Latin1_General_100_BIN2_UTF8

/*Switch the database context from master to DataExplorationDB using the following command.
You can also use the UI control use database to switch your current database*/
USE DataExplorationDB



--From DataExplorationDB, create utility objects such as credentials and data sources--
CREATE EXTERNAL DATA SOURCE tariqaccount
WITH ( LOCATION = 'https://tariqaccount.dfs.core.windows.net')


/*Optionally, use the newly created DataExplorationDB database to create a login for a user 
in DataExplorationDB that will access external data:*/
CREATE LOGIN data_explorer WITH PASSWORD = 'Tariqhacks2770873$';




/*Next create a database user in DataExplorationDB for the above login and 
grant the ADMINISTER DATABASE BULK OPERATIONS permission*/
CREATE USER data_explorer FOR LOGIN data_explorer;
GO
GRANT ADMINISTER DATABASE BULK OPERATIONS TO data_explorer;
GO


--Explore the content of the file using the relative path and the data source:--
SELECT
    TOP 100 *
FROM
    OPENROWSET(
            BULK '/users/flightsdata.parquet',
            DATA_SOURCE = 'tariqaccount',
            FORMAT='PARQUET'
    ) AS [result]


    --FINALLY PUBLISH IT ---
    --NEXT ANALYSIS WILL BE DONE USING Data Explorer--