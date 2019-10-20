USE AdventureWorks2012;
GO

/*
	a) добавьте в таблицу dbo.Person поле FullName типа nvarchar размерностью 100 символов;
*/
ALTER TABLE dbo.Person
ADD FullName nvarchar(100);
GO

/*
	b) объявите табличную переменную с такой же структурой как dbo.Person и заполните ее данными из dbo.Person.
	   Поле Title заполните на основании данных из поля Gender таблицы HumanResources.Employee, если gender=M тогда Title=’Mr.’,
	   если gender=F тогда Title=’Ms.’;
*/
DECLARE @Person TABLE (
	BusinessEntityID INT,
	PersonType nchar(2),
	NameStyle NameStyle NULL,
	Title nvarchar(8),
	FirstName Name,
	MiddleName Name,
	LastName Name,
	Suffix nvarchar(5),
	EmailPromotion INT,
	ModifiedDate datetime,
	ID bigint,
	FullName nvarchar(100)
);

INSERT INTO @Person (
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
	FullName
)
SELECT
	person.BusinessEntityID,
	person.PersonType,
	person.NameStyle,
	CASE employee.Gender
		WHEN 'M' THEN 'Mr.'
		WHEN 'F' THEN 'Ms.'
		ELSE NULL
	END as Title,
	person.FirstName,
	person.MiddleName,
	person.LastName,
	person.Suffix,
	person.EmailPromotion,
	person.ModifiedDate,
	person.ID,
	person.FullName
FROM dbo.Person person
LEFT JOIN HumanResources.Employee employee ON employee.BusinessEntityID = person.BusinessEntityID;

/*
	c) обновите поле FullName в dbo.Person данными из табличной переменной, объединив информацию
	    из полей Title, FirstName, LastName (например ‘Mr. Jossef Goldberg’);
*/
MERGE INTO dbo.Person person
USING @Person person2 ON person.ID = person2.ID
WHEN MATCHED THEN
   UPDATE SET person.FullName = CONCAT(person2.Title, ' ', person2.FirstName, ' ', person2.LastName);

/*
	d) удалите данные из dbo.Person, где количество символов в поле FullName превысило 20 символов;
*/
DELETE FROM dbo.Person WHERE LEN(FullName) > 20;

/*
	e) удалите все созданные ограничения и значения по умолчанию. После этого, удалите поле ID.
*/
ALTER TABLE dbo.Person
DROP CONSTRAINT PK__Person__3214EC271F0F7A0F, CHK_Title, DF_Suffix;

ALTER TABLE dbo.Person
DROP COLUMN ID;

/*
	f) удалите таблицу dbo.Person.
*/
DROP TABLE dbo.Person;
