/*
Cleaning Data in SQL Queries
*/


Select *
From MyPortfolioProjects..BostonHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Update BostonHousing
SET SaleDate = CONVERT(Date,SaleDate)

Select saleDate, CONVERT(Date,SaleDate)
From MyPortfolioProjects..BostonHousing



-- If it doesn't Update properly

ALTER TABLE BostonHousing
Add SaleDateConverted Date;

Update BostonHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From MyPortfolioProjects..BostonHousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From MyPortfolioProjects..BostonHousing a
JOIN MyPortfolioProjects..BostonHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From MyPortfolioProjects..BostonHousing a
JOIN MyPortfolioProjects..BostonHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From MyPortfolioProjects..BostonHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From MyPortfolioProjects..BostonHousing


ALTER TABLE BostonHousing
Add PropertySplitAddress Nvarchar(255);

Update BostonHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE BostonHousing
Add PropertySplitCity Nvarchar(255);

Update BostonHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From MyPortfolioProjects..BostonHousing





Select OwnerAddress
From MyPortfolioProjects..BostonHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From MyPortfolioProjects..BostonHousing



ALTER TABLE BostonHousing
Add OwnerSplitAddress Nvarchar(255);

Update BostonHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE BostonHousing
Add OwnerSplitCity Nvarchar(255);

Update BostonHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE BostonHousing
Add OwnerSplitState Nvarchar(255);

Update BostonHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From MyPortfolioProjects..BostonHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From MyPortfolioProjects..BostonHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From MyPortfolioProjects..BostonHousing


Update BostonHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

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

From MyPortfolioProjects..BostonHousing
)

Delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From MyPortfolioProjects..BostonHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From MyPortfolioProjects..BostonHousing


ALTER TABLE MyPortfolioProjects..BostonHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
