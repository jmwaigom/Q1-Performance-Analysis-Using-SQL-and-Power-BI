# Pinnacle Eletronics: Q1 Revenue Analysis For Top 10 Physical Stores

### Table of Contents

### Objective
Senior management at Pinnacle Electronics wanted a comprehensive snapshot of Q1 (January – March 2021) sales performance across all regions. They needed to see:
- Top 10 stores by revenue across all locations/countries
- Best-selling products by sales volume and revenue
- Best-selling products (by sales volume and revenue) within the top 10 stores
- Overall Q1 revenue trends with a focus on global performance

This report would help executives assess early-year performance and adjust strategies before Q2. 

### Dataset Available
Five tables were available in a Postgres database: 

**Customers**: Contained customer information like name, location and birthdate

**Products**: Contained information such as name, brand, unit cost and category

**Sales**: Contained purchase information such as order quantity and date of transaction

**Stores**: Contained data for store name, location, size and open/launch date

**Exchange Rates**: Contained daily rates from 2016 to 2021

### Data Preprocessing
All data preprocessing was conducted in PostgreSQL (see attached SQL file for the code). While table modifications were restricted by the database administrator, permission was granted to create views for temporary data storage and transformation. The Exchange table was ultimately not used, as all transactions in the sales table had already undergone the necessary currency conversions before data processing.

After completing data cleaning and processing in PostgreSQL, the database was successfully connected to Power BI, and all relevant tables were transferred for further analysis and visualization.

### Data Challenge(s) and Assumption(s):
Approximately 49,719 records in the sales table (about 79%) had NULL values in the DeliveryDate column, with no clear explanation for the missing data. Given that these transactions occurred in physical stores, an assumption was made that the missing values corresponded to in-store pickup orders. As a result, for these records, the DeliveryDate was set to match the OrderDate.

However, if the missing values do not actually correspond to in-store pickups, this assumption could introduce potential inaccuracies. To mitigate this risk, and given the scope of this analysis, the DeliveryDate column was ultimately excluded from the findings. Therefore, the results presented are unlikely to be influenced by the missing values in this column.

### Data Visualization

A Power BI dashboard was created to address the management team's requirements, providing key insights into sales performance, top-performing stores, best-selling products, and revenue trends. Below is a snapshot of the dashboard.
![image](https://github.com/user-attachments/assets/7dc424bd-e51f-48b4-85bb-dca4fbafa1d1)
![image](https://github.com/user-attachments/assets/1634f50d-8a6f-4092-8694-304c6f1f21bc)

### Observations, Analysis & Reporting



