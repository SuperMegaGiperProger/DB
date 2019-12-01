USE AdventureWorks2012;
GO

/*
	Создайте хранимую процедуру, которая будет возвращать сводную таблицу (оператор PIVOT),
	отображающую данные о суммарном количестве проданных продуктов (Sales.SalesOrderDetail.OrderQty) за определенный
	год	(Sales.SalesOrderHeader.OrderDate). Список лет передайте в процедуру через входной параметр.
*/

CREATE PROCEDURE dbo.OrdersByYear (@Years NVARCHAR(1000)) AS
BEGIN
	EXEC('
		SELECT Name, ' + @Years + ' FROM (
			SELECT
				product.Name,
				YEAR(header.OrderDate) as year,
				detail.OrderQty
			FROM Sales.SalesOrderDetail detail
			INNER JOIN Sales.SalesOrderHeader header ON detail.SalesOrderID = header.SalesOrderID
			INNER JOIN Production.Product product ON product.ProductID = detail.ProductID
		) as data
		PIVOT (
			SUM(data.OrderQty) FOR data.year IN(' + @Years + ')
		) as history
	');
END;

EXECUTE dbo.OrdersByYear '[2008], [2007], [2006]';