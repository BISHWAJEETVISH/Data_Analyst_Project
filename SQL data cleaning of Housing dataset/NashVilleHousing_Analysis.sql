
----DATA CLEANING PROJECT IN SQL-------------

select *
from portfolio_project.dbo.NashvilleHousing

-------------- Standardize Date Format -------------------

select SaleConvertedDate,convert(date,SaleDate)
from portfolio_project.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,saledate)

ALTER table NashvilleHousing
ADD SaleConvertedDate Date;

UPDATE NashvilleHousing
SET SaleConvertedDate = CONVERT(Date,saledate)

-----------Populate_Property_AddressData-------------where address is NULL--------

select *
from portfolio_project.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)    --Isnull is used to fill the null values
from portfolio_project.dbo.NashvilleHousing a
JOIN portfolio_project.dbo.NashvilleHousing b ON
      a.ParcelID=b.ParcelID  and
	  a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null

Update a
SET a.PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress) 
from portfolio_project.dbo.NashvilleHousing a
JOIN portfolio_project.dbo.NashvilleHousing b ON
      a.ParcelID=b.ParcelID  and
	  a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-----------------------------Breaking out address into individual columns (Address, city, state) ----------------------------------------

select PropertyAddress
from portfolio_project.dbo.NashvilleHousing
order by ParcelID

select 
   SUBSTRING(propertyaddress,1,Charindex(',',PropertyAddress)-1) as address ,
   SUBSTRING(propertyaddress,Charindex(',',PropertyAddress)+1,Len(PropertyAddress)) as address
from portfolio_project.dbo.NashvilleHousing

--Changing in dataset by adding columns---

ALTER table portfolio_project.dbo.NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE portfolio_project.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(propertyaddress,1,Charindex(',',PropertyAddress)-1)

ALTER table portfolio_project.dbo.NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE portfolio_project.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(propertyaddress,Charindex(',',PropertyAddress)+1,Len(PropertyAddress))

select *
from portfolio_project.dbo.NashvilleHousing

--Cleaning owner address---

select OwnerAddress
from portfolio_project.dbo.NashvilleHousing

select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
       PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	   PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from portfolio_project.dbo.NashvilleHousing

ALTER table portfolio_project.dbo.NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE portfolio_project.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER table portfolio_project.dbo.NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE portfolio_project.dbo.NashvilleHousing
SET ownerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER table portfolio_project.dbo.NashvilleHousing
ADD OwnerSplitstate nvarchar(255);

UPDATE portfolio_project.dbo.NashvilleHousing
SET ownerSplitstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--After updating Checking the dataset again--

select *
from portfolio_project.dbo.NashvilleHousing

-------Change Y and N to yes and NO in vacant Field----------------

select SoldAsVacant
from portfolio_project.dbo.NashvilleHousing
where SoldAsVacant='Y' or SoldAsVacant='N'        --replace them with yes and no

select SoldAsVacant,
     CASE when SoldAsVacant='Y' then 'YES'
	      when SoldAsVacant='N' then 'NO'
		  ELSE SoldASVacant
		  End
from portfolio_project.dbo.NashvilleHousing

UPDATE portfolio_project.dbo.NashvilleHousing
SET SoldAsVacant =  CASE when SoldAsVacant='Y' then 'YES'
	      when SoldAsVacant='N' then 'NO'
		  ELSE SoldASVacant
		  End
from portfolio_project.dbo.NashvilleHousing

-----------------REMOVE DUPLICATES-------------------------------------------

With RownumCTE as(
SELECT *,
    ROW_NUMBER() over (
	    partition by ParcelId,
		             PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference
					 ORDER BY 
					   UniqueId ) row_num
from portfolio_project.dbo.NashvilleHousing
--order by parcelid
)

DELETE                   --it deletes all the duplicates
from RownumCTE
where row_num>1

----------------------------DELETE UNUSED COLUMNS----------------------------------

SELECT *
from portfolio_project.dbo.NashvilleHousing

ALTER TABLE portfolio_project.dbo.NashvilleHousing
DROP COLUMN Owneraddress,taxdistrict,Propertyaddress
