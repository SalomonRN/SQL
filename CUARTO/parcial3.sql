create database parcial3;

use parcial3;

create table
    Cliente(
        cedula int primary key,
        nombre varchar(45),
        apellidos varchar(45),
        direccion varchar(45),
        email varchar(45) unique,
        pass blob,
        imagen varchar(45),
        cp varchar(45),
        localidad varchar(15),
        telefono varchar(15) unique
    );

create table
    Producto(
        id int primary key auto_increment,
        nombre varchar(45) UNIQUE,
        imagen varchar(45),
        precio double,
        descripcion varchar(45),
        impresion varchar(45),
        acabado varchar(45),
        tipoPapel varchar(45),
        tamaño double
    );

create table
    Empleado (
        cedula int primary key,
        ss varchar (45),
        salud double,
        nombre varchar (45),
        apellido varchar (45),
        email varchar(45) unique,
        pass blob,
        direccion varchar (45),
        salario double,
        comision double,
        telefono varchar (15) unique,
        cargo varchar(45),
        departamento varchar(45)
    );

create table
    tbl_sgr_empleado (
        cedula_c int,
        ss_c varchar (45),
        salud_c double,
        nombre_c varchar (45),
        apellido_c varchar (45),
        email_c varchar(45),
        pass_c blob,
        direccion_c varchar (45),
        salario_c double,
        comision_c double,
        telefono_c varchar (15),
        fecha_accion_c datetime,
        cargo_c varchar(45),
        departamento_c varchar(45),
        accion_c varchar(20)
    );
/*
	        new.pass,
	        new.direccion,
	        new.salario,
	        new.comision,
	        new.telefono,
	        new.cargo,
	        new.departamento,
	        now(),
	        "INSERTADO"
*/
create table
    Departamento (
        nombreDepartamento varchar (45) primary key,
        email varchar(45) unique,
        cedulaJefe int
    );

alter table Departamento
add
    foreign key (cedulaJefe) references Empleado (cedula);

create table
    Factura(
        id int primary key auto_increment,
        pago varchar(45),
        importe varchar(45),
        envio varchar(45),
        fecha datetime,
        idProducto int,
        cedula_cliente int
    );

ALTER TABLE Factura
ADD
    FOREIGN KEY (cedula_cliente) REFERENCES Cliente (cedula);

ALTER TABLE Factura
ADD
    FOREIGN KEY (idProducto) REFERENCES producto (id);

create table
    diseño(
        idDiseño int primary key auto_increment,
        tamañoDiseño double,
        formato varchar(45)
    );

/*
 1. Hacer el modelo relacional
 2. Ingresar 10 registros en cada Tabla;
 3. Encriptar los password
 4. Realizar tres vistas en la base de datos.
 5. Realizar tres Triggers para insertar, modificar y eliminar en la tabla empleados.
 6. Realizar por procedimientos almacenadosla inserción de información de la base de datos.
 7. Realizar por procedimientos almacenados cuando se repite el producto y el cliente.
 8. Realizar 2Funciones almacenamiento.
 */

## TRIGGERS

#INSERTAR

delimiter @

CREATE TRIGGER TR_INSERTAR_EMPLEADO AFTER INSERT ON EMPLEADO FOR EACH ROW 
BEGIN  
	INSERT into tbl_sgr_empleado values (new.cedula, new.ss, new.salud, new.nombre, new.apellido,new.email,new.pass,new.direccion,new.salario,new.comision,new.telefono,now(),new.cargo,new.departamento,"INSERTADO");
	END;


@

DELIMITER 

# ELIMINAR

delimiter @

CREATE TRIGGER TR_ELIMINAR_EMPLEADO BEFORE DELETE ON 
EMPLEADO FOR EACH ROW BEGIN  
	INSERT into tbl_sgr_empleado
	values (old.cedula, old.ss, old.salud, old.nombre, old.apellido,old.email,old.pass,old.direccion,old.salario,old.comision,old.telefono,now(),old.cargo,old.departamento,"ELIMINADO");
	END;


