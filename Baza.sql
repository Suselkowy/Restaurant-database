-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-01-16 14:51:07.476

-- tables
-- Table: Category
CREATE TABLE Category (
    CategoryID int  NOT NULL IDENTITY,
    CategoryName varchar(255)  NOT NULL,
    CONSTRAINT Category_pk PRIMARY KEY  (CategoryID)
);

-- Table: Clients
CREATE TABLE Clients (
    Client_ID int  NOT NULL IDENTITY,
    ClientName varchar(255)  NOT NULL,
    CONSTRAINT Clients_pk PRIMARY KEY  (Client_ID)
);

-- Table: Companies
CREATE TABLE Companies (
    Client_ID int  NOT NULL,
    ContactName varchar(255)  NOT NULL,
    NIP varchar(10)  NOT NULL,
    Address varchar(255)  NOT NULL,
    City varchar(255)  NOT NULL,
    Region varchar(255)  NOT NULL,
    PostalCode varchar(255)  NOT NULL,
    Phone varchar(20)  NOT NULL,
    Email varchar(255)  NOT NULL,
    Country varchar(255)  NOT NULL,
    CONSTRAINT NIPUnique UNIQUE (NIP),
    CONSTRAINT PhoneValid CHECK (((Phone LIKE '+[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR Phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') AND Country = 'Poland') OR Country != 'Poland'  ),
    CONSTRAINT NIPValid CHECK ((NIP LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND Country = 'Poland') OR Country != 'Poland' ),
    CONSTRAINT EmailValid CHECK (Email LIKE '%@%.%'),
    CONSTRAINT PostalCodeValid CHECK ( (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]'  AND Country = 'Poland') OR Country != 'Poland' ),
    CONSTRAINT Companies_pk PRIMARY KEY  (Client_ID)
);

-- Table: Discount
CREATE TABLE Discount (
    DiscountID int  NOT NULL IDENTITY,
    StartDate date  NOT NULL,
    EndDate date  NULL,
    DiscountAmount decimal(15,2)  NOT NULL,
    Client_ID int  NOT NULL,
    Used bit  NOT NULL,
    CONSTRAINT DateValid CHECK (ISNULL(EndDate,'9999-12-31 23:59:59') > StartDate),
    CONSTRAINT Discount_pk PRIMARY KEY  (DiscountID)
);

-- Table: Employees
CREATE TABLE Employees (
    EmployeeID int  NOT NULL IDENTITY,
    Name varchar(255)  NOT NULL,
    Phone varchar(20)  NOT NULL,
    Email varchar(255)  NOT NULL,
    Country varchar(255)  NOT NULL,
    CONSTRAINT EmployeeEmailValid CHECK (Email LIKE '%@%.%'),
    CONSTRAINT EmployeePhoneValid CHECK (((Phone LIKE '+[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR Phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') AND Country = 'Poland') OR Country != 'Poland' ),
    CONSTRAINT Employees_pk PRIMARY KEY  (EmployeeID)
);

-- Table: IndividualClient
CREATE TABLE IndividualClient (
    Client_ID int  NOT NULL,
    Phone varchar(20)  NOT NULL,
    Email varchar(255)  NOT NULL,
    Country varchar(255)  NOT NULL,
    CONSTRAINT UniqueEmail UNIQUE (Email),
    CONSTRAINT IndividualClientPhoneValid CHECK (((Phone LIKE '+[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR Phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') AND Country = 'Poland') OR Country != 'Poland'  ),
    CONSTRAINT IndividualClientEmailValid CHECK (Email LIKE '%@%.%'),
    CONSTRAINT IndividualClient_pk PRIMARY KEY  (Client_ID)
);

-- Table: Menu
CREATE TABLE Menu (
    MenuID int  NOT NULL IDENTITY,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    CONSTRAINT ValidDate CHECK (EndDate >= StartDate),
    CONSTRAINT Menu_pk PRIMARY KEY  (MenuID)
);

-- Table: MenuDetails
CREATE TABLE MenuDetails (
    ProductID int  NOT NULL,
    MenuID int  NOT NULL,
    Cost money  NOT NULL,
    CONSTRAINT CostValid CHECK ((Cost >= 0)),
    CONSTRAINT MenuDetails_pk PRIMARY KEY  (ProductID,MenuID)
);

-- Table: OpeningHours
CREATE TABLE OpeningHours (
    OpeningHoursID int  NOT NULL IDENTITY,
    StartDate date  NOT NULL,
    EndDate date  NULL,
    CONSTRAINT OpeningHoursDateValid CHECK (ISNULL(EndDate,'9999-12-31 23:59:59') > StartDate),
    CONSTRAINT OpeningHours_pk PRIMARY KEY  (OpeningHoursID)
);

-- Table: OpeningHoursDetails
CREATE TABLE OpeningHoursDetails (
    OpeningHoursDetailsID int  NOT NULL,
    OpeningHoursID int  NOT NULL,
    Day int  NOT NULL,
    StartHour time(0)  NOT NULL,
    EndHour time(0)  NOT NULL,
    CONSTRAINT DayValid CHECK (Day >= 1 AND Day <= 7),
    CONSTRAINT OpeningHoursDetails_pk PRIMARY KEY  (OpeningHoursDetailsID)
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
    ProductID int  NOT NULL,
    OrderID int  NOT NULL,
    Quantity int  NOT NULL,
    ToGo bit  NOT NULL,
    CONSTRAINT ValidQuantity CHECK (Quantity > 0),
    CONSTRAINT OrderDetails_pk PRIMARY KEY  (ProductID,OrderID)
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID int  NOT NULL IDENTITY,
    OrderDate date  NOT NULL,
    Client_ID int  NOT NULL,
    PickupID int  NULL,
    Paid bit  NOT NULL,
    ReservationID int  NULL,
    DiscountID int  NULL,
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);

-- Table: Pickup
CREATE TABLE Pickup (
    PickupID int  NOT NULL IDENTITY,
    PickupDate datetime  NOT NULL,
    Picked bit  NOT NULL,
    CONSTRAINT PickupDateValid CHECK (PickupDate > GETDATE()),
    CONSTRAINT Pickup_pk PRIMARY KEY  (PickupID)
);

-- Table: Product
CREATE TABLE Product (
    ProductID int  NOT NULL IDENTITY,
    CategoryID int  NOT NULL,
    ProductName varchar(255)  NOT NULL,
    Description varchar(255)  NOT NULL,
    CONSTRAINT Product_pk PRIMARY KEY  (ProductID)
);

-- Table: Reservation
CREATE TABLE Reservation (
    ReservationID int  NOT NULL IDENTITY,
    ReservationStartDate datetime  NOT NULL,
    ReservationEndDate datetime  NOT NULL,
    ReservationGuestNumber int  NOT NULL,
    EmployeeID int  NULL,
    CONSTRAINT ReservationDateValid CHECK (ReservationEndDate > ReservationStartDate ),
    CONSTRAINT ReservationGuestNumberValid CHECK (ReservationGuestNumber >= 2),
    CONSTRAINT ReservationStartDateAfterNow CHECK (ReservationStartDate >= GETDATE()),
    CONSTRAINT Reservation_pk PRIMARY KEY  (ReservationID)
);

-- Table: ReservationDetails
CREATE TABLE ReservationDetails (
    ReservationDetailsID int  NOT NULL IDENTITY,
    ReservationID int  NOT NULL,
    TableID int  NOT NULL,
    ReservationName varchar(255)  NOT NULL,
    CONSTRAINT ReservationDetails_pk PRIMARY KEY  (ReservationDetailsID)
);

-- Table: Table
CREATE TABLE "Table" (
    TableID int  NOT NULL IDENTITY,
    ChairsNumber int  NOT NULL,
    CONSTRAINT ChairsNumberValid CHECK ((ChairsNumber >= 2) and (ChairsNumber <= 12) ),
    CONSTRAINT TableID PRIMARY KEY  (TableID)
);

-- Table: Variables
CREATE TABLE Variables (
    WK int  NOT NULL,
    WZ int  NOT NULL,
    Z1 int  NOT NULL,
    K1 decimal(15,2)  NOT NULL,
    D1 Int  NOT NULL,
    R1 decimal(15,2)  NOT NULL,
    R2 decimal(15,2)  NOT NULL,
    StartDate date  NOT NULL,
    K2 decimal(15,2)  NOT NULL,
    VariablesID int  NOT NULL IDENTITY,
    CONSTRAINT ValuesValid CHECK ((WK > 0 AND WZ > 0 AND Z1 > 0 AND K1 > 0 AND D1 > 0 AND R1 > 0 AND R1 <= 1 AND R2>0 AND R2 <=1)),
    CONSTRAINT Variables_pk PRIMARY KEY  (VariablesID)
);

-- foreign keys
-- Reference: Companies_Clients (table: Companies)
ALTER TABLE Companies ADD CONSTRAINT Companies_Clients
    FOREIGN KEY (Client_ID)
    REFERENCES Clients (Client_ID);

-- Reference: IndividualCient_Clients (table: IndividualClient)
ALTER TABLE IndividualClient ADD CONSTRAINT IndividualCient_Clients
    FOREIGN KEY (Client_ID)
    REFERENCES Clients (Client_ID);

-- Reference: IndividualClient_Discount (table: Discount)
ALTER TABLE Discount ADD CONSTRAINT IndividualClient_Discount
    FOREIGN KEY (Client_ID)
    REFERENCES IndividualClient (Client_ID);

-- Reference: MenuDetails_Menu (table: MenuDetails)
ALTER TABLE MenuDetails ADD CONSTRAINT MenuDetails_Menu
    FOREIGN KEY (MenuID)
    REFERENCES Menu (MenuID);

-- Reference: MenuDetails_Product (table: MenuDetails)
ALTER TABLE MenuDetails ADD CONSTRAINT MenuDetails_Product
    FOREIGN KEY (ProductID)
    REFERENCES Product (ProductID);

-- Reference: OpeningHoursDetails_OpeningHours (table: OpeningHoursDetails)
ALTER TABLE OpeningHoursDetails ADD CONSTRAINT OpeningHoursDetails_OpeningHours
    FOREIGN KEY (OpeningHoursID)
    REFERENCES OpeningHours (OpeningHoursID);

-- Reference: OrderDetails_Orders (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID)
    ON DELETE  CASCADE;

-- Reference: OrderDetails_Product (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Product
    FOREIGN KEY (ProductID)
    REFERENCES Product (ProductID);

-- Reference: Orders_Clients (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Clients
    FOREIGN KEY (Client_ID)
    REFERENCES Clients (Client_ID);

-- Reference: Orders_Discount (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Discount
    FOREIGN KEY (DiscountID)
    REFERENCES Discount (DiscountID);

-- Reference: Orders_OrderPickup (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_OrderPickup
    FOREIGN KEY (PickupID)
    REFERENCES Pickup (PickupID);

-- Reference: Orders_Reservation (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Reservation
    FOREIGN KEY (ReservationID)
    REFERENCES Reservation (ReservationID);

-- Reference: Product_Category (table: Product)
ALTER TABLE Product ADD CONSTRAINT Product_Category
    FOREIGN KEY (CategoryID)
    REFERENCES Category (CategoryID);

-- Reference: ReservationDetails_Reservation (table: ReservationDetails)
ALTER TABLE ReservationDetails ADD CONSTRAINT ReservationDetails_Reservation
    FOREIGN KEY (ReservationID)
    REFERENCES Reservation (ReservationID)
    ON DELETE  CASCADE;

-- Reference: ReservationDetails_Table (table: ReservationDetails)
ALTER TABLE ReservationDetails ADD CONSTRAINT ReservationDetails_Table
    FOREIGN KEY (TableID)
    REFERENCES "Table" (TableID);

-- Reference: Reservation_Employees (table: Reservation)
ALTER TABLE Reservation ADD CONSTRAINT Reservation_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees (EmployeeID);

Create view CurrentMenu as
Select P.ProductName, M.Cost, C.CategoryName, P.Description, MenuID 
from MenuDetails M inner join Product P on M.ProductID = P.ProductID 
inner join Category C on P.CategoryID = C.CategoryID 
where M.MenuID in (select MenuID from Menu where CAST( GETDATE() AS Date ) >= StartDate AND CAST( GETDATE() AS Date ) <= EndDate)

Create view MealsCatalog as
Select P.ProductName, P.Description, C.CategoryName from Product as P 
inner join Category C on C.CategoryID = P.CategoryID

Create view ShowDiscounts as
Select WZ as orderValue, WK orderAmount, Z1 as nbOrOrders1, K1 as amount1, R1 as discount1, K2 as amount2, R2 as discount2, D1 as days from Variables

Create view IndividualClientInfo as
select C.Client_ID, C.ClientName, IC.Phone, IC.Email, IC.Country, count(O.OrderID) as ilosc_zamowien from Clients as C
	inner join Orders as O on C.Client_ID = O.Client_ID inner join IndividualClient IC on C.Client_ID = IC.Client_ID
	Group by C.Client_ID, C.ClientName, IC.Phone, IC.Email, IC.Country

Create view UnconfirmedReservation as
Select * from Reservation where EmployeeID is null;

Create view TodayReservations as
Select ReservationStartDate, ReservationEndDate, ReservationGuestNumber from Reservation where EmployeeID is not null and convert(date, ReservationStart) = convert(date, getdate());

Create view OrdersToPay as
Select OrderID, Client_ID from Orders where paid = 0

Create view PendingPickup as
Select O.OrderID, P.PickupID from Pickup as P 
inner join Orders as O on O.PickupID = P.PickupID where O.Paid = 1 and Convert(date, PickupDate) = Convert(date, GETDATE());

Create view ProductsSold as
Select ProductID, Sum(Quantity) as ilość from OrderDetails group by ProductID

Create view ProductsSoldDaily as
Select OD.ProductID, Sum(OD.Quantity) as quantity, day(O.OrderDate) as day, month(O.OrderDate) as month, year(O.OrderDate) as year  from OrderDetails OD inner join Orders O on OD.OrderID = O.OrderID group by OD.ProductID, day(O.OrderDate), month(O.OrderDate), year(O.OrderDate)

Create view ProductsSoldMonthly as
Select OD.ProductID, Sum(OD.Quantity) as quantity, month(O.OrderDate) as month, year(O.OrderDate) as year  from OrderDetails OD inner join Orders O on OD.OrderID = O.OrderID group by OD.ProductID, month(O.OrderDate), year(O.OrderDate)

Create view ProductsSoldAnnually as
Select OD.ProductID, Sum(OD.Quantity) as quantity,  year(O.OrderDate) as year from OrderDetails OD inner join Orders O on OD.OrderID = O.OrderID group by OD.ProductID, year(O.OrderDate)

Create view AnnuallIncome as
Select Sum(sale) as Income, year from
(Select Sum(IIF(O.DiscountID is not null,
(OD.Quantity * MD.cost * (1 - D.DiscountAmount)), (OD.Quantity * MD.cost))) as sale,year(O.OrderDate) as year from OrderDetails OD
inner join Orders O on OD.OrderID = O.OrderID
inner join Product P on OD. ProductID = P.ProductID
inner join MenuDetails MD on P.ProductID = MD.ProductID
left join Discount D on D.DiscountID = O.DiscountID
group by OD.Quantity, MD.Cost, year(O.OrderDate)) as sy
group by year;

Create view OrdersInfo as
SELECT OrderID,
(SELECT Sum(IIF(O.DiscountID is not null, (OD2.Quantity * MD.Cost * (1 - DiscountAmount)), (OD2.Quantity * MD.Cost))) value FROM OrderDetails OD2
inner join Orders O on O.OrderID = OD2.OrderID
INNER JOIN Product P on OD2.ProductID = P.ProductID
INNER JOIN MenuDetails MD on P.ProductID = MD.ProductID
INNER JOIN Menu M on M.MenuID = MD.MenuID
LEFT JOIN Discount D on O.DiscountID = D.DiscountID
 where O.OrderID = Orders.OrderID group by O.OrderID) value,
Client_ID, OrderDate, Paid FROM Orders;

Create view DiscountsInfo as
select ClientName, DiscountAmount, StartDate, EndDate from Discount 
inner join IndividualClient IC on IC.Client_ID = Discount.Client_ID 
inner join Clients C on C.Client_ID = IC.Client_ID where Used = 0

Create view CurrentVariables as
Select top 1 * from variables order by StartDate desc

Create view WeeklyTableReservations as
	select Sum(ChairsNumber) as chairs, COUNT(*) as tables, DATEPART(week, ReservationStartDate) as nbOfWeek, year(ReservationStartDate) as year from Reservation
    	inner join ReservationDetails RD on Reservation.ReservationID = RD.ReservationID
    	inner join [Table] on RD.TableID = [Table].TableID
    	group by DATEPART(week, ReservationStartDate), year(ReservationStartDate)

Create view MonthlyTableReservations as
	select Sum(ChairsNumber) as chairs, month(ReservationStartDate) as month, year(ReservationStartDate) as year from Reservation
    	inner join ReservationDetails RD on Reservation.ReservationID = RD.ReservationID
    	inner join [Table] on RD.TableID = [Table].TableID
    	group by  month(ReservationStartDate), year(ReservationStartDate)

CREATE PROCEDURE uspAddCategory
@CategoryName varchar(255)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
       IF EXISTS( SELECT * FROM Category WHERE @CategoryName = CategoryName)
       BEGIN ;
           THROW 52000, N'Kategoria jest już dodana', 1
       end
       INSERT INTO Category(CategoryName) VALUES(@CategoryName);
   END TRY
   BEGIN CATCH
       DECLARE @msg nvarchar(2048) = N'Błąd dodawania kategorii: ' + ERROR_MESSAGE(); THROW 52000, @msg, 1;
   END CATCH
END
go

CREATE PROCEDURE uspAddProduct
@Name varchar(255),
@Description varchar(255),
@CategoryName varchar(255) AS
BEGIN
  SET NOCOUNT ON
  BEGIN TRY
      IF EXISTS( SELECT * FROM Product WHERE ProductName = @Name )
          BEGIN
              THROW 52000, N'Potrawa jest już dodana', 1
          END
      IF NOT EXISTS( SELECT * FROM Category WHERE CategoryName = @CategoryName )
          BEGIN
              THROW 52000, 'Nie ma takiej kategorii', 1
          END
      DECLARE @CategoryID int
      Set @CategoryID = (select CategoryID from Category where CategoryName = @CategoryName)
      INSERT INTO Product(ProductName, CategoryID, Description) VALUES (@Name, @CategoryID, @Description);
  END TRY
  BEGIN CATCH
      DECLARE @msg nvarchar(2048) =N'Błąd dodania potrawy: ' + ERROR_MESSAGE();
      THROW 52000, @msg, 1;
  END CATCH
END

CREATE PROCEDURE uspAddProductToMenuById
@Name varchar(255),
@Cost money,
@MenuID int AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
       IF NOT EXISTS( SELECT * FROM Product WHERE ProductName = @Name )
           BEGIN
               THROW 52000, 'Nie ma takiej potrawy', 1
           END
       IF NOT EXISTS( SELECT * FROM Menu WHERE MenuID = @MenuID )
           BEGIN
               THROW 52000, 'Nie ma takiego menu', 1
           END
       DECLARE @ProductID INT SELECT @ProductID = ProductID FROM Product WHERE ProductName = @Name
       INSERT INTO MenuDetails(ProductID , MenuID, Cost)
       VALUES (@ProductID, @MenuID, @Cost);
   END TRY
   BEGIN CATCH
       DECLARE @msg nvarchar(2048) =N'Błąd dodania potrawy do menu: ' + ERROR_MESSAGE();
       THROW 52000, @msg, 1;
   END CATCH
END

CREATE PROCEDURE uspAddProductToMenuByDate
@Name varchar(255),
@Date Date,
@Cost money AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
       IF NOT EXISTS( SELECT * FROM Product WHERE ProductName = @Name )
           BEGIN
               THROW 52000, 'Nie ma takiej potrawy', 1
           END
       DECLARE @ProductID INT;
       SELECT @ProductID = ProductID FROM Product WHERE ProductName = @Name
       DECLARE @MenuID INT
       SELECT @MenuID = MenuID FROM Menu WHERE StartDate >= @Date and EndDate <= @Date;
       INSERT INTO MenuDetails(ProductID , MenuID, Cost)
       VALUES (@ProductID, @MenuID, @Cost);
   END TRY
   BEGIN CATCH
       DECLARE @msg nvarchar(2048) =N'Błąd dodania potrawy do menu: ' + ERROR_MESSAGE();
       THROW 52000, @msg, 1;
   END CATCH
END

CREATE PROCEDURE uspAddOrder @ClientID int,
@Paid bit,
@PickupDate datetime,
@StartDate datetime,
@EndDate datetime,
@ReservationGuestNumber int AS
BEGIN
  SET NOCOUNT ON
  BEGIN TRY
      IF ISNULL(@PickupDate,'9999-01-01') < GETDATE()
          BEGIN
              THROW 52000, N'Niepoprawna data odbioru zamówienia na wynos', 1
          END
      IF @PickupDate is not null
          BEGIN
           IF not exists(select StartHour, EndHour from OpeningHoursDetails
             where OpeningHoursID =
                   (select top 1 OpeningHoursID
                   from OpeningHours
                   where @PickupDate BETWEEN StartDate and ISNULL(EndDate, '9999-12-31 23:59:59'))
             and Day = datepart(weekday, CONVERT(VARCHAR(8), @PickupDate, 108))
             and CONVERT(VARCHAR(8), @PickupDate, 108) between StartHour and EndHour)
             BEGIN
               THROW 52000, N'Niepoprawna data odbioru zamówienia na wynos', 1
             end
          end
      IF ISNULL(@EndDate,'9999-01-01') < GETDATE() OR ISNULL(@StartDate,'9999-01-01') < GETDATE()
          BEGIN
              THROW 52000, N'Niepoprawna data rezerwacji', 1
          END
      IF @EndDate is not null
          BEGIN
           if exists(select * from IndividualClient where Client_ID = @ClientID) and ((select Count(*) from OrdersInfo where Client_ID = @ClientID) < (select wk from CurrentVariables))
               begin
                   THROW 52000, N'Klient ma za mało zamówień aby móc wykonać rezerwacje', 1
               end
           IF not exists(select StartHour, EndHour from OpeningHoursDetails
             where OpeningHoursID =
                   (select top 1 OpeningHoursID
                   from OpeningHours
                   where @StartDate BETWEEN StartDate and ISNULL(EndDate, '9999-12-31 23:59:59'))
             and Day = datepart(weekday, CONVERT(VARCHAR(8), @StartDate, 108))
             and CONVERT(VARCHAR(8), @StartDate, 108) between StartHour and EndHour
             and CONVERT(VARCHAR(8), @EndDate, 108) between StartHour and EndHour)
             BEGIN
               THROW 52000, N'Niepoprawna data rezerwacji', 1
             end
          end
      Declare @ReservationIDIns INT = null
      Declare @PickupIDIns INT = null
      Declare @Discount Decimal(15,2) = null

      DECLARE @CurrentMenuID int
      SELECT TOP 1 @CurrentMenuId = MenuID FROM Menu M WHERE GETDATE() BETWEEN M.StartDate AND M.EndDate
      IF (@PickupDate is not null)
          BEGIN
              INSERT INTO Pickup(PickupDate, Picked) VALUES (@PickupDate, 0)
              SET @PickupIDIns = SCOPE_IDENTITY();
          END
      IF (@StartDate is not null)
          BEGIN
              EXEC uspAddReservation @StartDate, @EndDate, @ReservationGuestNumber
               SET @ReservationIDIns = IDENT_CURRENT('Reservation')
          END
      IF EXISTS(SELECT * FROM IndividualClient WHERE Client_ID =  @ClientID )
           BEGIN
               SET @Discount = [dbo].udfGetBestDiscount(@ClientID)
           END
      INSERT INTO Orders(OrderDate, Client_ID, PickupID, Paid, ReservationID, DiscountID)
      VALUES (GETDATE(),  @ClientID, @PickupIDIns, @Paid, @ReservationIDIns, @Discount)
  END TRY
  BEGIN CATCH
      DECLARE @msg nvarchar(2048) =N'Błąd dodawania zamówienia: ' + ERROR_MESSAGE();
      THROW 52000, @msg, 1
  END CATCH
END
go

CREATE PROCEDURE uspAddProductToOrder
@OrderID int,
@Quantity int,
@ProductName varchar(255),
@ToGo bit AS
BEGIN
  SET NOCOUNT ON
  BEGIN TRY
      IF NOT EXISTS( SELECT * FROM Product WHERE ProductName = @ProductName )
      BEGIN
          THROW 52000, 'Nie ma takiej potrawy', 1
      END
      IF NOT EXISTS( SELECT * FROM Orders WHERE OrderID = @OrderID )
          BEGIN
              THROW 52000, 'Nie ma takiego zamowienia', 1
          END
      DECLARE @temp datetime;
      DECLARE @menuIDToCheck int;
      IF (select PickupDate from Pickup P, Orders O where O.PickupID = P.PickupID and OrderID = @OrderID) is not null
          BEGIN
               set @temp = (select PickupDate from Pickup P, Orders O where O.PickupID = P.PickupID and OrderID = @OrderID)
               select @menuIDToCheck = MenuID from Menu where @temp between StartDate and EndDate
          end
      ELSE
          BEGIN
               IF (select P.ReservationStartDate from Reservation P, Orders O where O.ReservationID = P.ReservationID and OrderID = @OrderID) is not null
                         BEGIN
                             set @temp = (select P.ReservationStartDate from Reservation P, Orders O where O.ReservationID = P.ReservationID and OrderID = @OrderID)
               select @menuIDToCheck = MenuID from Menu where @temp between StartDate and EndDate
                          end
               ELSE
                   BEGIN
                       SET @menuIDToCheck = (select MenuID from Menu where GETDATE() between StartDate and EndDate)
                   end
          end
      IF @menuIDToCheck is null
           BEGIN
               THROW 52000, N'Nie mozna zamowic tego produktu, gdyz menu na dany dzień nie zsotało jeszcze dodane', 1
           end
      IF NOT EXISTS( SELECT * FROM udfGetMenuItemsById(@menuIDToCheck) WHERE ProductName = @ProductName )
          BEGIN
              THROW 52000, N'Nie mozna zamowic tego produktu, gdyz nie ma go w menu na dany dzień', 1
          END
      IF EXISTS( select * from Product where ProductName = @ProductName and CategoryID = (select CategoryID from Category where CategoryName = 'Ryby'))
          BEGIN
          DECLARE @DateOfExecutingOrder datetime;
          set @DateOfExecutingOrder = null;
          IF (Select PickupID from Orders where OrderID = @OrderID) is not null
              BEGIN
                  SET @DateOfExecutingOrder = (select PickupDate from Pickup where PickupID = (Select PickupID from Orders where OrderID = @OrderID))
              end
          IF (Select ReservationID from Orders where OrderID = @OrderID) is not null
              BEGIN
                  SET @DateOfExecutingOrder = (select ReservationStartDate from Reservation where ReservationID = (Select ReservationID from Orders where OrderID = @OrderID))
              end
          IF @DateOfExecutingOrder is null
              BEGIN
                   THROW 52000, N'Brak daty odbioru owoców morza', 1
              end
          IF DATEPART(WEEKDAY ,@DateOfExecutingOrder) != 4 AND DATEPART(WEEKDAY , @DateOfExecutingOrder) != 5 AND DATEPART(WEEKDAY ,@DateOfExecutingOrder) != 6
              BEGIN
                  THROW 52000, N'Nieprawidłowa data złożenia zamówienia na owoce morza', 1
              end
           IF DATEPART(WEEKDAY , GETDATE()) != 1 and DATEPART(WEEKDAY , GETDATE()) != 7 and DATEPART(week, GETDATE()) = DATEPART(week, @DateOfExecutingOrder)
              begin
                 THROW 52000, N'Nieprawidłowa data złożenia zamówienia na owoce morza', 1
              end
          END
      DECLARE @ProductID INT
      SELECT @ProductID = ProductID FROM Product WHERE ProductName = @ProductName
      INSERT INTO OrderDetails(OrderID, Quantity, ProductID, ToGo)
      VALUES (@OrderID,@Quantity,@ProductID, @ToGo)
  END TRY
  BEGIN CATCH
      DECLARE @msg nvarchar(2048) =N'Błąd dodania produktu do zamowienia: ' + ERROR_MESSAGE(); THROW 52000, @msg, 1
  END CATCH
END

create procedure uspAddEmployee
	@Name varchar(255),
	@Phone varchar(20),
	@EMail varchar(255),
	@Country varchar(255)
as
	BEGIN try
	insert into Employees (Name, Phone, Email, Country)
	values (@Name, @Phone, @EMail, @Country)
	END try
	Begin catch
    	DECLARE @msg nvarchar(2048) =N'Błąd dodania pracownika: ' + ERROR_MESSAGE();
	THROW 52000, @msg, 1
	end catch
go

create procedure uspAddIndividualClient
	@ClientName varchar(255),
	@Phone varchar(20),
	@Email varchar(255),
	@Country varchar(255)
as
	Begin try
	insert into Clients (ClientName)
	values (@ClientName)
 
	declare @id int
	set @id = (select Max(Client_ID) from Clients)
	insert into IndividualClient (Client_ID, Phone, Email, Country)
	values (@id, @Phone, @Email, @Country)
	End try
	Begin catch
    	DECLARE @msg nvarchar(2048) =N'Błąd dodania klienta: ' + ERROR_MESSAGE();
	THROW 52000, @msg, 1
	End catch
go

create procedure uspAddCompany
	@ClientName varchar(255),
	@ContactName varchar(255),
	@NIP varchar(10),
	@Address varchar(255),
	@City varchar(255),
	@Region varchar(255),
	@PostalCode varchar(255),
	@Phone varchar(20),
	@EMail varchar(255),
	@Country varchar(255)
as
	begin try
	insert into Clients (ClientName)
	values (@ClientName)
 
	declare @id int
	set @id = (select Max(Client_ID) from Clients)
 
	insert into Companies (Client_ID, ContactName, NIP, Address, City, Region, PostalCode, Phone, Email, Country)
	values (@id, @ContactName, @NIP, @Address, @City, @Region, @PostalCode, @Phone, @EMail, @Country)
	end try
	Begin catch
    	DECLARE @msg nvarchar(2048) =N'Błąd dodania klienta: ' + ERROR_MESSAGE();
	THROW 52000, @msg, 1
	End catch
go

create procedure uspAddTable
	@ChairNumbers int
as
	begin try
    	insert into [Table] (ChairsNumber)
    	values (@ChairNumbers)
	end try
	begin catch
    	DECLARE @msg nvarchar(2048) =N'Błąd dodania stolika: ' + ERROR_MESSAGE();
	THROW 52000, @msg, 1
	end catch
go

create procedure uspAddReservation
	@ReservationStartTime datetime,
	@ReservationEndTime datetime,
	@ReservationGuestNumber int
as
	begin try
 
	Declare @AllChairs int
	Declare @TakenChairs int
	
	set @AllChairs = (select Sum(ChairsNumber) from [Table])
	set @TakenChairs = (select Sum(ChairsNumber) from [Table] inner join ReservationDetails RD on [Table].TableID = RD.TableID
	inner join Reservation R2 on R2.ReservationID = RD.ReservationID where ReservationStartDate between @ReservationStartTime and @ReservationEndTime
	or ReservationEndDate between @ReservationStartTime and ReservationEndDate)
	if(@AllChairs - @TakenChairs < @ReservationGuestNumber)
    	begin
        	THROW 52000, N'Zbyt duża ilość gości, brak miejsc', 1
    	end
   insert into Reservation (ReservationStartDate, ReservationEndDate, ReservationGuestNumber, EmployeeID)
   values (@ReservationStartTime, @ReservationEndTime, @ReservationGuestNumber, null)
	end try
	begin catch
    	DECLARE @msg nvarchar(2048) =N'Błąd dodania rezerwacji: ' + ERROR_MESSAGE();
	THROW 52000, @msg, 1
	end catch
go

create procedure uspAddReservationDetails
	@ReservationID int,
	@TableID int,
	@ReservationName varchar(255)
as
	begin try
	Declare @NbOfReservations int
	Declare @StartTime datetime
	Declare @EndTime datetime
 
	set @StartTime = (select ReservationStartDate from Reservation where ReservationID = @ReservationID)
	set @EndTime = (select ReservationEndDate from Reservation where ReservationID = @ReservationID)
	set @NbOfReservations = (select count(*) from ReservationDetails RD
	inner join Reservation R on RD.ReservationID = R.ReservationID where (R.ReservationStartDate between @StartTime and @EndTime
	or R.ReservationEndDate between @StartTime and @EndTime) and RD.TableID = @TableID)
	if(@NbOfReservations > 0)
    	begin
        	THROW 52000, N'Ten stolik jest już zajęty', 1
    	end
	insert into ReservationDetails (ReservationID, TableID, ReservationName)
    	values (@ReservationID, @TableID, @ReservationName)
	end try
	begin catch
    	DECLARE @msg nvarchar(2048) =N'Błąd dodania rezerwacji: ' + ERROR_MESSAGE();
	THROW 52000, @msg, 1
	end catch
go

create procedure uspConfirmReservation
	@ReservationID int,
	@EmployeeID int
	as
	begin try
    	update Reservation
    	set EmployeeID = @EmployeeID
    	where ReservationID = @ReservationID
	end try
	begin catch
    	DECLARE @msg nvarchar(2048) =N'Błąd potwierdzania: ' + ERROR_MESSAGE();
	THROW 52000, @msg, 1
	end catch

create procedure uspConfirmPickUp
@PickupID int
as
begin try
    update Pickup
    set Picked = 1
    where PickupID = @PickupID
end try

begin catch
    DECLARE @msg nvarchar(2048) =N'Błąd potwierdzania: ' + ERROR_MESSAGE();
THROW 52000, @msg, 1
end catch

create procedure uspAddDiscountsToClient
  @ClientID int
as
  Begin try
  IF not exists(select * from IndividualClient where IndividualClient.Client_ID = @ClientID)
      BEGIN
           THROW 52000, N'Klient nie istnieje lub nie jest klientem indywidualnym', 1
       end
  IF not exists(select * from Discount where Discount.Client_ID = @ClientID and DiscountAmount = (select R1 from CurrentVariables))
      begin
           DECLARE @NumOfOrdersForR1 int
          select @NumOfOrdersForR1 = count(OrdersInfo.OrderID) from OrdersInfo where OrdersInfo.Client_ID = @ClientID and OrdersInfo.value >= (select K1 from CurrentVariables)
           if @NumOfOrdersForR1 >= (select Z1 from CurrentVariables)
          begin
               insert into Discount(StartDate, EndDate, DiscountAmount, Client_ID) values (getdate(), null, (select R1 from CurrentVariables), @ClientID)
           end
      end
  IF not exists(select * from Discount where Discount.Client_ID = @ClientID and DiscountAmount = (select R2 from CurrentVariables))
      begin
           DECLARE @NumOfOrdersForR22 int
          select @NumOfOrdersForR22 = sum(OrdersInfo.value) from OrdersInfo where OrdersInfo.Client_ID = @ClientID
           if @NumOfOrdersForR22 >= (select K2 from CurrentVariables)
          begin
               insert into Discount(StartDate, EndDate, DiscountAmount, Client_ID) values (getdate(), dateadd(day, 7, getdate()), (select R2 from CurrentVariables), @ClientID)
           end
      end
  IF exists(select * from Discount where Discount.Client_ID = @ClientID and DiscountAmount = (select R2 from CurrentVariables))
      begin
          declare @DateOfRecentR2 date
          select top 1 @DateOfRecentR2 = StartDate from Discount where Discount.Client_ID = @ClientID order by StartDate DESC;
           DECLARE @NumOfOrdersForR2 int
          select @NumOfOrdersForR2 = sum(OrdersInfo.value) from OrdersInfo where OrdersInfo.Client_ID = @ClientID and OrdersInfo.OrderDate > @DateOfRecentR2
           if @NumOfOrdersForR2 >= (select K2 from CurrentVariables)
          begin
               insert into Discount(StartDate, EndDate, DiscountAmount, Client_ID) values (getdate(), dateadd(day, 7, getdate()), (select R2 from CurrentVariables), @ClientID)
           end
      end
  End try
  Begin catch
      DECLARE @msg nvarchar(2048) =N'Błąd dodania Discount: ' + ERROR_MESSAGE();
  THROW 52000, @msg, 1
  end catch

ALTER PROCEDURE uspAddMenu
    @startDate Date,
    @dishesNumber int
AS
BEGIN
    DECLARE @isGettingRandomRecordsFinished BIT
    SET @isGettingRandomRecordsFinished = 1
    CREATE TABLE #newMenuCandidateProducts (ProductID INT, CategoryID INT, ProductName varchar(255),
                                                                                    Description varchar(255))
    WHILE @isGettingRandomRecordsFinished = 1
    BEGIN
        INSERT INTO #newMenuCandidateProducts SELECT top (@dishesNumber) * FROM Product ORDER BY newid()
	    DECLARE @numberOfRepetedItems INT
        SET @numberOfRepetedItems = 0
	    SELECT @numberOfRepetedItems = COUNT(*) FROM CurrentMenu as CM
	                                            WHERE EXISTS(SELECT * FROM #newMenuCandidateProducts as tmp
	                                                                    WHERE tmp.ProductName LIKE CM.ProductName)
	    IF @numberOfRepetedItems > @dishesNumber / 2
		    SET @isGettingRandomRecordsFinished = 1
	    ELSE
		    SET @isGettingRandomRecordsFinished = 0
    END
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS( SELECT * FROM Menu WHERE @startDate = StartDate )
            BEGIN ;
            THROW 52000, N'Menu z tą samą początkową datą jest już dodane', 1
            END
        INSERT INTO Menu(StartDate, EndDate) VALUES(@startDate, DATEADD(week, 2, @startDate));
    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(2048) = N'Błąd dodawania menu: ' + ERROR_MESSAGE(); THROW 52000, @msg, 1;
    END CATCH

    DECLARE @MenuID INT
    SELECT @MenuID = MenuID FROM Menu WHERE StartDate = @startDate

    INSERT INTO MenuDetails SELECT tmp.ProductID, @MenuID, (SELECT TOP 1 Cost FROM MenuDetails as MD WHERE tmp.ProductID = MD.ProductID ORDER BY MenuID DESC)
        FROM #newMenuCandidateProducts as tmp;

END
Go

create procedure uspAddVariables
   @WK int,
   @WZ int,
   @Z1 int,
   @K1 decimal(15,2),
   @D1 int,
   @R1 decimal(15,2),
   @R2 decimal(15,2),
   @StartDate date,
   @K2 decimal(15, 2)
as
   begin
       insert into Variables (WK, WZ, Z1, K1, D1, R1, R2, StartDate, K2)
       values (@WK, @WZ, @Z1, @K1, @D1, @R1, @R2, @StartDate, @K2)
   end
go

CREATE FUNCTION udfGetMenuItemsById(@id int)
   RETURNS TABLE AS
       RETURN SELECT M.MenuID, M.StartDate, M.EndDate, (select ProductName from Product where MD.ProductID = Product.ProductID) as ProductName, MD.Cost
       from Menu M inner join MenuDetails MD on M.MenuID = MD.MenuID WHERE M.MenuID = @id;

CREATE FUNCTION udfGetMenuItemsByDate(@date date)
RETURNS TABLE AS
RETURN
SELECT M.MenuID, M.StartDate, M.EndDate, P.ProductName, MD.Cost FROM
Menu M inner join MenuDetails MD on M.MenuID = MD.MenuID
INNER JOIN Product P on P.ProductID = MD.ProductID WHERE @date BETWEEN M.StartDate AND M.EndDate

CREATE FUNCTION udfGetReceipt(@id int)
RETURNS TABLE AS
RETURN
SELECT P.ProductName, OD.Quantity,
     OD.Quantity*(select MD.Cost from MenuDetails MD
         inner join Menu M on M.MenuID = MD.MenuID where O.OrderDate BETWEEN M.StartDate and M.EndDate and MD.ProductID= P.ProductID) as Cost
from Orders O inner join OrderDetails OD ON OD.OrderID = O.OrderID
Inner join Product as P ON P.ProductID = OD.ProductID where O.OrderId = @id

CREATE FUNCTION udfGetBestDiscount(@id int) 
RETURNS int AS 
BEGIN 
DECLARE @val int; 
SET @val = null
SET @val = (SELECT TOP 1 D.DiscountID FROM Discount where ((GETDATE() BETWEEN StartDate AND EndDate) or (GETDATE() > StartDate AND EndDate is null)) and used = 0 ORDER BY D.DiscountAmount DESC) 
RETURN @val 
END

CREATE FUNCTION udfGetOrderValue(@id int)
RETURNS money AS
BEGIN
RETURN (SELECT value from OrdersInfo where OrderID = @id)
END

CREATE FUNCTION udfShowClientDiscounts(@id int)
RETURNS TABLE AS
RETURN
SELECT StartDate, EndDate, DiscountAmount from Discount where Used = false and Client_ID = @id;

CREATE FUNCTION udfShowClientHistory (@ClientID INT)
RETURNS TABLE
AS
RETURN
  SELECT OrderID,value FROM OrdersInfo WHERE Client_ID = @ClientID;

CREATE FUNCTION udfGetInvoiceByOrderId(@OrderId int)
  RETURNS TABLE AS
      RETURN SELECT (select dbo.[udfGetOrderValue](@OrderId)) / 1.23 as orderValueNetto,
                    (select dbo.[udfGetOrderValue](@OrderId)) - (select dbo.[udfGetOrderValue](@OrderId)) / 1.23 as VAT,
                    Co.ContactName, Co.Country, Co.NIP, Co.City, Co.Address, Co.PostalCode  FROM Orders
          INNER JOIN Clients C on C.Client_ID = Orders.Client_ID
          INNER JOIN Companies Co on C.Client_ID = Co.Client_ID
                                                             WHERE OrderID = @OrderId;

create trigger TR_applyDiscount
   ON Orders
   for INSERT
   as
   BEGIN
       Declare
       @ClientID int,
       @DiscountID int
       SET NOCOUNT ON;
       SELECT @ClientID= INSERTED.[Client_ID],
       @DiscountID= INSERTED.[DiscountID] FROM INSERTED
       IF exists(select * from IndividualClient where IndividualClient.Client_ID = @ClientID)
           Begin
               if (Select EndDate from Discount where Discount.DiscountID = @DiscountID) is not null
                   begin
                       update Discount set Used = 1 where DiscountID = @DiscountID;
                   end
           end
   end

CREATE TRIGGER TR_AfterDeleteOrderUnuseDiscount on Orders
AFTER DELETE
AS DECLARE
@DiscountID INT
select @DiscountID = d.DiscountID from deleted d
if (select Used from Discount D where D.DiscountID = @DiscountID) = 1
   BEGIN
       update  Discount set Used = 0 where DiscountID = @DiscountID
   end

CREATE TRIGGER TR_AfterDeleteOrderDeleteReservationOrPickup on Orders
AFTER DELETE
AS DECLARE
@ReservationID INT,
@PickupID INT
select @ReservationID = d.ReservationID from deleted d
select @PickupID = d.PickupID from deleted d
if @ReservationID is not null
  BEGIN
      delete from ReservationDetails where ReservationID = @ReservationID;
      delete from Reservation where ReservationID = @ReservationID;
  End
if @PickupID is not null
   Begin
       delete from Pickup where PickupID = @PickupID;
   end

create role worker
 
GRANT SELECT ON CurrentMenu TO worker
GRANT SELECT ON MealsCatalog TO worker
GRANT SELECT ON ShowDiscounts TO worker
GRANT SELECT ON IndividualClientInfo TO worker
GRANT SELECT ON UnconfirmedReservation TO worker
GRANT SELECT ON TodayReservations TO worker
GRANT SELECT ON OrdersToPay TO worker
GRANT SELECT ON PendingPickup TO worker
GRANT SELECT ON ProductsSold TO worker
GRANT SELECT ON ProductsSoldDaily TO worker
GRANT SELECT ON ProductsSoldMonthly TO worker
GRANT SELECT ON ProductsSoldAnnually TO worker
GRANT SELECT ON AnnualIncome TO worker
GRANT SELECT ON OrdersInfo TO worker
GRANT SELECT ON DiscountsInfo TO worker
GRANT SELECT ON CurrentVariables TO worker
GRANT SELECT ON WeeklyTableReservations TO worker
GRANT SELECT ON MonthlyTableReservations TO worker

GRANT EXECUTE ON uspAddOrder TO worker
GRANT EXECUTE ON uspAddProductToOrder TO worker
GRANT EXECUTE ON uspAddIndividualClient TO worker
GRANT EXECUTE ON uspAddCompany TO worker
GRANT EXECUTE ON uspAddReservation TO worker
GRANT EXECUTE ON uspAddReservationDetails TO worker
GRANT EXECUTE On uspConfirmReservation TO worker
GRANT EXECUTE ON uspConfirmPickUp TO worker
GRANT EXECUTE ON uspAddDiscountsToClient TO worker
GRANT SELECT ON udfShowClientDiscounts TO worker
GRANT SELECT ON udfGetInvoiceByOrderId TO worker
GRANT EXECUTE ON uspAddMenu TO worker

CREATE ROLE moderator

GRANT SELECT ON CurrentMenu TO moderator
GRANT SELECT ON MealsCatalog TO moderator
GRANT SELECT ON ShowDiscounts TO moderator
GRANT SELECT ON IndividualClientInfo TO moderator
GRANT SELECT ON UnconfirmedReservation TO moderator
GRANT SELECT ON TodayReservations TO moderator
GRANT SELECT ON OrdersToPay TO moderator
GRANT SELECT ON PendingPickup TO moderator
GRANT SELECT ON ProductsSold TO moderator
GRANT SELECT ON ProductsSoldDaily TO moderator
GRANT SELECT ON ProductsSoldMonthly TO moderator
GRANT SELECT ON ProductsSoldAnnually TO moderator
GRANT SELECT ON AnnualIncome TO moderator
GRANT SELECT ON OrdersInfo TO moderator
GRANT SELECT ON DiscountsInfo TO moderator
GRANT SELECT ON CurrentVariables TO moderator
GRANT SELECT ON WeeklyTableReservations TO moderator
GRANT SELECT ON MonthlyTableReservations TO moderator

GRANT EXECUTE ON uspAddCategory TO moderator
GRANT EXECUTE ON uspAddProduct TO moderator
GRANT EXECUTE ON uspAddProductToMenuByDate TO moderator
GRANT EXECUTE ON uspAddProductToMenuByDate TO moderator
GRANT EXECUTE ON uspAddOrder  TO moderator
GRANT EXECUTE ON uspAddProductToOrder TO moderator
GRANT EXECUTE ON uspAddEmployee TO moderator
GRANT EXECUTE ON uspAddIndividualClient TO moderator
GRANT EXECUTE ON uspAddCompany TO moderator
GRANT EXECUTE ON uspAddTable TO moderator
GRANT EXECUTE ON uspAddReservation TO moderator
GRANT EXECUTE ON uspAddReservationDetails TO moderator
GRANT EXECUTE On uspConfirmReservation TO moderator
GRANT EXECUTE ON uspConfirmPickUp TO moderator
GRANT EXECUTE ON uspAddMenu TO moderator
GRANT EXECUTE ON uspAddDiscountsToClient TO moderator
GRANT SELECT ON udfShowClientDiscounts TO moderator
GRANT SELECT ON udfGetInvoiceByOrderId TO moderator
GRANT EXECUTE ON uspAddVariables To moderator

GRANT SELECT, INSERT, DELETE ON Employees TO moderator
GRANT SELECT, INSERT, DELETE ON Reservation TO moderator
GRANT SELECT, INSERT, DELETE ON ReservationDetails TO moderator
GRANT SELECT, INSERT, DELETE ON [Table] TO moderator
GRANT SELECT, INSERT, DELETE ON Clients TO moderator
GRANT SELECT, INSERT, DELETE ON IndividualClientInfo TO moderator
GRANT SELECT, INSERT, DELETE ON Companies TO moderator
GRANT SELECT, INSERT, DELETE On OpeningHours TO moderator
GRANT SELECT, INSERT, DELETE On OpeningHoursDetails TO moderator

--CREATE ROLE admin
--GRANT ALL PRIVILEGES ON u_sus.dbo TO admin

