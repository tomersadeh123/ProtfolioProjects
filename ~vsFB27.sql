-- cleaning daa via SQl

select *
from protfolio_2.dbo.Sheet1$;

-- standrdize Date Fromat

select SaleDate,Convert(Date,SaleDate)
from protfolio_2.dbo.Sheet1$;

update Sheet1$
set SaleDate = Convert(Date,SaleDate);


select SaleDate
from protfolio_2.dbo.Sheet1$;




-- populate property Address data



select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from protfolio_2.dbo.Sheet1$ as a
join protfolio_2.dbo.Sheet1$ as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


update a
set propertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from protfolio_2.dbo.Sheet1$ as a
join protfolio_2.dbo.Sheet1$ as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;



-- breaking out address into indivdual columns (Address, City,State)

-- declare the column we want to change
DECLARE @Address VARCHAR(MAX)
SELECT @Address = PropertyAddress FROM protfolio_2.dbo.Sheet1$

--SELECT s.value AS SplitValue
--FROM protfolio_2.dbo.Sheet1$ AS t
--CROSS APPLY STRING_SPLIT(t.PropertyAddress, ',') AS s;



SELECT 
    LEFT(PropertyAddress, CHARINDEX(',', PropertyAddress) - 1) AS Address,
    LTRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))) AS City
FROM protfolio_2.dbo.Sheet1$;


-- updating the new columns 
UPDATE protfolio_2.dbo.Sheet1$
SET PropertyAddress = LEFT(PropertyAddress, CHARINDEX(',', PropertyAddress) - 1),
    City = LTRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)));


-- check the new result
select * 
from protfolio_2.dbo.Sheet1$;

-- new we will do the same for the owner address

SELECT 
    LEFT(OwnerAddress, CHARINDEX(',', OwnerAddress) - 1) AS Address,
    LTRIM(SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress) + 1, LEN(OwnerAddress))) AS City
FROM protfolio_2.dbo.Sheet1$;

-- create new column 
alter table protfolio_2.dbo.Sheet1$
add owner_city varchar(50);


-- updating the new column 
UPDATE protfolio_2.dbo.Sheet1$
SET PropertyAddress = LEFT(OwnerAddress, CHARINDEX(',', OwnerAddress) - 1),
    owner_city = LTRIM(SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress) + 1, LEN(OwnerAddress)));


-- check the result 

select * 
from protfolio_2.dbo.Sheet1$;



-- Change Y and N to yes and No in "Sold as Vacant"

select Distinct SoldAsVacant, count(SoldAsVacant)
from protfolio_2.dbo.Sheet1$
group by SoldAsVacant
order by 2;



SELECT
    CASE 
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END AS SoldAsVacant
FROM protfolio_2.dbo.Sheet1$;


select Distinct SoldAsVacant, count(SoldAsVacant)
from protfolio_2.dbo.Sheet1$
group by SoldAsVacant
order by 2;