@

DELIMITER 

# ACTUALIZAR

## ANTES DE ACTUALIZAR

delimiter @

CREATE TRIGGER TR_ACTUALIZAR_OLD_EMPLEADO BEFORE UPDATE ON EMPLEADO FOR EACH ROW 
BEGIN  
	INSERT into tbl_sgr_empleado
	values (old.cedula, old.ss, old.salud, old.nombre, old.apellido,old.email,old.pass,old.direccion,old.salario,old.comision,old.telefono,now(),old.cargo,old.departamento,"ACTUALIZADO OLD");
	END;


@

DELIMITER ## ACTUALIZAR DESPUES

delimiter @

CREATE TRIGGER TR_ACTUALIZAR_NEW_EMPLEADO AFTER UPDATE ON EMPLEADO FOR EACH ROW 
BEGIN 
	INSERT into tbl_sgr_empleado
	values(new.cedula, new.ss, new.salud, new.nombre, new.apellido,new.email,new.pass,new.direccion,new.salario,new.comision,new.telefono,now(),new.cargo,new.departamento,"ACTUALIZADO NEW");
	END;


@

DELIMITER 

#-----------------------------------------------------------------------------------------------------------------------------------------

## FUNCIONES

delimiter $

CREATE FUNCTION CALCULAR_IMPORTE(PAGO DOUBLE) RETURNS DOUBLE 
BEGIN 
	RETURN pago * 0.14;
END $ 


delimiter ;

delimiter $

CREATE FUNCTION CALCULAR_SALUD(SALARIO DOUBLE) RETURNS DOUBLE BEGIN  
	RETURN salario * 0.04;
END $ 
delimiter ;

#-----------------------------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------------------------

## PROCEDURE

delimiter $

CREATE PROCEDURE INSERTAR_CLIENTE(IN CEDULA INT, IN 
NOMBRE VARCHAR(45), IN APELLIDOS VARCHAR(45), IN DIRECCION 
VARCHAR(45), IN EMAIL VARCHAR(45), IN PASS VARCHAR
(45), IN CLAVE VARCHAR(45), IN IMAGEN VARCHAR(45), 
IN CP VARCHAR(45), IN LOCALIDAD VARCHAR(45), IN TELEFONO 
VARCHAR(45)) 
BEGIN
	INSERT INTO Cliente
	values (
	        cedula,
	        NOMBRE,
	        APELLIDOS,
	        DIRECCION,
	        EMAIL,
	        aes_encrypt(PASS, CLAVE),
	        IMAGEN,
	        CP,
	        LOCALIDAD,
	        TELEFONO
	    );
	end $ 


delimiter ;

delimiter $

CREATE PROCEDURE INSERTAR_DEPARTAMENTO(IN NOMBRE VARCHAR
(45), IN EMAIL VARCHAR(45), IN CEDULA_JEFE INT) BEGIN  
	INSERT INTO Departamento values (NOMBRE, EMAIL, CEDULA_JEFE);
	end $ 


delimiter ;

delimiter $

CREATE PROCEDURE INSERTAR_DISEÑO(IN TAMAÑODISEÑO DOUBLE, IN FORMATO VARCHAR(45)) 
BEGIN  
	INSERT INTO Diseño values (null, tamañoDiseño, formato);
end $ 


delimiter ;

delimiter $

CREATE PROCEDURE INSERTAR_EMPLEADO(CEDULA INT, IN SS 
VARCHAR(45), IN NOMBRE VARCHAR(45), IN APELLIDO VARCHAR
(45), IN EMAIL VARCHAR(45), IN PASS VARCHAR(45), IN 
CLAVE VARCHAR(45), IN DIRECCION VARCHAR(45), IN SALARIO 
DOUBLE, IN COMISION DOUBLE, IN TELEFONO VARCHAR(45
), IN CARGO VARCHAR(45), IN DEPARTAMENTO VARCHAR(45
)) BEGIN
    INSERT INTO Empleado
	values (
	        CEDULA,
	        SS,
	        calcular_salud(SALARIO),
	        NOMBRE,
	        APELLIDO,
	        EMAIL,
	        aes_encrypt(PASS, CLAVE),
	        DIRECCION,
	        SALARIO,
	        COMISION,
	        TELEFONO,
	        CARGO,
	        DEPARTAMENTO
	    );
	end $ 


