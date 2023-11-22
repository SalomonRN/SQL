create database mv;
use mv;
create table pelicula(
    titulo varchar(45) primary key,
    año int,
    nacion varchar(45),
    idioma SET('Español', 'Ingles', 'Italiano', 'Japones'),
    color varchar(45),
    resumen varchar(45),
    observ varchar(45)

);
create table director(
    nombreDirector varchar(45) primary key,
	nombrePeli varchar(45),
    fnac date,
    nacion SET('España', 'Italia', 'Noruega', 'Jamaica')
);
create table actor(
    nombre varchar(45) primary key,
	nombrePeli varchar(45),
	nacion SET('España', 'Italia', 'Noruega', 'Jamaica'),
    personaje varchar(45)
);
alter table actor add foreign key (nombrePeli) references pelicula(titulo);
alter table director add foreign key (nombrePeli) references pelicula(titulo);

insert into pelicula values ("La pelicula del 2001!",2001,"Argentina","Español,Ingles","Azul","RESUMEN MUY BUENA WOWOWO","NINGUNA???");
insert into pelicula values ("La pelicula del 2002!!",2002,"China","Español,Ingles,Italiano","Blanco","RESUMEN DEMASIADO BUENA","NADA");
insert into pelicula values ("La pelicula del 2003!!!",2003,"Rusia","Italiano,Ingles","Negro","RESUMEN MUY CHIMBA 10/10","NULLO 10/10");
insert into pelicula values ("La pelicula del 2004!!!!",2004,"Colombia","Español,Ingles,Japones","Rojo","PARA SUN OSCAR SIIII","NO SE QUE MAS PONER");
insert into pelicula values ("La pelicula del 2005!!!!!",2005,"Turkey","Español,Ingles,Japones,Italiano", "Morado","UN PREMIO ASEGURADO","NO SE QUE MAS PONER EN SERIO");

insert into director values ("Juanito","La pelicula del 2001!",'2001-01-01',"Noruega");
insert into director values ("Don Perez","La pelicula del 2002!!",'2002-02-02',"Italia");
insert into director values ("Luis","La pelicula del 2003!!!",'2003-03-03',"Jamaica");
insert into director values ("Maria","La pelicula del 2004!!!!",'2004-04-04',"España");
insert into director values ("Patricia","La pelicula del 2005!!!!!",'2005-05-05',"Jamaica");

insert into actor values ("Luisa","La pelicula del 2001!","Italia","Blanca");
insert into actor values ("Nara","La pelicula del 2002!!","España","Rapunsel");
insert into actor values ("Morena","La pelicula del 2003!!!","Jamaica","Superman");
insert into actor values ("Migue","La pelicula del 2004!!!!","Noruega","Flash");
insert into actor values ("Nat","La pelicula del 2005!!!!!","Noruega","Super Girl");

select * from actor order by rand() limit 3;
select * from actor where find_in_set('Noruega',nacion)>0;
select * from director where find_in_set('Jamaica',nacion)>0;
select * from pelicula where find_in_set('Japones',idioma)>0;
