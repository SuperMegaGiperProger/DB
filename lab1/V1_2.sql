USE AdventureWorks2012;
GO

/*
	¬ывести на экран сотрудников, позици€ которых находитс€ в списке:
	  СAccounts ManagerТ,ТBenefits SpecialistТ,ТEngineering ManagerТ,ТFinance ManagerТ,ТMaintenance SupervisorТ,ТMaster SchedulerТ,ТNetwork ManagerТ.
	¬ыполните задание не использу€ оператор С=Т.
*/
SELECT
	BusinessEntityID,
	JobTitle,
	Gender,
	HireDate
FROM HumanResources.Employee
WHERE JobTitle IN (
	'Accounts Manager', 'Benefits Specialist', 'Engineering Manager', 'Finance Manager',
	'Maintenance Supervisor', 'Master Scheduler', 'Network Manager'
);

/*
	¬ывести на экран количество сотрудников, прин€тых на работу позже 2004 года (включа€ 2004 год).
*/
SELECT COUNT(*) as EmpCount FROM HumanResources.Employee
WHERE HireDate >= '2004-01-01';

/*
	¬ывести на экран 5(п€ть) самых молодых сотрудников, состо€щих в браке, которые были прин€ты на работу в 2004 году.
*/
SELECT TOP(5)
	BusinessEntityID,
	JobTitle,
	MaritalStatus,
	Gender,
	BirthDate,
	HireDate
FROM HumanResources.Employee
WHERE MaritalStatus = 'M'
	AND DATEPART(year, HireDate) = '2004'
ORDER BY BirthDate DESC;