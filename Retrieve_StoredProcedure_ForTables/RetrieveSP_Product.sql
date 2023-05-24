-- Retrieve(Select) OPeration for Product Table ---


CREATE PROCEDURE spRetrieveProduct
    @jsonData NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @ProductId INT,
                @Name VARCHAR(100),
                @Price DECIMAL(6,2),
                @RemainingInStock INT;

        
        SELECT @ProductId = JSON_VALUE(@jsonData, '$.Product_id'),
               @Name = JSON_VALUE(@jsonData, '$.Name'),
               @Price = JSON_VALUE(@jsonData, '$.Price'),
               @RemainingInStock = JSON_VALUE(@jsonData, '$.RemainingInStock');

        
        SELECT *
        FROM Product
        WHERE (Product_id = @ProductId OR @ProductId IS NULL)
          AND (Name = @Name OR @Name IS NULL)
          AND (Price = @Price OR @Price IS NULL)
          AND (RemainingInStock = @RemainingInStock OR @RemainingInStock IS NULL);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        
        THROW;
    END CATCH;
END



--Execution code

DECLARE @jsonData NVARCHAR(MAX) = '{"Product_id": 16}';
EXEC spRetrieveProduct @jsonData = @jsonData;
