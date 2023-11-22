CREATE DATABASE db_parcial;

USE db_parcial;

/*
 * TABLA PARA INGRESAR A TODAS LAS PERSONAS, SIN IMPORTAR QUE CARGO TENGAN
 */

CREATE TABLE
    PERSONA(
        CC INT PRIMARY KEY,
        NOMBRE VARCHAR(25),
        APELLIDOS VARCHAR (25),
        TELEFONOS VARCHAR(25) UNIQUE,
        CORREO_PERSONAL VARCHAR (25) UNIQUE,
        DIRECCION VARCHAR(30),
        BARRIO VARCHAR(15)
    );

/**
 * SECCION PARA QUE TIPO DE PERSONA ES (QUE CARGO O QUE ROL TIENE)
 */

CREATE TABLE
    ALUMNO(
        CODIGO INT PRIMARY KEY,
        ESTADO SET(
            "NO MATRICULADO",
            "MATRICULADO"
        ),
        SEMESTRE INT,
        SEDE SET("TAGASTE", "SUBA")
    );

CREATE TABLE
    EMPLEADO (
        CEDULA INT PRIMARY KEY,
        SUELDO_BASE DOUBLE,
        HORAS_TRABAJADAS INT,
        NO_SEGURO INT
    );

/**
 * TIPOS DE EMPLEADOS
 */

CREATE TABLE
    ADMINISTRATIVO(
        CEDULA INT PRIMARY KEY,
        CARGO VARCHAR(25),
        DEPARTAMENTO VARCHAR(25)
    );

CREATE TABLE
    MAESTRO(
        ID_MAESTRO INT PRIMARY KEY,
        AREA_DOCENSIA VARCHAR(25)
    );

/**
 * TABLA PARA "CREAR UNA CUENTA" PARA LAS PERSONAS DIRECTAMENTE RELACIONADAS CON LA INSTITUCION
 */

CREATE TABLE
    USUARIO(
        USUARIO VARCHAR(50) PRIMARY KEY,
        TIPO_USUARIO SET(
            "MAESTRO",
            "ADMINISTRATIVO",
            "ALUMNO"
        ),
        PASSW VARCHAR(45)
    );

/**
 * SECCION ENFOCADA PARA LA PARTE DE GESTION DE LA INSTITUCION, EXLUYENDO A LAS PERSONAS
 */

CREATE TABLE
    CLASE (
        ID_CLASE INT PRIMARY KEY,
        NOMBRE VARCHAR(45),
        HORA_P_SEMANA INT,
        JORNADA SET ("DIURNA", "NOCTURNA"),
        DESCRIPCION VARCHAR(60),
        AULA VARCHAR(15),
        AÑO VARCHAR(2)
    );

CREATE TABLE
    CARRERA (
        ID_CARRERA INT PRIMARY KEY,
        NOMBRE VARCHAR(40),
        FACULTAD VARCHAR(50),
        DECANO VARCHAR(50)
    );

CREATE TABLE
    SEGURO (
        CODIGO_REGURO INT PRIMARY KEY,
        NOMBRE_SEGURO VARCHAR (25),
        NIVEL_RIESGO SET ("1", "2", "3", "4", "5"),
        CEDULA_EMPLEADO INT UNIQUE

);

/**
 * CREAR TABLA PARA LAS PERSONAS QUE SON RESPONSABLES DE ALUMNO. AGREGAR TBL-DB Y ASI
 */

## RELACIONES

ALTER TABLE MAESTRO ADD COLUMN NOMBRE VARCHAR (25) UNIQUE;

#Adicionar un campo Cedula de tabla alumno.

ALTER TABLE ALUMNO ADD COLUMN CEDULA INT;

#

ALTER TABLE ADMINISTRATIVO ADD COLUMN NOMBRE VARCHAR(50) UNIQUE;

ALTER TABLE MAESTRO ADD COLUMN CEDULA INT;

