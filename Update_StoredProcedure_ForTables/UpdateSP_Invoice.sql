---- Update Operation For table Invoice  ----


CREATE PROCEDURE spUpdateOperation_Invoice
  @jsonInput NVARCHAR(MAX)
AS
BEGIN
  SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRANSACTION;

    -- Temporarily stores the updated invoice data in a table variable
    DECLARE @UpdatedInvoices TABLE
    (
      Invoice_id INT PRIMARY KEY,
      Customer_id INT,
      TotalBill DECIMAL(8, 2),
      IssuedDate DATE
    );

    -- Update the Invoice table using the provided JSON data
    UPDATE Invoice
    SET
      Customer_id = JSON_VALUE(@jsonInput, '$.Customer_id'),
      TotalBill = JSON_VALUE(@jsonInput, '$.TotalBill'),
      IssuedDate = JSON_VALUE(@jsonInput, '$.IssuedDate')
    OUTPUT
      INSERTED.Invoice_id,
      INSERTED.Customer_id,
      INSERTED.TotalBill,
      INSERTED.IssuedDate
    INTO @UpdatedInvoices
    WHERE
      Invoice_id = JSON_VALUE(@jsonInput, '$.Invoice_id');

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
  "Invoice_id": 203 ,
  "IssuedDate": "2023-04-20"}';

EXEC spUpdateOperation_Invoice @jsonInput = @jsonData;



