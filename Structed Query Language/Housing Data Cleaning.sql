--Displaying all the data

Select *
from PortfolioProjects..Housing

Select SaleDate, CONVERT(Date,SaleDate) as SalesDateConverted
from PortfolioProjects..Housing

-- Try the update, if it doesnt work, perform alter table

--Update  housing
--SET SaleDate = CONVERT(Date,SaleDate)
--Select SaleDate
--from PortfolioProjects..Housing


-- adding a new column, set the value of the new column to the converted salesdate
ALTER TABLE Housing
ADD SalesDateConverted Date;

UPDATE Housing
SET SalesDateConverted = CONVERT(Date,SaleDate)

Select SalesDateConverted
from PortfolioProjects..Housing

-- we notice that there are null values in the property address and we need to try and figure out how to fix it
Select PropertyAddress
From PortfolioProjects..Housing
where PropertyAddress is null


-- we notice that the address is not populated when there are multiple IDs exp #305 #306
Select *
From PortfolioProjects..Housing
order by ParcelID

-- we will join the table with it self so we can compare if parcelid is same and unique id is not (condition to replace the null values_

Select a.ParcelId, a.PropertyAddress , b.ParcelId, b.PropertyAddress 
From  PortfolioProjects..Housing as a join  PortfolioProjects..Housing as b
on a.ParcelId = b.ParcelId and  a.UniqueID <> b.UniqueID
where  a.PropertyAddress is null


-- updating the values

Update a
Set propertyaddress = isnull(a.propertyaddress, b.propertyaddress)
From  PortfolioProjects..Housing as a join  PortfolioProjects..Housing as b
on a.ParcelId = b.ParcelId and  a.UniqueID <> b.UniqueID
where  a.PropertyAddress is null

--verify there is no more null
Select a.ParcelId, a.PropertyAddress , b.ParcelId, b.PropertyAddress 
From  PortfolioProjects..Housing as a join  PortfolioProjects..Housing as b
on a.ParcelId = b.ParcelId and  a.UniqueID <> b.UniqueID
where  a.PropertyAddress is null

Select PropertyAddress
From PortfolioProjects..Housing

--breaking out the address into individual columns

Select
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) as Address ,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PortfolioProjects..housing


ALTER TABLE Housing
ADD PropertySplitAddress nvarchar(255);

UPDATE Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1)


ALTER TABLE Housing
ADD PropertySplitCity nvarchar(255);

UPDATE Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

Select PropertySplitAddress, PropertySplitCity
From PortfolioProjects..Housing


-- fixing the ownerAddress

Select OwnerAddress
From PortfolioProjects..Housing

Select 
PARSENAME (REPLACE(OwnerAddress, ',', '.'), 3) ,
PARSENAME (REPLACE(OwnerAddress, ',', '.'), 2) ,
PARSENAME (REPLACE(OwnerAddress, ',', '.'), 1) 
from PortfolioProjects..Housing


ALTER TABLE Housing
ADD OwnerSplitAddress nvarchar(255);

UPDATE Housing
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Housing
ADD OwnerSplitCity nvarchar(255);

UPDATE Housing
SET OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Housing
ADD OwnerSplitState nvarchar(255);

UPDATE Housing
SET OwnerSplitState = PARSENAME (REPLACE(OwnerAddress, ',', '.'), 1)


select OwnerSplitAddress , OwnerSplitCity, OwnerSplitState
from PortfolioProjects..Housing


-- fixing Sold as Vacant 
Select Distinct(SoldAsVacant)
from PortfolioProjects..Housing

-- we can notice that we have both N and No, Y and Yes. 

Select Distinct(SoldAsVacant) , Count (SoldAsVacant)
from PortfolioProjects..Housing
Group by SoldAsVacant
order by 2

--since yes and no occurs more frequently we change values to them
Select SoldAsVacant , Case When SoldAsVacant = 'Y' then 'Yes' 
						   When SoldAsVacant = 'N' then 'No'
						   Else SoldAsVacant END
from PortfolioProjects..Housing

Update PortfolioProjects..Housing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes' 
						   When SoldAsVacant = 'N' then 'No'
						   Else SoldAsVacant END


-- creating CTE to delete some infomration (NOT RECOMMENDED) just for practice
						   
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProjects..Housing

)
DELETE --Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


-- delete columns we dont need
Select *
From PortfolioProjects..Housing

ALTER TABLE PortfolioProjects..Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate