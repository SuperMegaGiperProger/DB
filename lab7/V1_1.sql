USE AdventureWorks2012;
GO

/*
	Вывести значения полей [BusinessEntityID], [NationalIDNumber] и [JobTitle] из таблицы [HumanResources][Employee] в виде xml,
	сохраненного в переменную.
*/
DECLARE @XML XML;

SET @XML = (
    SELECT BusinessEntityID AS '@ID', NationalIDNumber, JobTitle
    FROM HumanResources.Employee
    FOR XML PATH ('Employee'), ROOT ('Employees')
);

SELECT @XML;

/*
	Создать временную таблицу и заполнить её данными из переменной, содержащей xml.
*/
SELECT
    node.value('@ID', 'INT') as BusinessEntityID,
    node.value('NationalIDNumber[1]', 'NVARCHAR(15)') as NationalIDNumber,
    node.value('JobTitle[1]', 'NVARCHAR(50)') as JobTitle
INTO #Employees
FROM @XML.nodes('/Employees/Employee') AS xml(node);

SELECT * FROM #Employees;