ALTER TABLE ALUMNO ADD COLUMN USUARIO VARCHAR (50) UNIQUE;

ALTER TABLE ADMINISTRATIVO ADD COLUMN USUARIO VARCHAR (50) UNIQUE;

ALTER TABLE MAESTRO ADD COLUMN USUARIO VARCHAR (50) UNIQUE;

ALTER TABLE CLASE ADD COLUMN PROGRAMA VARCHAR (40);

ALTER TABLE CLASE ADD COLUMN TUTOR VARCHAR (50);

#Adicionar y Cambiar el nombre del campo fecha de la tabla alumno.
ALTER TABLE PERSONA ADD COLUMN NACIMIENTO DATE;
ALTER TABLE PERSONA CHANGE NACIMIENTO FECHA_NACIMIENTO DATE;


#ALTER TABLE USUARIO MODIFY COLUMN USUARIO VARCHAR (15) UNIQUE;

ALTER TABLE CARRERA MODIFY NOMBRE VARCHAR(40) UNIQUE;

ALTER TABLE ALUMNO ADD FOREIGN KEY (CEDULA) REFERENCES PERSONA (CC);

ALTER TABLE EMPLEADO
ADD
    FOREIGN KEY (CEDULA) REFERENCES PERSONA (CC);

ALTER TABLE ADMINISTRATIVO
ADD
    FOREIGN KEY (CEDULA) REFERENCES EMPLEADO (CEDULA);

ALTER TABLE MAESTRO
ADD
    FOREIGN KEY (CEDULA) REFERENCES EMPLEADO (CEDULA);

ALTER TABLE ALUMNO
ADD
    FOREIGN KEY (USUARIO) REFERENCES USUARIO (USUARIO);

ALTER TABLE ADMINISTRATIVO
ADD
    FOREIGN KEY (USUARIO) REFERENCES USUARIO (USUARIO);

ALTER TABLE MAESTRO
ADD
    FOREIGN KEY (USUARIO) REFERENCES USUARIO (USUARIO);

ALTER TABLE CLASE
ADD
    FOREIGN KEY (PROGRAMA) REFERENCES CARRERA (NOMBRE);

ALTER TABLE CLASE
ADD
    FOREIGN KEY (TUTOR) REFERENCES MAESTRO (NOMBRE);

ALTER TABLE SEGURO
ADD
    FOREIGN KEY (CEDULA_EMPLEADO) REFERENCES PERSONA (CC);

ALTER TABLE CARRERA
ADD
    FOREIGN KEY (DECANO) REFERENCES ADMINISTRATIVO (NOMBRE);

ALTER TABLE EMPLEADO
ADD
    FOREIGN KEY (NO_SEGURO) REFERENCES SEGURO (CODIGO_REGURO);

#-----------------------


/**
 * REPLACE works exactly like INSERT, except that if an old row in the table has the same value as a new row for a PRIMARY KEY or a UNIQUE index,
 * the old row is deleted before the new row is inserted.
 */

# Cambiar el nombre del campo dirección de la tabla dirección y también en tipo de dato INT (20). ??????

## ALTER TABLE PERSONA CHANGE DIRECCION ADDRES INT(20);
ALTER TABLE PERSONA CHANGE DIRECCION ADDRESS VARCHAR(20);

#Cambiar de nombre a dos tablas.
RENAME TABLE PERSONA TO PERSONAS;
RENAME TABLE ALUMNO TO ALUMNOS;

#Realizar tres Triggers para insertar, modificar y eliminar en la tabla usuario, clase y alumno.

/**
 * CREAR LAS TABLAS DE SEGURIDAD
 */

CREATE TABLE
    TB_SEGURIDAD_USUARIO(
        USUARIO_C VARCHAR(50),
        TIPO_USUARIO_C SET(
            "MAESTRO",
            "ADMINISTRATIVO",
            "ALUMNO"
        ),
        PASSW_C VARCHAR(50),
        FECHA DATETIME,
        ACCION VARCHAR(20)

);

CREATE TABLE
    TB_SEGURIDAD_ALUMNO(
        CODIGO_C INT,
        ESTADO_C VARCHAR(20),
        SEMESTRE_C INT,
        SEDE_C VARCHAR(10),
        CEDULA_C INT,
        FECHA DATETIME,
        USUARIO_C VARCHAR(15),
        ACCION VARCHAR(20)
    );

CREATE TABLE
    TB_SEGURIDAD_CLASE(
        ID_CLASE_C int(11),
        NOMBRE_C varchar(20),
        HORA_P_SEMANA_C int(11),
        JORNADA_C set('DIURNA', 'NOCTURNA'),
        DESCRIPCION_C varchar(45),
        AULA_c varchar(15),
        AÑO_C datetime,
        PROGRAMA_C varchar(40),
        FECHA DATETIME,
        TUTOR_C varchar(20),
        ACCION VARCHAR(20)

);
# Realizar tres Triggers para insertar, modificar y eliminar en la tabla usuario, clase y alumno.


# USUARIO
## INSERT
DELIMITER //
CREATE TRIGGER tr_insert_usuario AFTER INSERT ON USUARIO FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_usuario VALUES (new.USUARIO, new.TIPO_USUARIO, new.PASSW, now(), "INSERTADO");
END //
DELIMITER ;


## UPDATE
DELIMITER @
CREATE TRIGGER tr_update_old_usuario AFTER UPDATE ON USUARIO FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_usuario VALUES (old.USUARIO, old.TIPO_USUARIO, old.PASSW, now(), "ACTUALIZADO OLD ");
END@
DELIMITER ;

DELIMITER @
CREATE TRIGGER tr_update_new_usuario BEFORE UPDATE ON USUARIO FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_usuario VALUES ( new.USUARIO, new.TIPO_USUARIO, new.PASSW, now(), "ACTUALIZADO NEW");
END@
DELIMITER ;



## DELETE
DELIMITER @
CREATE TRIGGER tr_delete_usuario AFTER DELETE ON USUARIO FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_usuario VALUES ( old.USUARIO, old.TIPO_USUARIO, old.PASSW, now(), "ELIMINADO");
END @
DELIMITER ;





# ALUMNO
## INSERT
DELIMITER //
CREATE TRIGGER tr_insert_alumno AFTER INSERT ON ALUMNOS FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_alumno VALUES (new.codigo, new.estado, new.semestre, new.sede,new.cedula, new.usuario, now(), "INSERTADO");
END //
DELIMITER ;


## UPDATE
DELIMITER //
CREATE TRIGGER tr_update_old_alumno AFTER UPDATE ON ALUMNOS FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_alumno VALUES (old.codigo, old.estado, old.semestre, old.sede, old.cedula, old.usuario, now(), "ACTUALIZADO OLD");
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tr_update_new_alumno BEFORE UPDATE ON ALUMNOS FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_alumno VALUES (new.codigo, new.estado, new.semestre, new.sede,new.cedula, new.usuario, now(), "ACTUALIZADO OLD");
END //
DELIMITER ;


## DELETE
DELIMITER //
CREATE TRIGGER tr_delete_alumno AFTER DELETE ON ALUMNOS FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_alumno VALUES (old.codigo, old.estado, old.semestre, old.sede, old.cedula, old.usuario, now(), "ELIMINADO");
END //
DELIMITER ;


# CLASE
## INSERT
DELIMITER //
CREATE TRIGGER tr_insert_clase BEFORE INSERT ON CLASE FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_clase VALUES (new.id_clase, new.nombre, new.hora_p_semana, new.jornada, new.descripcion, new.aula, new.año, new.programa, new.tutor, now(), "INSERTAFO");
END //
DELIMITER ;

## UPDATE
DELIMITER //
CREATE TRIGGER tr_update_old_clase BEFORE UPDATE ON CLASE FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_clase VALUES (old.id_clase, old.nombre, old.hora_p_semana, old.jornada, old.descripcion, old.aula, old.año, old.programa, old.tutor, now(), "INSERTAFO");
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tr_update_new_clase BEFORE UPDATE ON CLASE FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_clase VALUES (new.id_clase, new.nombre, new.hora_p_semana, new.jornada, new.descripcion, new.aula, new.año, new.programa, new.tutor, now(), "INSERTAFO");
END //
DELIMITER ;

## UPDATE
DELIMITER //
CREATE TRIGGER tr_delete_clase AFTER DELETE ON CLASE FOR EACH ROW
BEGIN
INSERT INTO tb_seguridad_clase VALUES (old.id_clase, old.nombre, old.hora_p_semana, old.jornada, old.descripcion, old.aula, old.año, old.programa, old.tutor, now(), "INSERTAFO");
END //
DELIMITER ;


/**/
/*
 * INSERT
 */






INSERT INTO PERSONAS (CC, NOMBRE, APELLIDOS, TELEFONOS, CORREO_PERSONAL, ADDRESS, BARRIO, FECHA_NACIMIENTO)
VALUES
(1001, 'Ana', 'García López', '555-123-4567', 'ana@gmail.com', '123 Calle Principal', 'Centro', '1990-05-15'),
(1002, 'Carlos', 'Martínez Pérez', '555-234-5678', 'carlos@gmail.com', '456 Avenida Central', 'Zona Norte', '1985-08-20'),
(1003, 'María', 'Fernández Rodríguez', '555-345-6789', 'maria@gmail.com', '789 Calle Secundaria', 'Barrio Sur', '1992-02-10'),
(1004, 'Juan', 'López González', '555-456-7890', 'juan@gmail.com', '101 Calle Residencial', 'Barrio Oeste', '1988-11-25'),
(1005, 'Sofía', 'Hernández Sánchez', '555-567-8901', 'sofia@gmail.com', '202 Calle Tranquila', 'Centro', '1995-04-30'),
(1006, 'Diego', 'Gómez Ruiz', '555-678-9012', 'diego@gmail.com', '303 Avenida Principal', 'Zona Norte', '1987-07-05'),
(1007, 'Laura', 'Díaz Romero', '555-789-0123', 'laura@gmail.com', '404 Calle Comercial', 'Barrio Este', '1993-09-12'),
(1008, 'Pedro', 'Pérez Martínez', '555-890-1234', 'pedro@gmail.com', '505 Calle Principal', 'Barrio Sur', '1986-03-18'),
(1009, 'Isabel', 'González López', '555-901-2345', 'isabel@gmail.com', '606 Avenida Central', 'Zona Oeste', '1991-06-22'),
(1010, 'Alejandro', 'Sánchez Fernández', '555-012-3456', 'alejandro@gmail.com', '707 Calle Residencial', 'Centro', '1989-10-08'),
(1011, 'Carmen', 'López Sánchez', '555-123-4560', 'carmen@gmail.com', '808 Calle Principal', 'Zona Norte', '1994-12-15'),
(1012, 'Daniel', 'Martínez Rodríguez', '555-234-5608', 'daniel@gmail.com', '909 Avenida Central', 'Barrio Este', '1984-01-30'),
(1013, 'Luis', 'Fernández Pérez', '555-345-6785', 'luis@gmail.com', '1010 Calle Comercial', 'Barrio Oeste', '1997-03-05'),
(1014, 'Elena', 'García Martínez', '555-456-7894', 'elena@gmail.com', '1111 Calle Tranquila', 'Centro', '1983-08-10'),
(1015, 'Héctor', 'Hernández Sánchez', '555-567-8903', 'hector@gmail.com', '1212 Avenida Principal', 'Zona Norte', '1996-11-20'),
(1016, 'Marta', 'Gómez Romero', '555-678-9017', 'marta@gmail.com', '1313 Calle Residencial', 'Barrio Este', '1982-02-25'),
(1017, 'Javier', 'Díaz Martínez', '555-789-0127', 'javier@gmail.com', '1414 Calle Principal', 'Barrio Sur', '1998-05-02'),
(1018, 'Raquel', 'Pérez Ruiz', '555-890-1238', 'raquel@gmail.com', '1515 Avenida Central', 'Centro', '1981-09-14'),
(1019, 'Andrés', 'González Sánchez', '555-901-2349', 'andres@gmail.com', '1616 Calle Comercial', 'Zona Norte', '1999-01-10'),
(1020, 'Natalia', 'Sánchez López', '555-012-3450', 'natalia@gmail.com', '1717 Calle Tranquila', 'Barrio Este', '1980-04-05'),
(1021, 'Pablo', 'López Rodríguez', '555-123-4561', 'pablo@gmail.com', '1818 Calle Principal', 'Barrio Oeste', '2000-07-20'),
(1022, 'Lucía', 'Martínez Pérez', '555-234-5672', 'lucia@gmail.com', '1919 Avenida Central', 'Centro', '1979-10-01'),
(1023, 'Eduardo', 'Fernández González', '555-345-6783', 'eduardo@gmail.com', '2020 Calle Residencial', 'Zona Norte', '2001-12-12'),
(1024, 'Beatriz', 'Gómez Sánchez', '555-456-7897', 'beatriz@gmail.com', '2121 Calle Principal', 'Barrio Este', '1978-03-25'),
(1025, 'Roberto', 'Hernández López', '555-567-8905', 'roberto@gmail.com', '2222 Avenida Central', 'Barrio Sur', '2002-05-30'),
(1026, 'Ana', 'López Martínez', '555-678-9016', 'ana2@gmail.com', '2323 Calle Comercial', 'Centro', '1977-08-14'),
(1027, 'Carlos', 'García Sánchez', '555-789-0126', 'carlos2@gmail.com', '2424 Calle Tranquila', 'Zona Norte', '2003-01-05'),
(1028, 'María', 'Martínez López', '555-898-1238', 'maria2@gmail.com', '2525 Calle Principal', 'Barrio Este', '1976-04-20'),
(1029, 'Juan', 'Gómez Pérez', '555-901-2389', 'juan2@gmail.com', '2626 Avenida Central', 'Barrio Oeste', '2004-06-02'),
(1030, 'Sofía', 'Hernández Ruiz', '555-012-3477', 'sofia2@gmail.com', '2727 Calle Residencial', 'Centro', '1980-01-15');







# USERS 
INSERT INTO USUARIO (USUARIO, TIPO_USUARIO, PASSW)
VALUES
('anagarcia', 'ALUMNO', 'password123'), #ALUMNOS
('carlosmartinez', 'ALUMNO', 'abc123'),
('mariafernandez', 'ALUMNO', 'qwerty'),
('juanlopez', 'ALUMNO', '123456'),
('sofiahernandez', 'ALUMNO', 'pass1234'),
('diegogomez', 'ALUMNO', 'password'),
('lauradiaz', 'ALUMNO', 'securepass'),
('pedroperez', 'ALUMNO', 'alumno123'),
('isabelgonzalez', 'ALUMNO', 'student'),
('alejandrosanchez', 'ALUMNO', 'welcome123'), 
('carmenlopez', 'MAESTRO', 'xyz789'), #MAESTRO
('danielmartinez', 'MAESTRO', 'mypass123'),
('luisfernandez', 'MAESTRO', 'newpass'),
('elenagarcia', 'MAESTRO', 'test123'),
('hectorhernandez', 'MAESTRO', 'p@ssw0rd'),
('martagomez', 'MAESTRO', 'secure123'),
('javierdiaz', 'MAESTRO', 'mypassword'),
('raquelperez', 'MAESTRO', 'pass123'),
('andresgonzales', 'MAESTRO', 'daniel456'),
('nataliasanchez', 'MAESTRO', 'welcome456'),
('pablolopez', 'ADMINISTRATIVO', 'securepass456'), #ADMIN
('luciamartinez', 'ADMINISTRATIVO', 'test456'),
('eduardofernandez', 'ADMINISTRATIVO', 'p@ssword'),
('beatrizgomez', 'ADMINISTRATIVO', 'secure789'),
('robertohernandez', 'ADMINISTRATIVO', 'mypass789'),
('analopez', 'ADMINISTRATIVO', 'secure7890'),
('carlosgarcia', 'ADMINISTRATIVO', 'test7890'),
('mariamartinez', 'ADMINISTRATIVO', 'mypassword'),
('juangomez', 'ADMINISTRATIVO', 'contra123'),
('sofiahernandez2', 'ADMINISTRATIVO', '123456789');


