
/* se crea el esquema*/
USE [GD1C2016]
GO
CREATE SCHEMA [THE_AVENGERS] AUTHORIZATION [gd]
GO
/*se crea las tablas sin los constraints */
/*Creando con contraints*/
CREATE TABLE THE_AVENGERS.Visibilidad
(
	Visivilidad_Cod numeric(18) NOT NULL PRIMARY KEY,
	Visivilidad_Desc nvarchar(255) NOT NULL,
	Vicivilidad_Precio numeric(18,2) NOT NULL,
	Visivilidad_Porcentaje numeric(18,2) NOT NULL,
	Visivilidad_SoportaEnvios bit NOT NULL
)
;
CREATE TABLE THE_AVENGERS.Usuario
(
	Usuario_Usuario nvarchar(50) NOT NULL PRIMARY KEY,
	Usuario_Contraseña nvarchar(80) NOT NULL,
	Usuario_RolAsignado nvarchar(50) NOT NULL,
	Usuario_EsAdmin bit NOT NULL,
	Usuario_fecha_creacion datetime NOT NULL,

)
;
CREATE TABLE THE_AVENGERS.Rubros
(
	Id_rubro numeric(18) NOT NULL PRIMARY KEY,
	Descripcion nvarchar(255) NOT NULL,
)	
;

CREATE TABLE THE_AVENGERS.Publicacion
(
	Publicacion_Cod numeric(18) NOT NULL PRIMARY KEY,
	Publicacion_Descripcion nvarchar(255) NOT NULL,
	Publicacion_Stock numeric(18) NOT NULL,
	Publicacion_Fecha_Venc datetime NOT NULL,
	Publicacion_Fecha datetime NOT NULL,
	Publicacion_Precio numeric(18,2) NOT NULL,
	Publicacion_Costo numeric(18,2) NOT NULL,
	Publicacion_Rubro_Id numeric(18) NOT NULL REFERENCES THE_AVENGERS.Rubros,
	Publicacion_Visibilidad_Cod numeric(18) NOT NULL REFERENCES THE_AVENGERS.Visibilidad,
	Publicacion_Usuario_ID_Vendedor nvarchar(255) NOT NULL,
	Publicacion_Estado nvarchar(255) NOT NULL,
	Publicacion_Tipo nvarchar(255) NOT NULL,
	Publicacion_Pemitir_preguntas bit NOT NULL,
	codigo_visibilidad numeric(18) NOT NULL,
	Publicacion_Brinda_Envio bit NOT NULL,
	Usuario_Usuario nvarchar(50) NOT NULL REFERENCES THE_AVENGERS.Usuario
	
)
;
CREATE TABLE THE_AVENGERS.Facturacion
(
	Numero_factura numeric (18) NOT NULL PRIMARY KEY,
	fecha_facturacion datetime NOT NULL,
	id_usuario_comprador nvarchar(50) NOT NULL REFERENCES THE_AVENGERS.Usuario,
	Id_usuario_vendedor nvarchar(50) NOT NULL REFERENCES THE_AVENGERS.Usuario,
	Cod_publicacion numeric(18) NOT NULL,
	
)
;
CREATE TABLE THE_AVENGERS.Item_facturas
(
	Numero_factura numeric(18) NOT NULL REFERENCES THE_AVENGERS.Facturacion,
	Decriptcion_item nvarchar(255) NOT NULL,
	cantidad_comprada numeric(18) NOT NULL,
	Precio numeric(18,2) NOT NULL
)
;

CREATE TABLE THE_AVENGERS.Compras
(
	Compra_numero numeric(18) NOT NULL DEFAULT 0 PRIMARY KEY,
	Compra_Fecha_Compra datetime NOT NULL,
	Compra_Cantida numeric(18) NOT NULL,
	Compra_id_Usuario_Comprador nvarchar(50) NOT NULL,
	Compra_id_publicacion numeric(18) NOT NULL,
	Compra_tipo_publicacion nvarchar(50) NOT NULL,
	Compra_calificacion bit NOT NULL,
	Publicacion_Cod numeric(18) NOT NULL REFERENCES THE_AVENGERS.Publicacion
)
;

CREATE TABLE THE_AVENGERS.Calificaciones
(
	Codigo_Calificacion numeric(18) NOT NULL PRIMARY KEY,
	Cod_publicacion numeric(18) NOT NULL,
	id_usuario nvarchar(50) NOT NULL,
	Calificacion numeric(18) NOT NULL,
	Fecha_calificaion datetime NOT NULL,
	Descripcion nvarchar(255) NOT NULL,
	Compra_numero numeric(18) NOT NULL REFERENCES THE_AVENGERS.Compras
	)
;

CREATE TABLE THE_AVENGERS.Rol_x_usuario
(
	Usuario_Usuario nvarchar(50) NOT NULL REFERENCES THE_AVENGERS.Usuario

)
;

