--- Retrieve(Select) operation for Invoice Table ---


CREATE PROCEDURE spRetrieveInvoice
    @jsonData NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @InvoiceId INT,
                @CustomerId INT,
                @TotalBill DECIMAL(8,2),
                @IssuedDate DATE;

    
        SELECT @InvoiceId = JSON_VALUE(@jsonData, '$.Invoice_id'),
               @CustomerId = JSON_VALUE(@jsonData, '$.Customer_id'),
               @TotalBill = JSON_VALUE(@jsonData, '$.TotalBill'),
               @IssuedDate = JSON_VALUE(@jsonData, '$.IssuedDate');

        SELECT *
        FROM Invoice
        WHERE (Invoice_id = @InvoiceId OR @InvoiceId IS NULL)
          AND (Customer_id = @CustomerId OR @CustomerId IS NULL)
          AND (TotalBill = @TotalBill OR @TotalBill IS NULL)
          AND (IssuedDate = @IssuedDate OR @IssuedDate IS NULL);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        
        THROW;
    END CATCH;
END



--Execution code

DECLARE @jsonData NVARCHAR(MAX) = '{ }';
EXEC spRetrieveInvoice @jsonData = @jsonData;