delimiter ;

delimiter $

CREATE PROCEDURE INSERTAR_FACTURA(IN NOMBREP VARCHAR
(45), IN PAGO VARCHAR(45), IN ENVIO VARCHAR(45), IN 
CEDULA_CLIENTE INT, CANTIDAD INT) 
BEGIN  
	DECLARE precio_producto DOUBLE;
	DECLARE idProducto INT;
    DECLARE PAGO INT; 
    SET PAGO = precio_producto * CANTIDAD ;
	SELECT id INTO idProducto FROM producto WHERE nombre = nombreP ;
	SELECT
	    precio INTO precio_producto
	FROM producto
	WHERE nombre = nombreP;
	INSERT INTO Factura
	values (
	        null,
	        pago,
	        calcular_importe(precio_producto),
	        envio,
	        now(),
	        idProducto,
	        cedula_cliente
	    );
	end $ 


delimiter ;

delimiter $

CREATE PROCEDURE INSERTAR_PRODUCTO(IN NOMBRE VARCHAR
(45), IN IMAGEN VARCHAR(45), IN PRECIO DOUBLE, IN 
DESCRIPCION VARCHAR(45), IN IMPRESION VARCHAR(45), 
IN ACABADO VARCHAR(45), IN TIPOPAPEL VARCHAR(45), 
IN TAMAÑO DOUBLE) 
BEGIN 
	INSERT INTO Producto
	values (
	        null,
	        nombre,
	        imagen,
	        precio,
	        descripcion,
	        impresion,
	        acabado,
	        tipoPapel,
	        tamaño
	    );
	end $ 

delimiter ;

CALL
    INSERTAR_CLIENTE(
        987654321,
        'María',
        'Gómez',
        'Avenida 456',
        'maria@gmail.com',
        'otroPassword',
        'otraClave',
        'imagen2.jpg',
        'CP456',
        'Ciudad B',
        '9876543210'
    );

CALL
    INSERTAR_CLIENTE(
        123456789,
        'Juan',
        'Pérez',
        'Calle 123',
        'juan@gmail.com',
        'miPassword',
        'miClave',
        'imagen1.jpg',
        'CP123',
        'Ciudad A',
        '1234567890'
    );

CALL
    INSERTAR_CLIENTE(
        111222333,
        'Ana',
        'López',
        'Calle Principal',
        'ana@gmail.com',
        'claveAna',
        'miClave',
        'imagen3.jpg',
        'CP789',
        'Ciudad C',
        '555111222'
    );

CALL
    INSERTAR_CLIENTE(
        444555666,
        'Pedro',
        'Ramírez',
        'Avenida Secundaria',
        'pedro@gmail.com',
        'clavePedro',
        'otraClave',
        'imagen4.jpg',
        'CP456',
        'Ciudad D',
        '999888777'
    );

CALL
    INSERTAR_CLIENTE(
        777888999,
        'Laura',
        'Martínez',
        'Calle 789',
        'laura@gmail.com',
        'claveLaura',
        'miClave',
        'imagen5.jpg',
        'CP123',
        'Ciudad E',
        '333222111'
    );

CALL
    INSERTAR_CLIENTE(
        123987456,
        'Carlos',
        'García',
        'Avenida Principal',
        'carlos@gmail.com',
        'claveCarlos',
        'otraClave',
        'imagen6.jpg',
        'CP789',
        'Ciudad F',
        '666555444'
    );