CREATE TABLE THE_AVENGERS.Ingresos
(
	numero_ingreso numeric(18) NOT NULL IDENTITY(0,1) PRIMARY KEY,
	fecha datetime NOT NULL,
	Usuario_Usuario nvarchar(50) NOT NULL REFERENCES THE_AVENGERS.Usuario,
	numero_intento numeric(1) DEFAULT 0 NOT NULL,
	sesion_correcta nvarchar(50) NOT NULL 
	)
;



CREATE TABLE THE_AVENGERS.Empresa
(
	Empresa_CUIL numeric(18) NOT NULL PRIMARY KEY,
	Empresa_Razon_Social nvarchar(50) NOT NULL ,
	Empresa_Nombre_Contacto nvarchar(50) NOT NULL,
	Empresa_Rubro_Prisipal nvarchar(50) NOT NULL,
	Empresa_mail nvarchar(50) NOT NULL,
	Empresa_Ciudad nvarchar(50) NOT NULL,
	Usuario_Usuario nvarchar(50) NOT NULL REFERENCES THE_AVENGERS.Usuario
	
	
)
;

CREATE TABLE THE_AVENGERS.Cliente
(
	Cliente_Documento numeric(18) NOT NULL PRIMARY KEY,
	Cliente_Tipo_Documento nvarchar(255) NOT NULL ,
	Cliente_Nombre nvarchar(255) NOT NULL,
	Cliente_Apeliido nvarchar(255) NOT NULL,
	Cliente_Fecha_Nac datetime NOT NULL,
	Cliente_Fecha_Creacion datetime NOT NULL,
	Cliente_Promedio_calificacion numeric(18,2) NOT NULL,
	Cliente_mail nvarchar(50) NOT NULL,
	Cliente_Telefono nvarchar(255) NOT NULL,
	Usuario_Usuario nvarchar(50) NOT NULL REFERENCES THE_AVENGERS.Usuario
)
;


CREATE TABLE THE_AVENGERS.Funcionabilidad
(
	Funcionabilidad_ID numeric(18) NOT NULL PRIMARY KEY,
	Funcionabilidad_Nombre nvarchar(50) NOT NULL,
	Funcionabilidad_Tipo nvarchar(50) NOT NULL,
	Funcionabilidad_EsEspecial bit NOT NULL
)
;

CREATE TABLE THE_AVENGERS.Rol
(
	Rol_Nombre nvarchar(50) NOT NULL PRIMARY KEY,
	Rol_Habilitado bit NOT NULL
)
;
CREATE TABLE THE_AVENGERS.RolXFuncionablilidad
(
	Rol_Nombre nvarchar(50) NOT NULL REFERENCES THE_AVENGERS.Rol,
	Funcionabilidad_ID numeric(18) NOT NULL REFERENCES THE_AVENGERS.Funcionabilidad
)
;

CREATE TABLE THE_AVENGERS.Estados
(
	Estado_Nombre nvarchar(255) NOT NULL PRIMARY KEY,
	Estado_Publicacion_Modificable bit NOT NULL,
	Estado_Publicacion_visible bit NOT NULL,
	Estado_Publicacion_DisponibleOperar bit NOT NULL,
	Estado_publicacion_Facturable bit NOT NULL
)
;
CREATE TABLE THE_AVENGERS.Ofertas
(
	Oferta_Publicacion_Cod numeric(18) NOT NULL REFERENCES THE_AVENGERS.Publicacion,
	Oferta_Usuario nvarchar(50) NOT NULL,
	Oferta_Fecha datetime NOT NULL,
	Oferta_Precio numeric(18) NOT NULL
)
;
CREATE TABLE THE_AVENGERS.Domicilios
(
	Dom_codio_postal nvarchar(50) NOT NULL PRIMARY KEY,
	Dom_clle nvarchar(255) NOT NULL,
	Dom_numero numeric(18) NOT NULL,
	Dom_piso numeric(18) NOT NULL,
	Dom_localidad nvarchar(255) NOT NULL,
	Dom_ciudad nvarchar(255) NOT NULL
)
;


/* workpace*/
select * from THE_AVENGERS.Usuario


drop table THE_AVENGERS.Domicilios
drop table THE_AVENGERS.Ofertas
drop table THE_AVENGERS.Estados
drop table THE_AVENGERS.RolXFuncionablilidad
drop table THE_AVENGERS.Rol
drop table THE_AVENGERS.Funcionabilidad
drop table THE_AVENGERS.Cliente
drop table THE_AVENGERS.Empresa
drop table THE_AVENGERS.Ingresos
drop table THE_AVENGERS.Rol_x_usuario
drop table THE_AVENGERS.Calificaciones
drop table THE_AVENGERS.Compras
drop table THE_AVENGERS.Item_facturas
drop table THE_AVENGERS.Facturacion
drop table THE_AVENGERS.Publicacion
drop table THE_AVENGERS.Rubros
drop table THE_AVENGERS.Usuario
drop table THE_AVENGERS.Visibilidad



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