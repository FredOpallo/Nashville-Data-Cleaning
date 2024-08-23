SELECT * FROM NashvileHousing

-- STANDARDISE DATE FORMAT

SELECT SaleDateConverted,CONVERT(Date,SaleDate) FROM NashvileHousing

UPDATE NashvileHousing
SET SaleDate =CONVERT(Date,SaleDate)

ALTER TABLE NashvileHousing ADD SaleDateConverted Date

UPDATE NashvileHousing
SET SaleDateConverted =CONVERT(Date,SaleDate)

-- Populate Property Address date

SELECT PropertyAddress FROM NashvileHousing
--WHERE PropertyAddress is null


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvileHousing a
INNER JOIN NashvileHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM  NashvileHousing a
INNER JOIN NashvileHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

--- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS(Address,City,State)


SELECT PropertyAddress FROM NashvileHousing
--WHERE PropertyAddress is null

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress)) AS Address
FROM NashvileHousing


ALTER TABLE NashvileHousing ADD PropertySplitAddress nvarchar(255)

UPDATE NashvileHousing
SET PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)


ALTER TABLE NashvileHousing ADD PropertySplitCity nvarchar(255)

UPDATE NashvileHousing
SET PropertySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress))

SELECT * FROM NashvileHousing



SELECT OwnerAddress FROM NashvileHousing



SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NashvileHousing



ALTER TABLE NashvileHousing ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvileHousing
SET  OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvileHousing ADD OwnerSplitCity nvarchar(255)

UPDATE NashvileHousing
SET OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE NashvileHousing ADD OwnerSplitState nvarchar(255)

UPDATE NashvileHousing
SET OwnerSplitState =PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
from NashvileHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE
   WHEN SoldAsVacant ='N' THEN 'No'
   WHEN SoldAsVacant= 'Y' THEN 'Yes'
ELSE SoldAsVacant
END
from NashvileHousing

UPDATE NashvileHousing
SET SoldAsVacant = CASE
   WHEN SoldAsVacant ='N' THEN 'No'
   WHEN SoldAsVacant= 'Y' THEN 'Yes'
ELSE SoldAsVacant
END

SELECT * FROM NashvileHousing

-- REMOVE DUPLICATES
WITH RowNumCTE AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY ParcelID,
							PropertyAddress,
							SalePrice,
							SaleDate,
							LegalReference
							ORDER BY 
							   UniqueID) Row_num
 FROM NashvileHousing
 --ORDER BY ParcelID
 )
 SELECT * FROM RowNumCTE
 WHERE Row_num > 1
ORDER BY PropertyAddress
 
 -- DELETE UNUSED COLUMNS

 SELECT * FROM NashvileHousing

 ALTER TABLE NashvileHousing
 DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

 
 ALTER TABLE NashvileHousing
 DROP COLUMN SaleDate
