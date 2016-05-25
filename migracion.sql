
/* se crea el esquema*/
USE [GD1C2016]
GO
CREATE SCHEMA [THE_AVENGERS] AUTHORIZATION [gd]
GO
/*se crea las tablas sin los constraints */
CREATE TABLE THE_AVENGERS.Visibilidad
(
	Visivilidad_Cod numeric(18) NOT NULL,
	Visivilidad_Desc nvarchar(255) NOT NULL,
	Vicivilidad_Precio numeric(18,2) NOT NULL,
	Visivilidad_Porcentaje numeric(18,2) NOT NULL
)
;

CREATE TABLE THE_AVENGERS.Item_facturas
(
	Numero_factura bigint,
	Decriptcion_item varchar(50),
	cantidad_comprada int,
	Precio float
)
;

CREATE TABLE THE_AVENGERS.Calificaciones
(
	Codigo_Calificacion numeric(18) NOT NULL,
	Id_publicacion int,
	id_usuario int,
	Calificacion int,
	Fecha_calificaion date,
	Descripcion varchar(50),
	Compra_numero bigint
)
;

CREATE TABLE THE_AVENGERS.Facturacion
(
	Numero_factura bigint NOT NULL,
	fecha_facturacion date,
	id_usuario_comprador int,
	Id_usuario_vendedor int,
	Cod_publicacion numeric(18),
	Usuario_Usuario nvarchar
)
;

CREATE TABLE THE_AVENGERS.Rubros
(
	Id_rubro int NOT NULL,
	Descripcion varchar(255)
)
;

CREATE TABLE THE_AVENGERS.Compras
(
	Compra_numero bigint NOT NULL DEFAULT 0,
	Compra_Fecha_Compra date,
	Compra_Cantidad float,
	Compra_id_Usuario_Comprador int,
	Compra_id_publicacion int,
	Compra_tipo_publicacion varchar(255),
	Compra_calificacion bit,
	Publicacion_Cod numeric
)
;

CREATE TABLE THE_AVENGERS.Rol_x_usuario
(
	Usuario_Usuario nvarchar(50) NOT NULL
)
;

CREATE TABLE THE_AVENGERS.Ingresos
(
	numero_ingreso bigint NOT NULL IDENTITY(0,1),
	fecha datetime,
	Usuario_Usuario nvarchar(50),
	numero_intento int,
	sesion_correcta char(10),
	)
;

CREATE TABLE THE_AVENGERS.Publicacion
(
	Publicacion_Cod numeric(18) NOT NULL,
	Publicacion_Descripcion nvarchar(255),
	Publicacion_Stock numeric(18),
	Publicacion_Fecha_Venc datetime,
	Publicacion_Fecha datetime,
	Publicacion_Precio numeric(18,2),
	Publicacion_Costo numeric(18,2),
	Publicacion_Rubro_Id int,
	Publicacion_Visibilidad_Cod numeric(18) NOT NULL,
	Publicacion_Usuario_ID_Vendedor nvarchar(255),
	Publicacion_Estado nvarchar(255),
	Publicacion_Tipo nvarchar(255),
	Publicacion_Pemitir_preguntas bit,
	codigo_visibilidad numeric,
	Publicacion_Brinda_Envio bit,
	Usuario_Usuario nvarchar,
	Id_rubro int
)
;

CREATE TABLE THE_AVENGERS.Empresa
(
	Empresa_Razon_Social nvarchar(50) NOT NULL,
	Empresa_Ciudad nvarchar(50),
	Empresa_CUIL numeric(18) NOT NULL,
	Empresa_Nombre_Contacto nvarchar(50),
	Empresa_Rubro_Prisipal nvarchar(50)
)
;

CREATE TABLE THE_AVENGERS.Cliente
(
	Cliente_Documento numeric(18) NOT NULL,
	Cliente_Tipo_Documento nvarchar(255) NOT NULL,
	Usuario_Usuario nvarchar(50) NOT NULL,
	Cliente_Nombre nvarchar(255) NOT NULL,
	Cliente_Apeliido nvarchar(255) NOT NULL,
	Cliente_Fecha_Nac datetime NOT NULL,
	Cliente_Fecha_Creacion datetime NOT NULL,
	Cliente_Promedio_calificacion float NOT NULL
)
;

CREATE TABLE THE_AVENGERS.Usuario
(
	Usuario_Usuario nvarchar(50) NOT NULL,
	Usuario_Contraseña nvarchar(80) NOT NULL,
	Usuario_RolAsignado nvarchar(50) NOT NULL,
	Usuario_EsAdmin bit NOT NULL,
	Usuario_Estado int NOT NULL,
	Usuario_Mail nvarchar(255),
	Usuario_Telefono numeric(18),
	Usuario_Dom_Calle nvarchar(100),
	Usuario_Nro_Calle numeric(18),
	Usuario_Piso numeric(18),
	Usuario_Depto nvarchar(50),
	Usuario_Cod_Postal nvarchar(50),
	Usuario_dni nvarchar(255),
	Usuario_documento numeric(18),
	Usuario_cuil numeric(18),
	Cliente_Tipo_Documento nvarchar(255)
)
;

CREATE TABLE THE_AVENGERS.Funcionabilidad
(
	Funcionabilidad_ID int NOT NULL,
	Funcionabilidad_Nombre varchar(50) NOT NULL,
	Funcionabilidad_Tipo varchar(50) NOT NULL,
	Funcionabilidad_EsEspecial bit NOT NULL
)
;

CREATE TABLE THE_AVENGERS.RolXFuncionablilidad
(
	Rol_Nombre varchar(15) NOT NULL,
	Funcionabilidad_ID int NOT NULL
)
;

CREATE TABLE THE_AVENGERS.Rol
(
	Rol_Nombre varchar(15) NOT NULL,
	Rol_Habilitado bit NOT NULL
)
;


/* workpace*/
select * from THE_AVENGERS.Usuario



drop table THE_AVENGERS.Usuario

insert into THE_AVENGERS.Usuario 
(Usuario_Usuario,
Usuario_Contraseña,
Usuario_RolAsignado,
Usuario_EsAdmin,
Usuario_Estado,
Usuario_Mail,
Usuario_Telefono,
Usuario_Dom_Calle,
Usuario_Nro_Calle,
Usuario_Piso,
Usuario_Depto,
Usuario_Cod_Postal,
Usuario_dni,
Usuario_documento,
Usuario_cuil,
Cliente_Tipo_Documento)
VALUES ('user','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','administrador','1','1','pepe@caca.com','123456','calle falsa','123','0','0','1608','2222222222222','2222222','12313138','dni')



SELECT  Usuario_Contraseña,Usuario_Usuario,Usuario_Estado,isnull((SELECT top 1 isnull(numero_intento,0)
																	FROM THE_AVENGERS.Ingresos
																	WHERE Usuario_Usuario = 'user'
																	ORDER BY numero_ingreso DESC) ,0) ro
  FROM THE_AVENGERS.Usuario                             
  WHERE Usuario_Usuario ='user'