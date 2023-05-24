--Retrieve OPeration(Select) ---
-- For STransaction Table


CREATE PROCEDURE spRetrieveSTransaction
    @jsonData NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @TransactionId INT, 
                @CustomerId INT,
                @ProductId INT,
                @Quantity INT,
                @UnitPrice DECIMAL(6,2),
                @TotalAmount DECIMAL(8,2),
              	@Invoice_id INT;

     
        SELECT @TransactionId = JSON_VALUE(@jsonData, '$.Transaction_id'),
               @CustomerId = JSON_VALUE(@jsonData, '$.Customer_id'),
               @ProductId = JSON_VALUE(@jsonData, '$.Product_id'),
               @Quantity = JSON_VALUE(@jsonData, '$.Quantity'),
               @UnitPrice = JSON_VALUE(@jsonData, '$.UnitPrice'),
               @TotalAmount = JSON_VALUE(@jsonData, '$.TotalAmount'),
              @Invoice_id = JSON_VALUE(@jsonData, '$.Invoice_id');

        -- Retrieve data based on given values
        SELECT *
        FROM STransaction
        WHERE (Transaction_id = @TransactionId OR @TransactionId IS NULL)
          AND (Customer_id = @CustomerId OR @CustomerId IS NULL)
          AND (Product_id = @ProductId OR @ProductId IS NULL)
          AND (Quantity = @Quantity OR @Quantity IS NULL)
          AND (UnitPrice = @UnitPrice OR @UnitPrice IS NULL)
          AND (TotalAmount = @TotalAmount OR @TotalAmount IS NULL)
          AND (Invoice_id = @Invoice_id OR @Invoice_id IS NULL);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        
        THROW;
    END CATCH;
END



-- Execution code

DECLARE @jsonData NVARCHAR(MAX) = '{"Transaction_id": 401}';
EXEC spRetrieveSTransaction @jsonData = @jsonData;
