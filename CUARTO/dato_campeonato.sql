CREATE DATABASE campeonato;
USE campeonato;
CREATE TABLE tblEquipos (
  idEquipo smallint(2) PRIMARY KEY auto_increment COMMENT "Numero consecutivo del equipo, que lo indentifica dentro del campo",
  Equipo varchar(50) DEFAULT "" COMMENT "Nombre del club de futbol",
  Tecnico varchar(50) DEFAULT "" COMMENT "Nombre del director tecnico",
  Fundacion date DEFAULT NULL COMMENT "Fecha de fundacion del club",
  Ciudad varchar(50) DEFAULT "" COMMENT "Ciudad de origen del equipo",
  Direccion varchar(50) DEFAULT "" COMMENT "Direccion de la sede ofical del club",
  Telefono varchar(50) DEFAULT "" COMMENT "Telefonos de la seda"
) COMMENT "Permite almacenar la informacion basica de cada uno de los equipos inscritos en ll campeonato de fultbol";

CREATE TABLE tblJugadores (
  idJugador int(10) PRIMARY KEY DEFAULT 0 COMMENT "Numero de identificacion del jugador" ,
  Nombre varchar(25) DEFAULT "" COMMENT "Nombres del jugador",
  Apellidos varchar(25) DEFAULT "" COMMENT "Apellidos del jugador",
  Nacimiento date DEFAULT NULL COMMENT "Fecha de nacimiento del jugador",
  TipoSangre varchar(3) DEFAULT "" COMMENT "Tipo de sangre del jugador",
  CodEquipo smallint(2) UNIQUE DEFAULT 0 COMMENT "Codigo del equipo que pertenece el jugador",
  FOREIGN KEY (CodEquipo) REFERENCES tblEquipos (idEquipo)
) COMMENT "Permite almacenar la informacion basica de cada uno de los jugadores que participen por un equipo dentro del campeonato de futbul";
# 4
insert into tblEquipos values (1, "Equipo1", "Tecnico1", '2001-01-01',"Ciudad1", "Direccion1", "Telefono1");
insert into tblEquipos values (2, "Equipo2", "Tecnico2", '2002-02-02',"Ciudad2", "Direccion2", "Telefono2");
insert into tblEquipos values (3, "Equipo3", "Tecnico3", '2003-03-03',"Ciudad3", "Direccion3", "Telefono3");
insert into tblEquipos values (4, "Equipo4", "Tecnico4", '2004-04-04',"Ciudad4", "Direccion4", "Telefono4");
insert into tblEquipos values (5, "Equipo5", "Tecnico5", '2005-05-05',"Ciudad5", "Direccion5", "Telefono5");

insert into tblJugadores values (1, "Nombre1", "Apellidos1", '2011-01-01', "O+", 1);
insert into tblJugadores values (2, "Nombre2", "Apellidos2", '202-02-02', "A+", 2);
insert into tblJugadores values (3, "Nombre3", "Apellidos3", '203-03-03', "A-", 3);
insert into tblJugadores values (4, "Nombre4", "Apellidos4", '204-04-04', "O-", 4);
insert into tblJugadores values (5, "Nombre5", "Apellidos5", '205-05-05', "AB", 5);

# 5
ALTER TABLE  tblJugadores ADD cedula INT( 11 ) NOT NULL;


# 6 ***
insert into tblEquipos values (6, "Equipo6", "Tecnico6", '2006-06-06',"Ciudad6", "Direccion6", "Telefono5");
insert into tblJugadores values (6, "Nombre6", "Apellidos6", '2006-06-06', "O+", 6, 666656);
replace into tblJugadores values (6, "Luis", "Zapato", '2001-03-06', "O-", 5, 8852522);
replace into tblEquipos values (6, "Equipso6", "Tecnico6", '2006-06-06',"Ciudad6", "Direccion6", "Telefono5");
replace into tblJugadores values (6, "Luis", "Zapato", '2001-03-06', "O-", 6, 8852522);
# 7
alter table tblEquipos add column (Barrio varchar(40));
# 8
alter table tblEquipos modify column Direccion varchar(70);
# 9
alter table tbljugadores modify column Apellidos varchar(50);
#10
alter table tblEquipos change Equipo NombreEquipo varchar(25);
#11
alter table tblJugadores change Nacimiento FechaNacimiento date;

#12
ALTER TABLE tblJugadores DROP FOREIGN KEY tbljugadores_ibfk_1;
alter table tblJugadores drop primary key;
alter table tblJugadores modify column cedula int(20) PRIMARY KEY AUTO_INCREMENT ;

# 13
rename table tblJugadores to tbl__Jugadores, tblEquipos to tbl__Equipos;
# 14
delete from tbl__Jugadores where CodEquipo = 1;
delete from tbl__Equipos where idEquipo = 1;
