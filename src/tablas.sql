CREATE TABLE IF NOT EXISTS carrera(
id_carrera INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS estudiante(
 carnet BIGINT NOT NULL PRIMARY KEY,
 nombres VARCHAR(50) NOT NULL,
 apellidos VARCHAR(50) NOT NULL,
 fecha_nacimiento DATE NOT NULL ,
 fecha_creacion DATE NOT NULL ,
 correo  VARCHAR(50) NOT NULL,
 telefono INTEGER NOT NULL,
 direccion VARCHAR(100) NULL,
 dpi BIGINT  NOT NULL,
 creditos SMALLINT DEFAULT 0,
 carrera INTEGER NOT NULL,
 FOREIGN KEY (carrera) REFERENCES carrera (id_carrera)
 );

 CREATE TABLE IF NOT EXISTS docente
(siif  INTEGER NOT NULL PRIMARY KEY,
 nombres VARCHAR(50) NOT NULL,
 apellidos VARCHAR(50) NOT NULL,
 fecha_nacimiento DATE NOT NULL,
 fecha_creacion DATE NOT NULL,
 correo  VARCHAR(50) NOT NULL,
 telefono INTEGER NOT NULL,
 direccion VARCHAR(100) NOT NULL,
 dpi BIGINT NOT NULL
 );

 CREATE TABLE IF NOT EXISTS curso
(codigo INTEGER NOT NULL PRIMARY KEY,
 nombre VARCHAR(50) NOT NULL,
 creditos_necesarios INTEGER  NOT NULL,
 creditos_otorga     INTEGER  NOT NULL ,
 obligatorio         TINYINT  NOT NULL,
 id_carre  INTEGER NOT NULL,
 FOREIGN KEY (id_carre) REFERENCES carrera (id_carrera)
);

CREATE TABLE IF NOT EXISTS habilitacion
(id_habilitacion INTEGER NOT NULL AUTO_INCREMENT  PRIMARY KEY,
 ciclo   VARCHAR(3) NOT NULL,
 seccion CHAR(1)    NOT NULL,
 cantidad_asignados SMALLINT DEFAULT 0,
 cupo_maximo SMALLINT NOT NULL,
 fecha_creacion INT NOT NULL,
 codigo INTEGER NOT NULL,
 siif INTEGER NOT NULL,
 FOREIGN KEY (codigo) REFERENCES curso (codigo),
 FOREIGN KEY (siif) REFERENCES docente (siif)
);

CREATE TABLE IF NOT EXISTS horario
(id_horario INTEGER NOT NULL AUTO_INCREMENT  PRIMARY KEY,
 id_habilitacion  INTEGER NOT NULL,
 dia TINYINT NOT NULL,
 horario VARCHAR(15) NOT NULL,
 FOREIGN KEY (id_habilitacion) REFERENCES habilitacion(id_habilitacion)
);

CREATE TABLE IF NOT EXISTS asignacion(
    id_asignacion INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ciclo VARCHAR(3),
    seccion CHAR(1),
    anio INT,
    codigo_curso INTEGER,
    carne_est bigint,
    FOREIGN KEY(codigo_curso) REFERENCES curso(codigo),
    FOREIGN KEY(carne_est) REFERENCES estudiante(carnet)
);

CREATE TABLE IF NOT EXISTS desasignacion(
    id_desasignacion INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    curso_h INTEGER NOT NULL,
    carnet_es BIGINT NOT NULL,
    FOREIGN KEY(curso_h) REFERENCES habilitacion(id_habilitacion),
    FOREIGN KEY(carnet_es) REFERENCES estudiante(carnet)
);

CREATE TABLE IF NOT EXISTS nota(
    id_nota INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    anio INT NOT NULL,
    ciclo VARCHAR(2) NOT NULL, 
    seccion CHAR(1) NOT NULL,
    nota INT NOT NULL,
    curso_c INTEGER NOT NULL,
    carnet_est BIGINT NOT NULL,
    FOREIGN KEY(curso_c) REFERENCES curso(codigo),
    FOREIGN KEY(carnet_est) REFERENCES estudiante(carnet)
);

CREATE TABLE IF NOT EXISTS acta(
    id_acta INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL,
    ciclo VARCHAR(2) NOT NULL,
    seccion CHAR(1) NOT NULL,
    codigo_h INTEGER NOT NULL,
    FOREIGN KEY(codigo_h) REFERENCES habilitacion(id_habilitacion)
);