/* ============================================================
   Carga de Datos desde Archivos JSON (Dimensiones y Hechos)
   ============================================================ */
USE BDNike;
GO

/* ------------------------------------------------------------
   1) DimCategory
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Categorias.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimCategory (id_Category, Category)
SELECT id_Category, CATEGORY
FROM OPENJSON(@json)
WITH (
    CATEGORY NVARCHAR(100) '$.CATEGORY',
    id_Category INT '$.id_Category'
);
GO

/* ------------------------------------------------------------
   2) DimSubCategory
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Sub_Categoría.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimSubCategory (id_SubCategory, SubCategory)
SELECT id_SubCategory, SUBCATEGORY
FROM OPENJSON(@json)
WITH (
    SUBCATEGORY NVARCHAR(150) '$.SUBCATEGORY',
    id_SubCategory INT '$.id_SubCategory'
);
GO

/* ------------------------------------------------------------
   3) DimProductType
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Tipo_Producto.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimProductType (id_PRODUCT_TYPE, ProductType)
SELECT id_PRODUCT_TYPE, PRODUCT_TYPE
FROM OPENJSON(@json)
WITH (
    PRODUCT_TYPE NVARCHAR(50) '$.PRODUCT_TYPE',
    id_PRODUCT_TYPE INT '$.id_PRODUCT_TYPE'
);
GO

/* ------------------------------------------------------------
   4) DimBrand
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Marca.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimBrand (id_BRAND, Brand)
SELECT id_BRAND, BRAND
FROM OPENJSON(@json)
WITH (
    BRAND NVARCHAR(80) '$.BRAND',
    id_BRAND INT '$.id_BRAND'
);
GO

/* ------------------------------------------------------------
   5) DimDepartment
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Departamentos.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimDepartment (id_DEPARTMENT, Department)
SELECT
    id_DEPARTMENT,
    ISNULL(Department, 'Sin dato') AS Department
FROM OPENJSON(@json)
WITH (
    Department NVARCHAR(50) '$.Department',
    id_DEPARTMENT INT '$.id_DEPARTMENT'
);
GO

/* ------------------------------------------------------------
   6) DimAvailability
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Disponibilidad.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimAvailability (id_AVAILABILITY, Availability)
SELECT id_AVAILABILITY, AVAILABILITY
FROM OPENJSON(@json)
WITH (
    AVAILABILITY NVARCHAR(30) '$.AVAILABILITY',
    id_AVAILABILITY INT '$.id_AVAILABILITY'
);
GO

/* ------------------------------------------------------------
   7) DimColor
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Color.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimColor (id_COLOR, Color)
SELECT id_COLOR, COLOR
FROM OPENJSON(@json)
WITH (
    COLOR NVARCHAR(300) '$.COLOR',
    id_COLOR INT '$.id_COLOR'
);
GO

/* ------------------------------------------------------------
   8) DimDescription
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Descripcion.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimDescription (id_DESCRIPTION, [Description])
SELECT id_DESCRIPTION, [DESCRIPTION]
FROM OPENJSON(@json)
WITH (
    [DESCRIPTION] NVARCHAR(250) '$.DESCRIPTION',
    id_DESCRIPTION INT '$.id_DESCRIPTION'
);
GO

/* ------------------------------------------------------------
   9) DimProductName
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Nombre_Producto.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimProductName (id_PRODUCT_NAME, ProductName)
SELECT id_PRODUCT_NAME, PRODUCT_NAME
FROM OPENJSON(@json)
WITH (
    PRODUCT_NAME NVARCHAR(255) '$.PRODUCT_NAME',
    id_PRODUCT_NAME INT '$.id_PRODUCT_NAME'
);
GO

/* ------------------------------------------------------------
   10) DimRegion
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Región.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimRegion (id_Region, Region)
SELECT id_Region, Region
FROM OPENJSON(@json)
WITH (
    Region NVARCHAR(50) '$.Region',
    id_Region INT '$.id_Region'
);
GO

/* ------------------------------------------------------------
   11) DimState
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Estado.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimState (id_State, [State])
SELECT id_State, [State]
FROM OPENJSON(@json)
WITH (
    [State] NVARCHAR(80) '$.State',
    id_State INT '$.id_State'
);
GO

/* ------------------------------------------------------------
   12) DimCity
   ------------------------------------------------------------ */
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\Ciudad.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.DimCity (id_City, City)
SELECT id_City, City
FROM OPENJSON(@json)
WITH (
    City NVARCHAR(120) '$.City',
    id_City INT '$.id_City'
);
GO

/* ------------------------------------------------------------
   13) FactNikeSales
   ------------------------------------------------------------ */
DECLARE @jsonFact NVARCHAR(MAX);

SELECT @jsonFact = BulkColumn
FROM OPENROWSET(
    BULK 'camino a su carpeta\ventas_nike.json',
    SINGLE_CLOB
) AS j;

INSERT INTO dbo.FactNikeSales (
    InvoiceDate,
    id_Region, id_State, id_City,
    id_DEPARTMENT, id_Category, id_SubCategory,
    id_PRODUCT_NAME, id_DESCRIPTION, id_PRODUCT_TYPE,
    id_COLOR, id_BRAND, id_AVAILABILITY,
    PRODUCT_SIZE,
    PricePerUnit, UnitsSold, CostoUnitario, OperatingMargin
)
SELECT
    TRY_CONVERT(DATE, InvoiceDate, 101),
    id_Region, id_State, id_City,
    id_Department, id_Category, id_SubCategory,
    id_PRODUCT_NAME, id_DESCRIPTION, id_PRODUCT_TYPE,
    id_Color, id_BRAND, id_AVAILABILITY,
    PRODUCT_SIZE,
    TRY_CONVERT(DECIMAL(12,2), REPLACE(PricePerUnit, ',', '.')),
    UnitsSold,
    TRY_CONVERT(DECIMAL(12,2), REPLACE(CostoUnitario, ',', '.')),
    TRY_CONVERT(DECIMAL(6,3),  REPLACE(OperatingMargin, ',', '.'))
FROM OPENJSON(@jsonFact)
WITH (
    InvoiceDate NVARCHAR(30) '$."INVOICE DATE"',
    id_Region INT '$.id_Region',
    id_State INT '$.id_State',
    id_City INT '$.id_City',
    id_Department INT '$.id_Department',
    id_Category INT '$.id_Category',
    id_SubCategory INT '$.id_SubCategory',
    id_PRODUCT_NAME INT '$.id_PRODUCT_NAME',
    id_DESCRIPTION INT '$.id_DESCRIPTION',
    id_PRODUCT_TYPE INT '$.id_PRODUCT_TYPE',
    id_Color INT '$.id_Color',
    id_BRAND INT '$.id_BRAND',
    id_AVAILABILITY INT '$.id_AVAILABILITY',
    PRODUCT_SIZE NVARCHAR(40) '$.PRODUCT_SIZE',
    PricePerUnit NVARCHAR(40) '$."Price per Unit"',
    UnitsSold INT '$."Units Sold"',
    CostoUnitario NVARCHAR(40) '$."Costo Unitario"',
    OperatingMargin NVARCHAR(40) '$."Operating Margin"'
)
WHERE TRY_CONVERT(DATE, InvoiceDate, 101) IS NOT NULL;
GO

/* ============================================================
   14) Verificar Carga
   ============================================================ */
-- Conteo de filas
SELECT COUNT(*) AS FilasFact 
FROM dbo.FactNikeSales;

-- Primeros registros
SELECT TOP 10 * 
FROM dbo.FactNikeSales 
ORDER BY SaleID DESC;
GO
