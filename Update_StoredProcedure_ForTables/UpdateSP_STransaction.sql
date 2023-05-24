--- Update Operation For table STransaction ---



CREATE PROCEDURE spUpdateOperation_STransaction
  @jsonInput NVARCHAR(MAX)
AS
BEGIN
  SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRANSACTION;

    -- Temporarily stores the updated transaction data 
    DECLARE @UpdatedSTransactions TABLE
    (
      Transaction_id INT PRIMARY KEY,
      Customer_id INT,
      Product_id INT,
      Quantity INT,
      UnitPrice DECIMAL(6, 2),
      TotalAmount DECIMAL(8, 2),
      Invoice_id INT
    );

    -- Update the STransaction table using the provided JSON data
    UPDATE STransaction
    SET
      Customer_id = JSON_VALUE(@jsonInput, '$.Customer_id'),
      Product_id = JSON_VALUE(@jsonInput, '$.Product_id'),
      Quantity = JSON_VALUE(@jsonInput, '$.Quantity'),
      UnitPrice = JSON_VALUE(@jsonInput, '$.UnitPrice'),
      TotalAmount = JSON_VALUE(@jsonInput, '$.TotalAmount'),
      Invoice_id = JSON_VALUE(@jsonInput, '$.Invoice_id')
    OUTPUT
      INSERTED.Transaction_id,
      INSERTED.Customer_id,
      INSERTED.Product_id,
      INSERTED.Quantity,
      INSERTED.UnitPrice,
      INSERTED.TotalAmount,
      INSERTED.Invoice_id
    INTO @UpdatedSTransactions
    WHERE
      Transaction_id = JSON_VALUE(@jsonInput, '$.Transaction_id');

    COMMIT;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK;

    THROW;
  END CATCH;
END



-- Execution Code

DECLARE @jsonData NVARCHAR(MAX);
SET @jsonData = '{
  "Transaction_id": 403 ,
  "Quantity": 10}';

EXEC spUpdateOperation_STransaction @jsonInput = @jsonData;