CALL
    INSERTAR_CLIENTE(
        555444333,
        'Sofía',
        'Hernández',
        'Calle 456',
        'sofia@gmail.com',
        'claveSofia',
        'miClave',
        'imagen7.jpg',
        'CP456',
        'Ciudad G',
        '111000999'
    );

CALL
    INSERTAR_CLIENTE(
        888777666,
        'Miguel',
        'Sánchez',
        'Avenida 789',
        'miguel@gmail.com',
        'claveMiguel',
        'otraClave',
        'imagen8.jpg',
        'CP123',
        'Ciudad H',
        '444333222'
    );

CALL
    INSERTAR_CLIENTE(
        999111222,
        'Gabriela',
        'Díaz',
        'Calle Secundaria',
        'gabriela@gmail.com',
        'claveGabriela',
        'miClave',
        'imagen9.jpg',
        'CP789',
        'Ciudad I',
        '777666555'
    );

CALL
    INSERTAR_CLIENTE(
        222333444,
        'Héctor',
        'Fernández',
        'Avenida 456',
        'hector@gmail.com',
        'claveHector',
        'otraClave',
        'imagen10.jpg',
        'CP456',
        'Ciudad J',
        '222333444'
    );

CALL
    INSERTAR_EMPLEADO(
        123456789,
        '111-22-3333',
        'Juan',
        'Pérez',
        'juan@gmail.com',
        'miPassword',
        'miClave',
        'Calle Principal',
        50000,
        0.05,
        '555111222',
        'Analista',
        'Ventas'
    );

CALL
    INSERTAR_EMPLEADO(
        987654321,
        '444-55-6666',
        'María',
        'Gómez',
        'maria@gmail.com',
        'otroPassword',
        'otraClave',
        'Avenida Secundaria',
        70000,
        0.07,
        '999888777',
        'JEFE DEPARTAMENTO',
        'Ventas'
    );

CALL
    INSERTAR_EMPLEADO(
        111222333,
        '555-44-3333',
        'Luisa',
        'Hernández',
        'luisa@gmail.com',
        'claveluisa',
        'miClave',
        'Calle 456',
        55000,
        0.05,
        '111000999',
        'Analista de Datos',
        'Tecnología'
    );

CALL
    INSERTAR_EMPLEADO(
        888777666,
        '888-77-6666',
        'Miguel',
        'Sánchez',
        'miguel@gmail.com',
        'claveMiguel',
        'otraClave',
        'Avenida 789',
        75000,
        0.07,
        '444333222',
        'JEFE DEPARTAMENTO',
        'Diseño'
    );

CALL
    INSERTAR_EMPLEADO(
        999111222,
        '999-11-2222',
        'Gabriela',
        'Díaz',
        'gabriela@gmail.com',
        'claveGabriela',
        'miClave',
        'Calle Secundaria',
        90000,
        0.09,
        '777666555',
        'JEFE DEPARTAMENTO',
        'Finanzas'
    );

CALL
    INSERTAR_EMPLEADO(
        222333444,
        '222-33-4444',
        'Héctor',
        'Fernández',
        'hector@gmail.com',
        'claveHector',
        'otraClave',
        'Avenida 456',
        65000,
        0.06,
        '222333444',
        'JEFE DEPARTAMENTO',
        'Recursos Humanos'
    );

CALL
    INSERTAR_EMPLEADO(
        123987456,
        '123-98-7456',
        'Carlos',
        'García',
        'carlos@gmail.com',
        'claveCarlos',
        'otraClave',
        'Avenida Principal',
        80000,
        0.08,
        '666555444',
        'JEFE DEPARTAMENTO',
        'Proyectos'
    );

CALL
    INSERTAR_EMPLEADO(
        555444333,
        '555-44-3333',
        'Sofía',
        'Hernández',
        'sofia@gmail.com',
        'claveSofia',
        'miClave',
        'Calle 456',
        55000,
        0.05,
        '111000888',
        'Analista de Datos',
        'Tecnología'
    );

