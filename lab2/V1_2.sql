USE AdventureWorks2012;
GO

/*
  a) �������� ������� dbo.Person � ����� �� ���������� ��� Person.Person, ����� ����� xml, uniqueidentifier, �� ������� �������, ����������� � ��������;
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
  b) ��������� ���������� ALTER TABLE, �������� � ������� dbo.Person ����� ���� ID, ������� �������� ��������� ������ ���� bigint � ����� �������� identity.
  ��������� �������� ��� ���� identity ������� 10 � ���������� ������� 10;
*/
ALTER TABLE dbo.Person
ADD ID bigint PRIMARY KEY IDENTITY(10, 10);
GO

/*
  c) ��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Person ����������� ��� ���� Title, ����� ��������� ��� ����� ���� ������ ���������� �Mr.� ��� �Ms.�;
*/
ALTER TABLE dbo.Person
ADD CONSTRAINT CHK_Title CHECK (Title IN ('Mr.', 'Ms.'));
GO

/*
  d) ��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Person ����������� DEFAULT ��� ���� Suffix, ������� �������� �� ��������� �N/A�;
*/
ALTER TABLE dbo.Person
ADD CONSTRAINT DF_Suffix DEFAULT 'N/A' FOR Suffix;
GO

/*
  e) ��������� ����� ������� ������� �� Person.Person ������ ��� ��� �����������, ������� ���������� � ������� HumanResources.Employee,
     �������� ����������� �� ������ �Executive�;
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
  f) �������� ����������� ���� Suffix, ��������� ������ ���� �� 5-�� ��������.
*/
ALTER TABLE dbo.Person
ALTER COLUMN Suffix nvarchar(5);
GO