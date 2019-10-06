USE AdventureWorks2012;
GO

/*
  a) создайте таблицу dbo.Person с такой же структурой как Person.Person, кроме полей xml, uniqueidentifier, не включа€ индексы, ограничени€ и триггеры;
*/
CREATE TABLE dbo.Person (
	BusinessEntityID INT,
	PersonType nchar(2),
	NameStyle NameStyle NULL,
	Title nvarchar(8),
	FirstName Name,
	MiddleName Name,
	LastName Name,
	Suffix nvarchar(10),
	EmailPromotion INT,
	ModifiedDate datetime
);
GO

/*
  b) использу€ инструкцию ALTER TABLE, добавьте в таблицу dbo.Person новое поле ID, которое €вл€етс€ первичным ключом типа bigint и имеет свойство identity.
  Ќачальное значение дл€ пол€ identity задайте 10 и приращение задайте 10;
*/
ALTER TABLE dbo.Person
ADD ID bigint PRIMARY KEY IDENTITY(10, 10);
GO

/*
  c) использу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.Person ограничение дл€ пол€ Title, чтобы заполнить его можно было только значени€ми СMr.Т или СMs.Т;
*/
ALTER TABLE dbo.Person
ADD CONSTRAINT CHK_Title CHECK (Title IN ('Mr.', 'Ms.'));
GO

/*
  d) использу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.Person ограничение DEFAULT дл€ пол€ Suffix, задайте значение по умолчанию СN/AТ;
*/
ALTER TABLE dbo.Person
ADD CONSTRAINT DF_Suffix DEFAULT 'N/A' FOR Suffix;
GO

/*
  e) заполните новую таблицу данными из Person.Person только дл€ тех сотрудников, которые существуют в таблице HumanResources.Employee,
     исключив сотрудников из отдела СExecutiveТ;
*/
INSERT INTO dbo.Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate
) SELECT DISTINCT 
	person.BusinessEntityID,
	person.PersonType,
	person.NameStyle,
	person.Title,
	person.FirstName,
	person.MiddleName,
	person.LastName,
	person.Suffix,
	person.EmailPromotion,
	person.ModifiedDate
FROM Person.Person person
INNER JOIN HumanResources.Employee employee ON employee.BusinessEntityID = person.BusinessEntityID
LEFT JOIN HumanResources.EmployeeDepartmentHistory empDepHistory ON empDepHistory.BusinessEntityID = employee.BusinessEntityID
LEFT JOIN HumanResources.Department department ON department.DepartmentID = empDepHistory.DepartmentID
WHERE
	empDepHistory.EndDate IS NULL
	AND department.Name <> 'Executive';

/*
  f) измените размерность пол€ Suffix, уменьшите размер пол€ до 5-ти символов.
*/
ALTER TABLE dbo.Person
ALTER COLUMN Suffix nvarchar(5);
GO