CALL
    INSERTAR_EMPLEADO(
        777888999,
        '777-88-9999',
        'Laura',
        'Martínez',
        'laura@gmail.com',
        'claveLaura',
        'miClave',
        'Calle 789',
        60000,
        0.06,
        '333222111',
        'Desarrollador',
        'Tecnología'
    );

CALL
    INSERTAR_EMPLEADO(
        888899922,
        '555-44-3333',
        'Sofía',
        'Hernández',
        'sofia2@gmail.com',
        'claveSofi2a',
        'Clave',
        'Calle 456',
        55000,
        0.05,
        '111007999',
        'JEFE DEPARTAMENTO',
        'Tecnología'
    );

CALL INSERTAR_DISEÑO(20.05, "GRANDE");

CALL INSERTAR_DISEÑO(5.10, "PEQUEÑO");

CALL INSERTAR_DISEÑO(15.12, "MEDIANO");

CALL INSERTAR_DISEÑO(19.12, "GRANDE");

CALL INSERTAR_DISEÑO(13.12, "MEDIANO");

CALL INSERTAR_DISEÑO(14.82, "MEDIANO");

CALL INSERTAR_DISEÑO(21.12, "GRANDE");

CALL INSERTAR_DISEÑO(14.98, "MEDIANO");

CALL INSERTAR_DISEÑO(25.52, "GRANDE");

CALL INSERTAR_DISEÑO(2.12, "PEQUEÑO");

CALL
    INSERTAR_DEPARTAMENTO(
        "TECNOLOGIA",
        "TECNOLOGIA@empresa.com",
        888899922
    );

CALL
    INSERTAR_DEPARTAMENTO(
        "VENTAS",
        "VENTAS@empresa.com",
        987654321
    );

CALL
    INSERTAR_DEPARTAMENTO(
        "DISEÑO",
        "DISEÑO@empresa.com",
        888777666
    );

CALL
    INSERTAR_DEPARTAMENTO(
        "FINANZAS",
        "FINANZAS@empresa.com",
        999111222
    );

CALL
    INSERTAR_DEPARTAMENTO(
        "RECURSOS HUMANOS",
        "RECURSOSHUMANOS@empresa.com",
        222333444
    );

CALL
    INSERTAR_DEPARTAMENTO(
        "PROYECTOS",
        "PROYECTOS@empresa.com",
        123987456
    );

## (IN nombre VARCHAR(45), IN imagen VARCHAR(45), IN precio double, IN descripcion VARCHAR(45),

## IN impresion VARCHAR(45), IN acabado VARCHAR(45), IN tipoPapel VARCHAR(45), IN tamaño double) BEGIN

CALL INSERTAR_PRODUCTO("PRODUCTO 1", "img1.png", 111.11, "DESCRIPCION1", "IMPRESION1", "ACABADO1", "PAPEL1", 10.1);
CALL INSERTAR_PRODUCTO("PRODUCTO 2", "img2.png", 222.22, "DESCRIPCION2", "IMPRESION2", "ACABADO2", "PAPEL2", 20.1);        
CALL INSERTAR_PRODUCTO("PRODUCTO 3", "img3.png", 333.33, "DESCRIPCION3", "IMPRESION3", "ACABADO3", "PAPEL3", 30.1);
CALL INSERTAR_PRODUCTO("PRODUCTO 4", "img4.png", 444.44, "DESCRIPCION4", "IMPRESION4", "ACABADO4", "PAPEL4", 40.1);
CALL INSERTAR_PRODUCTO("PRODUCTO 5", "img5.png", 555.55, "DESCRIPCION5", "IMPRESION5", "ACABADO5", "PAPEL5", 50.1);
CALL INSERTAR_PRODUCTO("PRODUCTO 6", "img6.png", 666.66, "DESCRIPCION6", "IMPRESION6", "ACABADO6", "PAPEL6", 60.1);
CALL INSERTAR_PRODUCTO("PRODUCTO 7", "img7.png", 777.77, "DESCRIPCION7", "IMPRESION7", "ACABADO7", "PAPEL7", 70.1);
CALL INSERTAR_PRODUCTO("PRODUCTO 8", "img8.png", 888.88, "DESCRIPCION7", "IMPRESION8", "ACABADO8", "PAPEL8", 80.1);
CALL INSERTAR_PRODUCTO("PRODUCTO 9", "img9.png", 999.99, "DESCRIPCION9", "IMPRESION9", "ACABADO9", "PAPEL9", 90.1);
CALL INSERTAR_PRODUCTO("PRODUCTO 10", "img10.png", 1010.10, "DESCRIPCION10", "IMPRESION10", "ACABADO10", "PAPEL10", 1010.1);
## INSERTAR_FACTURA(IN nombreP VARCHAR(45), IN pago VARCHAR(45), IN envio VARCHAR(45), IN cedula_cliente INT) BEGIN