INSERT INTO ALUMNOS VALUES 
(57788, "MATRICULADO", 3, "SUBA", 1001, 'anagarcia'),
(48486, "MATRICULADO", 2, "TAGASTE", 1002, 'carlosmartinez'),
(61545,"MATRICULADO", 1, "SUBA", 1003, 'mariafernandez'),
(98541, "MATRICULADO", 4, "TAGASTE", 1004, 'juanlopez'),
(8645312, "MATRICULADO", 3, "SUBA", 1005, 'sofiahernandez'),
(45222, "MATRICULADO", 1, "SUBA", 1006, 'diegogomez'),
(984211, "MATRICULADO", 5, "SUBA", 1007, 'lauradiaz'),
(8765321, "MATRICULADO", 7, "TAGASTE", 1008, 'pedroperez'),
(784512, "NO MATRICULADO", 5, "TAGASTE", 1009, 'isabelgonzalez'),
(845100, "MATRICULADO", 2, "SUBA", 1010, 'alejandrosanchez');


/*ID_MAESTRO int(11) PK 
AREA_DOCENSIA varchar(25) 
NOMBRE varchar(25) 
CEDULA int(11) 
USUARIO varchar(15)*/

INSERT INTO SEGURO VALUES
(091010, "ZURA", "1", 1010 ), 
(091011, "SEGURO BOLIVAR", "1", 1011 ), 
(091012, "SEGURO BOLIVAR", "1", 1012 ), 
(091013, "SEGURO BOLIVAR", "1", 1013 ), 
(091014, "SEGURO BOLIVAR", "2", 1014 ), 
(091015, "SEGURO BOLIVAR", "2", 1015 ), 
(091016, "ZURA", "2", 1016 ), 
(091017, "ZURA", "2", 1017 ), 
(091018, "ZURA", "2", 1018 ), 
(091019, "LADELAESQUINA", "2", 1019 ), 
(091020, "LADELAESQUINA", "2", 1020 ), 
(091021, "LADELAESQUINA", "2", 1021 ), 
(091022, "LADELAESQUINA", "3", 1022 ), 
(091023, "LADELAESQUINA", "3", 1023 ), 
(091024, "LADELAESQUINA", "3", 1024 ), 
(091025, "ZURA", "4", 1025 ), 
(091026, "ZURA", "4", 1026 ), 
(091027, "ZURA", "4", 1027 ), 
(091028, "ZURA", "5", 1028 ), 
(091029, "ZURA", "5", 1029 ), 
(091030, "ZURA", "5", 1030 );


INSERT INTO EMPLEADO VALUES
(1010,1601000.0, 10, 091010 ), 
(1011,1601001.0, 10, 091011 ), 
(1012,1601002.0, 10, 091012 ), 
(1013,1601003.0, 10, 091013 ), 
(1014,1601004.0, 10, 091014 ), 
(1015,1601005.0, 10, 091015 ), 
(1016,1601006.0, 10, 091016 ), 
(1017,1601007.0, 10, 091017 ), 
(1018,1601008.0, 10, 091018 ), 
(1019,1601009.0, 10, 091019 ), 
(1020,1602000.0, 10, 091020 ), 
(1021,1602001.0, 10, 091021 ), 
(1022,1602002.0, 10, 091022 ), 
(1023,1602003.0, 10, 091023 ), 
(1024,1602004.0, 10, 091024 ), 
(1025,1602005.0, 10, 091025 ), 
(1026,1602006.0, 10, 091026 ), 
(1027,1602007.0, 10, 091027 ), 
(1028,1602008.0, 10, 091028 ), 
(1029,1602009.0, 10, 091029 ), 
(1030,1603000.0, 10, 091030 );




