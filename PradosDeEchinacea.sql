-- Base de datos --
create database PradosDeEchinacea
go

-- Usar Base de Datos --
use PradosDeEchinacea
go

-- Tabla Sexos --
create table Sexos
(IdSexo int not null primary key,
NombreSexo varchar(70)
)

Insert into Sexos(IdSexo,NombreSexo) values(1,'Masculino')
Insert into Sexos(IdSexo,NombreSexo) values(2,'Femenino')

-- Tabla Tipos --
create table TiposDeDocumentos
(IdTipo int not null primary key,
NombreTipo varchar(70)
)

select *
from TiposDeDocumentos

Insert into TiposDeDocumentos(IdTipo,NombreTipo) values(1,'DNI')
Insert into TiposDeDocumentos(IdTipo,NombreTipo) values(2,'CI')
Insert into TiposDeDocumentos(IdTipo,NombreTipo) values(3,'CC')
Insert into TiposDeDocumentos(IdTipo,NombreTipo) values(4,'CE')

-- Tabla Clientes --
create table Clientes
(IdCliente int not null identity(1,1) primary key,
NombreCompleto varchar(120),
Telefono int,
IdTipo int not null,
NroDocumento int,
IdSexo int not null,
Calle varchar(70),
NroCalle int,
CodigoPostal int,
Ciudad varchar(70),
Barrio varchar(70),
Email varchar(70)
constraint fk_TiposDeDocumentos_Clientes foreign key (IdTipo)
references TiposDeDocumentos (IdTipo),
constraint fk_Sexos_Clientes foreign key (IdSexo)
references Sexos (IdSexo)
)

select c.IdCliente, c.NombreCompleto, c.Telefono, td.NombreTipo, c.NroDocumento, s.NombreSexo, c.Calle, c.NroCalle, c.CodigoPostal, c.Ciudad, c.Barrio, c.Email
from Clientes c  INNER JOIN TiposDeDocumentos td ON c.IdTipo = td.IdTipo 
INNER JOIN Sexos s ON c.IdSexo = s.IdSexo
order by c.NombreCompleto

-- Cbo --
insert into Clientes(NombreCompleto)
values('Es un cliente normal')



-- Tabla Productos --
create table Productos
(NroProducto int not null identity(1,1) primary key,
NombreProducto varchar(70),
Descripcion varchar(500),
PrecioUnitario money
)

select PrecioUnitario
from Productos
where NombreProducto = 'Echinacea'

select NroProducto, NombreProducto, Descripcion, cast(PrecioUnitario AS Decimal(8,2)) AS PrecioUnitario
from Productos
where NroProducto = NroProducto
order by NroProducto

--Reportes Productos
select NombreProducto 'Producto'
from Productos 
where PrecioUnitario = (select max(PrecioUnitario) from Productos)

-- Tabla Estados --
create table Estados
(IdEstado int not null primary key,
nombreEstado varchar(70)
)

Insert into Estados(IdEstado,nombreEstado) values(1,'En Preparacion')
Insert into Estados(IdEstado,nombreEstado) values(2,'Cancelado')
Insert into Estados(IdEstado,nombreEstado) values(3,'En Curso')
Insert into Estados(IdEstado,nombreEstado) values(4,'Entregado')


-- Tabla Pedidos --
create table Pedidos
(NroPedido int not null identity(1,1) primary key,
Descripcion varchar(500),
IdEstado int,
FechaRealizacionDelPedido varchar(70),
FechaEntrega varchar(70),
IdCliente int not null
constraint fk_Clientes_Pedidos foreign key (IdCliente)
references Clientes (IdCliente),
constraint fk_Estados_Pedidos foreign key (IdEstado)
references Estados (IdEstado)
)

select * from Pedidos where FechaRealizacionDelPedido between '02/07/2017' and '03/04/2017'

select * from Ventas where FechaVenta between '02/07/2017' and '03/04/2017'


