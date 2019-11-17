USE AdventureWorks2012;
GO

/*
	a) Создайте scalar-valued функцию, которая будет принимать в качестве входного параметра имя группы отделов (HumanResources.Department.GroupName)
	   и возвращать количество отделов, входящих в эту группу.
*/
CREATE FUNCTION HumanResources.DepartmentsCountFor(@GroupName nvarchar(50))
RETURNS int
BEGIN
	RETURN (
		SELECT COUNT(*) FROM HumanResources.Department
		WHERE Department.GroupName = @GroupName
	)
END;
GO

/*
	b) Создайте inline table-valued функцию, которая будет принимать в качестве входного параметра id отдела (HumanResources.Department.DepartmentID),
	   а возвращать 3 самых старших сотрудника, которые начали работать в отделе с 2005 года.
*/
CREATE FUNCTION HumanResources.GetOldestDepartmentEmployees(@DepartmentID int)
RETURNS TABLE AS
RETURN (
	SELECT TOP(3) empl.* FROM HumanResources.Employee empl
	INNER JOIN HumanResources.EmployeeDepartmentHistory hist ON empl.BusinessEntityID = hist.BusinessEntityID
	WHERE hist.DepartmentID = @DepartmentID AND hist.StartDate >= '2005' AND hist.EndDate IS NULL
	ORDER BY empl.BirthDate ASC
);
GO

/*
	c) Вызовите функцию для каждого отдела, применив оператор CROSS APPLY. Вызовите функцию для каждого отдела, применив оператор OUTER APPLY.
*/
SELECT
	department.DepartmentID,
	employee.*
FROM HumanResources.Department department
CROSS APPLY HumanResources.GetOldestDepartmentEmployees(department.DepartmentID) employee;

SELECT
	department.DepartmentID,
	employee.*
FROM HumanResources.Department department
OUTER APPLY HumanResources.GetOldestDepartmentEmployees(department.DepartmentID) employee;

/*
	d) Измените созданную inline table-valued функцию, сделав ее multistatement table-valued (предварительно сохранив для проверки
	   код создания inline table-valued функции).
*/
DROP FUNCTION HumanResources.GetOldestDepartmentEmployees;

CREATE FUNCTION HumanResources.GetOldestDepartmentEmployees(@DepartmentID int)
RETURNS @ResultTable TABLE(
	BusinessEntityID INT NOT NULL,
	BirthDate DATE NOT NULL,
	HireDate DATE NOT NULL,
	rowguid UNIQUEIDENTIFIER NOT NULL,
	ModifiedDate DATETIME NOT NULL
) AS BEGIN
	INSERT INTO @ResultTable
	SELECT TOP(3)
		empl.BusinessEntityID,
		empl.BirthDate,
		empl.HireDate,
		empl.rowguid,
		empl.ModifiedDate
	FROM HumanResources.Employee empl
	INNER JOIN HumanResources.EmployeeDepartmentHistory hist ON empl.BusinessEntityID = hist.BusinessEntityID
	WHERE hist.DepartmentID = @DepartmentID AND hist.StartDate >= '2005' AND hist.EndDate IS NULL
	ORDER BY empl.BirthDate ASC

	RETURN
END;
GO