INSERT INTO MAESTRO VALUES
(1, "SOFTWARE", 'Carmen Lopez', 1011, "carmenlopez"),
(2, "GASTRONOMIA", "Daniel Martinez", 1012, 'danielmartinez'),
(3, "MECATRONICA", "LUIS FERNANDEZ", 1013, 'luisfernandez'),
(4, "GASTRONOMIA", "ELENA GARCIA", 1014, 'elenagarcia'),
(5, "LENGUAS", "HECTOR HERNANDEZ", 1015, 'hectorhernandez'),
(6, "CONTADURIA", "MARTA GOMEZ", 1016, 'martagomez'),
(7, "ARTES", "JAVIER DIAZ", 1017, 'javierdiaz'),
(8, "SOFTWARE", "RAQUEL PEREZ", 1018, 'raquelperez'),
(9, "GASTRONOMIA", "ANDRES GONZALES", 1019, 'andresgonzales'),
(10, "MATEMATICAS", "NATALIA SANCHEZ", 1020,'nataliasanchez');


INSERT INTO ADMINISTRATIVO VALUES
(1023, "BIBLIOTECA", "BIBLIOTECA", "Eduardo Fernandez", "eduardofernandez" ),
(1024, "DECANO", "FACULTAD", "Beatriz Gomez", "beatrizgomez" ), 
(1025, "PERSONAL LIMPIEZA", "ASEO", "Roberto Hernandez", "robertohernandez" ), 
(1026, "DECANO", "FACULTAD", "Ana Lopez", "analopez" ), 
(1027, "VENDEDOR CAFETERIA", "CAFETARIA", "Carlos Garcia", "carlosgarcia" ), 
(1028, "DECANO", "FACULTAD", "Maria Martinez", "mariamartinez" ), 
(1029, "DECANO", "FACULTAD", "Juan Gomez", "juangomez" ), 
(1030, "CELADOR", "SEGURIDAD", "Sofia Hernandez", "sofiahernandez2" );