select p.NroPedido, p.Descripcion, e.nombreEstado, p.FechaRealizacionDelPedido, p.FechaEntrega, c.NombreCompleto
from Pedidos p INNER JOIN Estados e ON p.IdEstado = e.IdEstado INNER JOIN Clientes c ON p.IdCliente = c.IdCliente
where FechaRealizacionDelPedido between '02/06/2017' and '02/09/2017'

-- Tabla Detalle Pedidos --
create table DetallePedidos
(NroDetalle int not null identity(1,1) primary key,
Cantidad int,
PrecioProducto money,
NroProducto int not null,
NroPedido int not null
constraint fk_Productos_DetallePedidos foreign key (NroProducto)
references Productos (NroProducto),
constraint fk_Pedidos_DetallePedidos foreign key (NroPedido)
references Pedidos (NroPedido)
)

select sum(Cantidad * PrecioProducto) Total
from DetallePedidos
where NroPedido = 1

insert into DetallePedidos(Cantidad,PrecioProducto,NroProducto,NroPedido)
values(5,100,1,1)

select dp.NroDetalle, dp.Cantidad, p.PrecioUnitario, p.NombreProducto, dp.NroPedido
from DetallePedidos dp INNER JOIN Productos p ON dp.NroProducto = p.NroProducto
order by p.NombreProducto

-- Tabla Cobranzas --
create table Cobranzas
(NroCobro int not null identity(1,1) primary key,
Monto money,
FechaDelCobro varchar(70),
IdCliente int not null
constraint fk_Clientes_Cobranzas foreign key (IdCliente)
references Clientes (IdCliente)
)


SET IDENTITY_INSERT Cobranzas ON;  
GO

select c.NroCobro, c.Monto, c.FechaDelCobro, cli.NombreCompleto
from Cobranzas c INNER JOIN Clientes cli ON c.IdCliente = cli.IdCliente
order by c.NroCobro


-- Tabla Ventas --
create table Ventas
(NroVenta int not null identity(1,1) primary key,
Importe money,
FechaVenta varchar(70),
NroProducto int,
NombreCliente varchar(70),
NroPedido int not null,
IdCliente int 
constraint fk_Pedidos_Ventas foreign key (NroPedido)
references Pedidos (NroPedido),
constraint fk_Productos_Ventas foreign key (NroProducto)
references Productos (NroProducto),
constraint fk_Clientes_Ventas foreign key (IdCliente)
references Clientes (IdCliente)
)

-- Traer datos --
-- Clientes --
select c.NombreCompleto
from Pedidos p INNER JOIN Clientes c ON p.IdCliente = c.IdCliente
where c.NombreCompleto = 'Rodrigo Agostinelli'


select c.NombreCompleto
from  Clientes c 
where c.NombreCompleto = 'Rodrigo Agostinelli'
-- 1
select c.NombreCompleto
from  Clientes c, Pedidos p
where p.IdCliente = c.IdCliente and c.NombreCompleto = 'Rodrigo Agostinelli'

-- 2
select c.NombreCompleto
from  Pedidos p INNER JOIN Clientes c ON p.IdCliente = c.IdCliente
where c.NombreCompleto = 'Rodrigo Agostinelli'

select * from Ventas

select v.NroVenta, v.Importe, v.FechaVenta, p.NroPedido
from Ventas v INNER JOIN Pedidos p ON v.NroPedido = p.NroPedido 
Order by v.NroVenta

-- Producto --
select p.NombreProducto
from Pedidos pe, Productos p, DetallePedidos dp
where dp.NroProducto = p.NroProducto and dp.NroPedido = pe.NroPedido and p.NombreProducto = 'Cedron'



select COUNT(*) 'Pedido'
from Ventas
where NroPedido = 3

-- Modificaciones --
alter table Ventas
alter column NroProducto int null

alter table Ventas
alter column IdCliente int null

select v.NroVenta, v.Importe, v.FechaVenta, p.NroPedido 
from Ventas v INNER JOIN Pedidos p ON v.NroPedido = p.NroPedido
where p.NroPedido = 1
Order by v.NroVenta


