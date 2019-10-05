USE AdventureWorks2012;
GO

/*
  Вывести на экран список сотрудников с указанием максимальной ставки, по которой им выплачивали денежные средства.
*/
SELECT employee.BusinessEntityID, employee.JobTitle, MAX(employeePayHistory.Rate) as MaxRate FROM HumanResources.Employee employee
LEFT JOIN HumanResources.EmployeePayHistory employeePayHistory ON employeePayHistory.BusinessEntityID = employee.BusinessEntityID
GROUP BY employee.BusinessEntityID, employee.JobTitle;

/*
  Разбить все почасовые ставки на группы таким образом, чтобы одинаковые ставки входили в одну группу.
  Номера групп должны быть распределены по возрастанию ставок. Назовите столбец [RankRate].
*/
SELECT
	payHistory.BusinessEntityID,
	employee.JobTitle,
	payHistory.Rate,
	DENSE_RANK() OVER (ORDER BY payHistory.Rate) AS Rank
FROM HumanResources.EmployeePayHistory payHistory
LEFT JOIN HumanResources.Employee employee ON employee.BusinessEntityID = payHistory.BusinessEntityID
ORDER BY payHistory.Rate;

/*
  Вывести на экран информацию об отделах и работающих в них сотрудниках, отсортированную по полю ShiftID в отделе ‘Document Control’
  и по полю BusinessEntityID во всех остальных отделах.
*/
SELECT
	department.Name as DepName,
	employee.BusinessEntityID,
	employee.JobTitle,
	empDepHistory.ShiftID
FROM HumanResources.Department department
LEFT JOIN HumanResources.EmployeeDepartmentHistory empDepHistory ON empDepHistory.DepartmentID = department.DepartmentID
LEFT JOIN HumanResources.Employee employee ON employee.BusinessEntityID = empDepHistory.BusinessEntityID
WHERE empDepHistory.EndDate IS NULL
ORDER BY
	department.Name,
	CASE WHEN department.Name = 'Document Control' THEN empDepHistory.ShiftID ELSE employee.BusinessEntityID END;