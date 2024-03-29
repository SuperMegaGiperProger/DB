USE AdventureWorks2012;
GO

/*
  ������� �� ����� ������ ����������� � ��������� ������������ ������, �� ������� �� ����������� �������� ��������.
*/
SELECT employee.BusinessEntityID, employee.JobTitle, MAX(employeePayHistory.Rate) as MaxRate FROM HumanResources.Employee employee
LEFT JOIN HumanResources.EmployeePayHistory employeePayHistory ON employeePayHistory.BusinessEntityID = employee.BusinessEntityID
GROUP BY employee.BusinessEntityID, employee.JobTitle;

/*
  ������� ��� ��������� ������ �� ������ ����� �������, ����� ���������� ������ ������� � ���� ������.
  ������ ����� ������ ���� ������������ �� ����������� ������. �������� ������� [RankRate].
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
  ������� �� ����� ���������� �� ������� � ���������� � ��� �����������, ��������������� �� ���� ShiftID � ������ �Document Control�
  � �� ���� BusinessEntityID �� ���� ��������� �������.
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