INSERT INTO CARRERA VALUES 
(1, "TECNOLOGIA SOFTWARE", "INGENIERIA", "Beatriz Gomez"),
(2, "MECATRONICA", "INGENIERIA", "Ana Lopez"),
(3, "GASTRONOMIA", "ARTE COMUNICACION Y CULTURA", "Juan Gomez"),
(4, "CINE Y TELEVISION", "ARTE COMUNICACION Y CULTURA", "Maria Martinez");
/*
(1, "SOFTWARE", 'Carmen Lopez', 1011, "carmenlopez"),
(2, "GASTRONOMIA", "Daniel Martinez", 1012, 'danielmartinez'),
(3, "MECATRONICA", "LUIS FERNANDEZ", 1013, 'luisfernandez'),
(4, "GASTRONOMIA", "ELENA GARCIA", 1014, 'elenagarcia'),
(5, "LENGUAS", "HECTOR HERNANDEZ", 1015, 'hectorhernandez'),
(6, "CONTADURIA", "MARTA GOMEZ", 1016, 'martagomez'),
(7, "ARTES", "JAVIER DIAZ", 1017, 'javierdiaz'),
(8, "SOFTWARE", "RAQUEL PEREZ", 1018, 'raquelperez'),
(9, "GASTRONOMIA", "ANDRES GONZALES", 1019, 'andresgonzales'),
(10, "MATEMATICAS", "NATALIA SANCHEZ", 1020,'nataliasanchez');*/
INSERT INTO CLASE VALUES 
(1, "POO JAVA", 4, "DIURNA", "POGRMACION ORIENTADA OBJETOS EN JAVA", "214", 2, "TECNOLOGIA SOFTWARE", "Carmen Lopez" ),
(2, "INTRODUCCION A LA EMPANADA", 4, "NOCTURNA", "ORIGEN DE LA EMPANADA", "S-302" , 1, "GASTRONOMIA", "Daniel Martinez"),
(3, "FISICA 1", 8, "DIURNA", "FISICA BASICA", "102", 1, "MECATRONICA", 'LUIS FERNANDEZ'),
(4, "INTRODUCCION AL SANCOCHO", 4, "DIURNA", "ORIGEN DEL SANCOCHO", "S-314" , 1, "GASTRONOMIA", "ELENA GARCIA"),
(5, "INGLES 3", 6, "DIURNA", "INGLES B1", "S-217" , 3, "GASTRONOMIA", "HECTOR HERNANDEZ"),
(6, "PRECIO DE LA AREPA", 2, "NOCTURNA", "PRECIO POR AREPA DEPENDIENDO DEL CONTENIDO", "S-117" , 2, "GASTRONOMIA", "MARTA GOMEZ"),
(7, "CINE DEL MAÑANA", 5, "DIURNA", "EL FUTURO DEL CINE, SER O NO SER", "S-317" , 3, "CINE Y TELEVISION", "JAVIER DIAZ"),
(8, "BASES DE DATOS", 3, "DIURNA", "BASES DE DATOS RELACIONAL MYSQL", "317", 4,"TECNOLOGIA SOFTWARE", "RAQUEL PEREZ" ),
(9, "INTRODUCCION AL SANCOCHO", 4, "NOCTURNA", "ORIGEN DEL SANCOCHO", "S-314" , 1, "GASTRONOMIA", "ANDRES GONZALES"),
(10, "MATEMATICAS APLICADAS", 10, "DIURNA", "MATEMATICAS APLICADAS AL MUNDO", "104", 5, "MECATRONICA", 'NATALIA SANCHEZ');

#Remplazar tres registros.

UPDATE USUARIO SET TIPO_USUARIO = "ADMINISTRATIVO" WHERE USUARIO = "andresgonzales";
UPDATE USUARIO SET TIPO_USUARIO = "ADMINISTRATIVO" WHERE USUARIO = "carmenlopez";
UPDATE USUARIO SET TIPO_USUARIO = "ADMINISTRATIVO" WHERE USUARIO = "danielmartinez";


# FUNCIONES
DELIMITER //
CREATE FUNCTION carrera(id int, nombre varchar(40), facultad varchar(20), decano varchar(50)) RETURNS BOOL
BEGIN
DECLARE salida BOOL;
INSERT INTO CARRERA VALUES (id, nombre, facultad, decano);
RETURN salida;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION usuario(usuario varchar(15), tipo_user varchar(15), passw varchar(26)) RETURNS BOOL
BEGIN
DECLARE salida BOOL;
INSERT INTO USUARIO VALUES (usuario, tipo_user, passw);
RETURN salida;
END
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION clases(id int, nombre varchar(45), horas int, jornada SET("DIURNA", "NOCTURNA"), descrip varchar(60),  aula varchar(15), año varchar(2), programa varchar(40), tutor varchar(50)) RETURNS BOOL
BEGIN
DECLARE salida BOOL;
INSERT INTO CLASE VALUES (id, nombre, horas, jornada, descrip ,aula, año, programa, tutor);
RETURN salida;
END
//
DELIMITER ;

select carrera(10, "LENGUAS", "LENGUAS", "Sofia Hernandez");
select usuario ("HJSADJA", "MAESTRO","ASDASC");
select clases(11, "FISICA APLICADA", 10, "NOCTURNA", "FISICA APLICADA AL MUNDO", "104", 5, "MECATRONICA", 'NATALIA SANCHEZ');
##

