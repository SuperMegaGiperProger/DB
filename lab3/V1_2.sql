USE AdventureWorks2012;
GO

/*
	a) выполните код, созданный во втором задании второй лабораторной работы.
	   Добавьте в таблицу dbo.Person поля SalesYTD MONEY, SalesLastYear MONEY и OrdersNum INT.
	   Также создайте в таблице вычисляемое поле SalesDiff, считающее разницу значений в полях SalesYTD и SalesLastYear.
*/
ALTER TABLE dbo.Person
ADD
	SalesYTD MONEY,
	SalesLastYear MONEY,
	OrdersNum INT,
	SalesDiff AS (SalesLastYear - SalesYTD);
GO

/*
	b) создайте временную таблицу #Person, с первичным ключом по полю BusinessEntityID.
	   Временная таблица должна включать все поля таблицы dbo.Person за исключением поля SalesDiff.
*/
CREATE TABLE #Person (
	BusinessEntityID INT,
	PersonType nchar(2),
	NameStyle bit NULL,
	Title nvarchar(8),
	FirstName nvarchar(50),
	MiddleName nvarchar(50),
	LastName nvarchar(50),
	Suffix nvarchar(5),
	EmailPromotion INT,
	ModifiedDate datetime,
	ID bigint,
	SalesYTD MONEY,
	SalesLastYear MONEY,
	OrdersNum INT,
	PRIMARY KEY (BusinessEntityID)
);
GO

/*
	c) заполните временную таблицу данными из dbo.Person. Поля SalesYTD и SalesLastYear заполните значениями
	   из таблицы Sales.SalesPerson. Посчитайте количество заказов, оформленных каждым продавцом (SalesPersonID)
	   в таблице Sales.SalesOrderHeader и заполните этими значениями поле OrdersNum.
	   Подсчет количества заказов осуществите в Common Table Expression (CTE).
*/
WITH OrdersNum_CTE AS (
	SELECT
		SalesPersonID as BusinessEntityID,
		COUNT(SalesOrderID) as Count
	FROM Sales.SalesOrderHeader
	GROUP BY SalesPersonID
)
INSERT INTO #Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	ID,
	SalesYTD,
	SalesLastYear,
	OrdersNum
)
SELECT
	person.BusinessEntityID,
	person.PersonType,
	person.NameStyle,
	person.Title,
	person.FirstName,
	person.MiddleName,
	person.LastName,
	person.Suffix,
	person.EmailPromotion,
	person.ModifiedDate,
	person.ID,
	sales.SalesYTD,
	sales.SalesLastYear,
	OrdersNum_CTE.Count
FROM dbo.Person person
LEFT JOIN Sales.SalesPerson sales ON sales.BusinessEntityID = person.BusinessEntityID
LEFT JOIN OrdersNum_CTE ON OrdersNum_CTE.BusinessEntityID = person.BusinessEntityID;

/*
	d) удалите из таблицы dbo.Person одну строку (где BusinessEntityID = 290)
*/
DELETE FROM dbo.Person WHERE BusinessEntityID = 290;

/*
	e) напишите Merge выражение, использующее dbo.Person как target, а временную таблицу как source.
	   Для связи target и source используйте BusinessEntityID. Обновите поля SalesYTD, SalesLastYear
	   и OrdersNum таблицы dbo.Person, если запись присутствует и в source и в target.
	   Если строка присутствует во временной таблице, но не существует в target, добавьте строку в dbo.Person.
	   Если в dbo.Person присутствует такая строка, которой не существует во временной таблице, удалите строку из dbo.Person.
*/
MERGE INTO dbo.Person AS target_t
USING #Person AS source_t ON target_t.BusinessEntityID = source_t.BusinessEntityID
WHEN MATCHED THEN
	UPDATE SET
		SalesYTD = source_t.SalesYTD,
		SalesLastYear = source_t.SalesLastYear,
		OrdersNum = source_t.OrdersNum
WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		BusinessEntityID,
		PersonType,
		NameStyle,
		Title,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		EmailPromotion,
		ModifiedDate,
		SalesYTD,
		SalesLastYear,
		OrdersNum
	)
	VALUES (
		source_t.BusinessEntityID,
		source_t.PersonType,
		source_t.NameStyle,
		source_t.Title,
		source_t.FirstName,
		source_t.MiddleName,
		source_t.LastName,
		source_t.Suffix,
		source_t.EmailPromotion,
		source_t.ModifiedDate,
		source_t.SalesYTD,
		source_t.SalesLastYear,
		source_t.OrdersNum
	)
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;