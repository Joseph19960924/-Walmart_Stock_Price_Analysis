SELECT *
FROM WMT
LIMIT 5;

-- Count the total number of rows in the dataset:
SELECT COUNT(*) AS total_rows
FROM WMT;

-- Show the column names and their data types:
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'WMT';

-- Find the earliest and latest dates in the dataset:
SELECT MIN(Date) AS earliest_date, MAX(Date) AS latest_date
FROM WMT;

-- Calculate the average closing price of Walmart stocks
SELECT AVG(Close) AS average_closing_price
FROM WMT;

-- Calculate the quarterly average closing prices to identify trends within shorter time periods.
SELECT CONCAT(YEAR(Date), '-', QUARTER(Date)) AS Quarter,
       AVG(Close) AS Average_Closing_Price
FROM WMT
GROUP BY Quarter
ORDER BY Quarter;

-- Identify the highest and lowest closing prices for each month to spot volatility.
SELECT DATE_FORMAT(Date, '%Y-%m') AS Month,
       MAX(Close) AS Highest_Closing_Price,
       MIN(Close) AS Lowest_Closing_Price
FROM WMT
GROUP BY Month
ORDER BY Month;

-- Analyze the trading volume trends over time to understand investor activity
SELECT DATE_FORMAT(Date, '%Y-%m') AS Month,
       SUM(Volume) AS Total_Volume
FROM WMT
GROUP BY Month
ORDER BY Month;

-- Calculate the percentage change in closing prices from one year to the next to assess annual growth.
SELECT YEAR(Date) AS Year,
       (MAX(Close) - MIN(Close)) / MIN(Close) AS Yearly_Percentage_Change
FROM WMT
GROUP BY Year
ORDER BY Year;
-- Standard Deviation of Closing Prices:
SELECT STDDEV(Close) AS Closing_Price_Standard_Deviation
FROM WMT;

-- Identifying days with significant changes in stock prices.
SELECT Date
FROM (
    SELECT Date,
           ABS(Close - LAG(Close) OVER (ORDER BY Date)) AS Price_Change
    FROM WMT
) AS Price_Changes
WHERE Price_Change > 5 
ORDER BY Date;

-- Explore the correlation between different variables such as opening, closing, high, low prices, and trading volume
SELECT
    (COUNT(*) * SUM(Open * Close) - SUM(Open) * SUM(Close)) /
    SQRT((COUNT(*) * SUM(Open * Open) - SUM(Open) * SUM(Open)) * (COUNT(*) * SUM(Close * Close) - SUM(Close) * SUM(Close))) AS Open_Close_Correlation,
    (COUNT(*) * SUM(High * Low) - SUM(High) * SUM(Low)) /
    SQRT((COUNT(*) * SUM(High * High) - SUM(High) * SUM(High)) * (COUNT(*) * SUM(Low * Low) - SUM(Low) * SUM(Low))) AS High_Low_Correlation,
    (COUNT(*) * SUM(Volume * Close) - SUM(Volume) * SUM(Close)) /
    SQRT((COUNT(*) * SUM(Volume * Volume) - SUM(Volume) * SUM(Volume)) * (COUNT(*) * SUM(Close * Close) - SUM(Close) * SUM(Close))) AS Volume_Close_Correlation
FROM WMT;

-- Analyze whether there are any patterns in stock prices based on the day of the week. For example:
SELECT
    Date,
    (COUNT(*) * SUM(Open * Close) - SUM(Open) * SUM(Close)) /
    SQRT((COUNT(*) * SUM(Open * Open) - SUM(Open) * SUM(Open)) * (COUNT(*) * SUM(Close * Close) - SUM(Close) * SUM(Close))) AS Open_Close_Correlation,
    (COUNT(*) * SUM(High * Low) - SUM(High) * SUM(Low)) /
    SQRT((COUNT(*) * SUM(High * High) - SUM(High) * SUM(High)) * (COUNT(*) * SUM(Low * Low) - SUM(Low) * SUM(Low))) AS High_Low_Correlation,
    (COUNT(*) * SUM(Volume * Close) - SUM(Volume) * SUM(Close)) /
    SQRT((COUNT(*) * SUM(Volume * Volume) - SUM(Volume) * SUM(Volume)) * (COUNT(*) * SUM(Close * Close) - SUM(Close) * SUM(Close))) AS Volume_Close_Correlation
FROM WMT
GROUP BY Date;

-- Calculate the percentage change in stock prices from the previous day. 
SELECT
    Date,
    (Close - lag_close) / lag_close * 100 AS Percentage_Change
FROM (
    SELECT
        Date,
        Close,
        LAG(Close) OVER (ORDER BY Date) AS lag_close
    FROM WMT
) AS lagged_data;

-- Determine whether the stock price increased or decreased compared to the previous day.
SELECT
    Date,
    CASE
        WHEN Close > LAG(Close) OVER (ORDER BY Date) THEN 'Increase'
        WHEN Close < LAG(Close) OVER (ORDER BY Date) THEN 'Decrease'
        ELSE 'No Change'
    END AS Price_Movement
FROM WMT;

-- Calculate the volume-weighted average price, which gives more weight to periods with higher trading volume
SELECT
    Date,
    SUM(Close * Volume) / SUM(Volume) AS VWAP
FROM WMT
GROUP BY Date;






