CALL INSERTAR_FACTURA("PRODUCTO 1", "TARJETA", "MI CASA",987654321, 2);

CALL INSERTAR_FACTURA("PRODUCTO 2", "TARJETA", "MI CASA",123456789,1 );

CALL INSERTAR_FACTURA("PRODUCTO 3", "TARJETA", "MI CASA",111222333,2 );

CALL INSERTAR_FACTURA("PRODUCTO 4", "TARJETA", "MI CASA",444555666,4 );

CALL INSERTAR_FACTURA("PRODUCTO 5", "TARJETA", "MI CASA",777888999,5 );

CALL INSERTAR_FACTURA("PRODUCTO 6", "TARJETA", "MI CASA",123987456,6 );

CALL INSERTAR_FACTURA("PRODUCTO 7", "TARJETA", "MI CASA",555444333,7 );

CALL INSERTAR_FACTURA("PRODUCTO 8", "TARJETA", "MI CASA",888777666,2 );

CALL INSERTAR_FACTURA("PRODUCTO 9", "TARJETA", "MI CASA",999111222,1 );

CALL INSERTAR_FACTURA("PRODUCTO 10", "TARJETA", "MI CASA",222333444, 2 );

CALL INSERTAR_FACTURA("PRODUCTO 10", "TARJETA", "MI CASA",999111222, 99 );
## VISTAS

CREATE VIEW vista_usuario AS
SELECT
    cedula,
    nombre,
    apellidos,
    email,
    telefono
FROM cliente
WHERE localidad = "Ciudad B";

CREATE VIEW
    vista_jefe_departamento AS
SELECT
    Emp.cedula,
    Emp.nombre,
    Emp.apellido,
    Emp.email,
    Emp.telefono,
    Emp.departamento,
    Dep.nombreDepartamento
FROM Empleado as Emp
    JOIN Departamento as Dep
WHERE
    Emp.cargo = "JEFE DEPARTAMENTO";

CREATE VIEW vista_PRODUCTO AS
SELECT
    p.id,
    p.nombre,
    COUNT(f.idProducto) AS cantidad
FROM producto as p
    JOIN factura as f ON p.id = f.idProducto
GROUP BY p.nombre
ORDER BY cantidad;

#drop VIEW vista_jefe_departamento ;

SELECT * FROM vista_usuario;
SELECT * FROM vista_PRODUCTO;
SELECT * FROM vista_jefe_departamento;


UPDATE empleado SET nombre = "CAMBIO" WHERE cedula = 123456789;
DELETE FROM empleado WHERE cedula = 123456789;

/**
 RELACIONAR EMPLEADO  Y DEPARTAMENTO
 COLOCAR EL PUESTO DEL EMPLEADO
 IMPORTE TOTAL A PAGAR CONTANDO IVA
 AGREGAR CEDULA CLIENTE
 MODIFICAR CUANDO SE REPITA PRODUCTO CLIENTE
 */