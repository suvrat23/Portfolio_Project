/*

 Cleaning the data

*/

Select * 
From Project_Portfolio..NashvilleHousing

-- Standardize Date Format
Select SaleDateConverted, CONVERT(Date, SaleDate)
From Project_Portfolio..NashvilleHousing

Alter Table Project_Portfolio..NashvilleHousing
Add SaleDateConverted Date;

Update Project_Portfolio..NashvilleHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)

-- Populate Property Address data

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
From Project_Portfolio..NashvilleHousing a
Join Project_Portfolio..NashvilleHousing b 
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress  is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
From Project_Portfolio..NashvilleHousing a
Join Project_Portfolio..NashvilleHousing b 
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress  is null

-- Breaking out Adress into Individual Columns(Adress, City, State)

Select PropertyAddress
From Project_Portfolio..NashvilleHousing

Select SUBSTRING(PropertyAddress, 1, CharIndex(',',PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CharIndex(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
From Project_Portfolio..NashvilleHousing

Alter Table Project_Portfolio..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update Project_Portfolio..NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CharIndex(',',PropertyAddress) -1)

Alter Table Project_Portfolio..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update Project_Portfolio..NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CharIndex(',',PropertyAddress) +1, LEN(PropertyAddress))

Select * 
From Project_Portfolio..NashvilleHousing



Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From Project_Portfolio..NashvilleHousing
Where OwnerAddress is not null


Alter Table Project_Portfolio..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update Project_Portfolio..NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

Alter Table Project_Portfolio..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update Project_Portfolio..NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

Alter Table Project_Portfolio..NashvilleHousing
Add OnwerSplitState Nvarchar(255);

Update Project_Portfolio..NashvilleHousing
Set OnwerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


Select * 
From Project_Portfolio..NashvilleHousing
Where OwnerAddress is not null


-- Change Y and N to Yes and No in "SoldAsVacant" field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From Project_Portfolio..NashvilleHousing
Group By SoldAsVacant
Order By 2

Select SoldAsVacant, 
Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 END
From Project_Portfolio..NashvilleHousing


Update Project_Portfolio..NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 END


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

From Project_Portfolio.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Project_Portfolio.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From Project_Portfolio.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
