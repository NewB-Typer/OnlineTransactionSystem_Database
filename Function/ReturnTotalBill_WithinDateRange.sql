--- Function To Return TotalBill By Date Range ---


CREATE  FUNCTION returnBillByDateRange (
@CustomerID VARCHAR(MAX),
@start_Date DATE,
@end_Date DATE
)
RETURNS TABLE AS 
RETURN
(
SELECT i.Customer_id, SUM(i.TotalBill) AS TotalBill
FROM Invoice i 
-- splits the inputs into separate rows
WHERE i.Customer_id IN (SELECT VALUE FROM STRING_SPLIT(@CustomerID, ','))
AND i.IssuedDate >= @start_Date 
AND i.IssuedDate <= @end_Date
GROUP BY i.Customer_id
);



-- Execution of the function
DECLARE @CustomerID VARCHAR(MAX) = '119,102';
DECLARE @start_Date DATE = '2022-01-01';
DECLARE @end_Date DATE = '2023-12-31'

-- Retrieving the result
SELECT Customer_id, TotalBill
FROM dbo.returnBillByDateRange(@CustomerID, @start_Date, @end_Date);
   
