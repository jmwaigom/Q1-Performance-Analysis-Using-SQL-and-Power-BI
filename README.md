# Pinnacle Eletronics: Q1 Revenue Analysis For Top 10 Physical Stores

![img1-min](https://github.com/user-attachments/assets/47e5a18b-a5a8-4678-80b4-05320c0469b8)

### Disclaimer
This project is based on a hypothetical business scenario created for educational and analytical purposes. Pinnacle Electronics does not represent a real company. The data, including names and transaction records used in this analysis is simulated. Any resemblance to actual persons or businesses is purely coincidental.

### Table of Contents
- [Introduction](#introduction)  
- [Objective](#objective)  
- [Dataset Available](#dataset-available)  
- [Data Preprocessing](#data-preprocessing)  
- [Data Challenge(s) and Assumption(s)](#data-challenges-and-assumptions)  
- [Data Visualization](#data-visualization)  
- [Observations, Analysis & Reporting](#observations-analysis--reporting)  
  - [Revenue by Store](#revenue-by-store)  
  - [Top Products by Revenue and Units Sold](#top-products-by-revenue-and-units-sold)  
  - [Revenue Trend Analysis](#revenue-trend-analysis)  
- [Final Thought: Expanding Customer Data for Deeper Insights](#final-thought-expanding-customer-data-for-deeper-insights)  

### Introduction:
This project simulates the role of a Data Analyst at Pinnacle Electronics, a global electronics retailer that sells a diverse range of products across multiple countries. The objective is to replicate real-world, short-term ad hoc projects that data analysts often encounter in a fast-paced business environment.

At Pinnacle Electronics, analysts frequently handle high-priority, quick-turnaround requests from various teams, including sales, marketing, supply chain, and finance. These tasks may involve anything from extracting customer and sales data for regional managers to analyzing product performance trends across different markets.

This simulation works on a time-sensitive assignment that requires efficient data extraction, analysis, and reporting—a task designed to reflect real-world business needs that can be accomplished within 1-3 days. The focus is on delivering actionable insights, helping stakeholders make informed decisions in a competitive market

### Objective
Senior management at Pinnacle Electronics wants a comprehensive snapshot of Q1 (January – March 2021) sales performance across all regions. They need to see:
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

### ***Revenue by Store***
Store 0 is the top-performing location, generating 27.5% of total Q1 revenue, far surpassing Store 55, which ranks second at just 4.9%. Store 0’s dominance is driven by higher sales volume, accounting for 27.5% of all units sold, with Store 55 trailing at 4.1%. This significant gap suggests that Store 0 benefits from stronger demand or a more effective sales strategy compared to other locations.

In Store 0, desktops and laptops dominate sales, contributing 63.3% and 19.0% of total sales, respectively, reflecting a strong customer preference for computing devices. Additionally, across the top 10 stores, desktops, laptops, and projectors & screens consistently rank as the top three revenue drivers, reinforcing their importance in overall sales performance.

#### ***Recommendations:***
To improve sales in underperforming stores, optimizing pricing and promotions for desktops and laptops through targeted discounts, bundle deals, and financing options could help attract more buyers and maximize revenue.

Enhancing marketing efforts by leveraging insights from Store 0, such as refining advertising strategies, improving product placement, and implementing localized promotions, can drive greater customer engagement.
Additionally, analyzing store-specific factors such as foot traffic, customer demographics, and purchasing behavior will help tailor strategies to each location’s unique needs.
Finally, investing in sales training and improving customer experience by equipping staff with better product knowledge and engagement techniques can enhance customer interactions and increase conversion rates across all stores.

### ***Top Products by Revenue and Units Sold***
Overall, desktops, laptops, and projectors generate the highest sales revenue across the top 10 stores. However, they do not lead in total units sold. Desktops rank second, while Movie DVDs hold the top spot, followed by Touch Screen Phones in third place. This suggests that while DVDs and phones sell in higher volumes, desktops contribute more significantly to revenue per unit.

#### ***Recommendations:***
Since desktops, laptops, and projectors drive the most revenue, it may be beneficial to prioritize inventory, pricing strategies, and marketing efforts for these categories to sustain profitability.

Since Movie DVDs and touch screen phones sell in large quantities, exploring bulk promotions, bundle deals, or cross-selling opportunities with higher-margin items could help maximize overall profitability.

Offering targeted discounts or promotions on desktops could help boost sales volume without significantly impacting revenue, while accessories for high-volume products might present an opportunity for additional sales.

### ***Revenue Trend Analysis***
The Q1 revenue trend reveals significant fluctuations, with sharp spikes and dips throughout the quarter rather than a consistent upward or downward pattern. Notably, revenue peaked at $41K on January 3rd, followed by multiple declines and recoveries, including another high of $34K on January 31st. These periodic surges suggest that sales activity may be influenced by external factors such as promotions, seasonal demand, or pay cycles, while the frequent dips highlight potential inconsistencies in daily sales performance. Identifying the drivers behind these fluctuations can help in refining inventory management, promotional timing, and sales strategies to stabilize revenue flow.

#### ***Recommendations:***
To gain deeper insights into revenue fluctuations, it would be beneficial to analyze trends from previous quarters and identify recurring patterns. If similar spikes and dips have occurred in past quarters, this could indicate seasonal trends, promotional impacts, or shifts in customer purchasing behavior. Understanding these patterns can help in forecasting demand, optimizing promotional timing, and improving inventory planning to better align with expected sales cycles. 

Additionally, comparing Q1 performance with previous periods can provide valuable context for assessing whether the observed trends are unique to this quarter or part of a larger business cycle, allowing for more strategic decision-making.

### Final Thought: Expanding Customer Data for Deeper Insights
While the existing customer table provides valuable information, such as customer ID, location, and basic demographic details, additional data collection can significantly enhance the ability to analyze customer behavior, demand patterns, and purchasing trends. To gain a more comprehensive understanding of customer behavior and demand, it would be beneficial to gather data on purchase history and frequency, tracking how often customers buy, what they purchase, and their spending trends over time. This will support customer segmentation, retention analysis, and lifetime value assessment.

Capturing customer preferences and interests, including product preferences, preferred shopping channels (in-store vs. online), and engagement with promotions, can refine targeted marketing campaigns. Additionally, recording basket composition and product affinity, or which products are frequently bought together, will enable better cross-selling, bundling, and upselling strategies. Collecting feedback and satisfaction scores through surveys or reviews will help assess pricing sensitivity, service quality, and overall shopping experience, allowing for data-driven service improvements.

Furthermore, monitoring customer engagement with promotions—such as responses to discounts, loyalty programs, and advertising efforts—will allow for more effective promotional strategies and improved ROI. Gathering insights on competitor price sensitivity and purchase influences, such as how external factors like competitor pricing, seasonality, or economic conditions impact buying decisions, will strengthen pricing optimization and demand forecasting.

By incorporating these additional data points, Pinnacle Electronics can improve customer retention strategies, personalize marketing efforts, optimize inventory distribution, and enhance overall sales performance. Expanding customer data collection will provide a strong foundation for predictive analytics and strategic decision-making across all stores.