-- Reportes --
-- Productos ordenados por cantidad vendida (ranking) venta entre fechas 
/*==============================================================================================*/
select top 10 p.NombreProducto, sum(dp.Cantidad) 'TotalProductos' , cast(sum(dp.Cantidad * dp.PrecioProducto) as decimal(8,2)) as 'TotalImporte'
from DetallePedidos dp Inner join Productos p ON dp.NroProducto = p.NroProducto
group by p.NombreProducto, dp.Cantidad, dp.PrecioProducto
Order by dp.Cantidad asc
/*==============================================================================================*/

select Top 10 p.NombreProducto, SUM(p.PrecioUnitario) as 'Total De Ventas'
from Productos p
group by NombreProducto

/*Segundo reporte: Cobranzas por cliente:
1) Permitir que el usuario seleccione las fechas de realización de las cobranzas desde/hasta como filtro.
2) Agrupar por cliente los totales cobrados (sumar los montos).
3) Ordenar por cliente
4) Mostrar un total de montos.*/
-- Cobranzas entre fechas (cliente, fecha, importe, totales)--
select cli.NombreCompleto, Sum(c.Monto) 'TotalDeMontos'
from Cobranzas c INNER JOIN Clientes cli ON c.IdCliente = cli.IdCliente
where FechaDelCobro between '04/27/2017' and '10/27/2017'
group by cli.NombreCompleto, c.Monto
order by cli.NombreCompleto asc

/*Tercer reporte: Ventas entre fechas:
1) Permitir que el usuario seleccione las fechas de venta desde/hasta como filtro.
2) Mostrar 1 registro por venta por cliente, con el nombre del cliente, número del comprobante de venta, fecha de la venta, y total de la venta.
3) Ordenarlo por fecha.
4) Mostrar total de ventas (cuantas ventas realizadas) y total de monto (suma de importes)*/
--  Ventas entre fechas (cliente, fecha importe, totales) --
select v.NroVenta, v.NombreCliente, v.FechaVenta, sum(dp.Cantidad) 'TotaldeVentas', v.Importe 'TotalDelMonto'
from DetallePedidos dp left join Ventas v ON dp.NroPedido = v.NroPedido
where v.FechaVenta = v.FechaVenta
group by v.NroVenta, v.FechaVenta, v.NombreCliente, v.Importe
order by v.FechaVenta, v.NroVenta desc

select *
from Ventas


/*SELECT TOP 10 ART_MOV, SUM(TOT_MOV) AS Total_Ventas
FROM VENTAS
GROUP BY ART_MOV
HAVING DIA_MOV BETTWEN ([Desde Fecha] and [Hasta Fecha])
ORDER BY SUM(TOT_MOV) DESC*/


-- PDF --
/*1) Agregar una columna con la descripción del artículo.
2) Colocar precio unitario (y dejar el total).
3) Dejar solo con 2 decimales el monto y alinearlo a la derecha.
4)  Agregar un total general del remito al pié.
5) Una vez que hagas estos ajustes, enviame un remito de por lo menos 2 artículos (2 renglones) y con cantidad mayor a 1.*/

select dp.NroProducto 'N°', p.NombreProducto ,dp.Cantidad, p.PrecioUnitario ,dp.Cantidad * dp.PrecioProducto 'Total'
from DetallePedidos dp INNER JOIN Productos p ON dp.NroProducto = p.NroProducto
where dp.NroPedido = dp.NroPedido and dp.Cantidad > 1
order by dp.NroPedido desc




select v.NroVenta, v.NombreCliente, v.FechaVenta, sum(dp.Cantidad) 'TotaldeVentas', cast(v.Importe as decimal(8,2)) as 'TotalDelMonto'
from DetallePedidos dp left join Ventas v ON dp.NroPedido = v.NroPedido
where v.FechaVenta = v.FechaVenta
group by v.NroVenta, v.FechaVenta, v.NombreCliente, v.Importe
order by v.FechaVenta, v.NroVenta desc