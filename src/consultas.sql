#Consulta 1
DELIMITER $$
CREATE PROCEDURE consultarPensum(
    IN c_carrera INT
)
proc_consultarP:BEGIN
    IF NOT EXISTS(SELECT id_carrera from carrera WHERE id_carrera=c_carrera) THEN
        CALL Message("No existe una carrera con dicho codigo");
        LEAVE proc_consultarP;
    ELSE
        SELECT c.codigo as 'Codigo', c.nombre as 'Curso',
        IF (c.obligatorio=1,'Si', 'No')  as 'Obligatorio',
        creditos_necesarios as 'Creditos necesarios',ca.nombre as 'Carrera' 
        from curso as c
        inner join carrera as ca on c.id_carre=ca.id_carrera
        WHERE c.id_carre=c_carrera;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE consultarEstudiante(
    IN c_carnet BIGINT
)

proc_estudiante:BEGIN
    IF NOT EXISTS(SELECT carnet from estudiante WHERE carnet=c_carnet) THEN
        SELECT CONCAT("El carnet ",c_carnet," no existe") as 'Error';
        LEAVE proc_estudiante;

    ELSE
        SELECT carnet,concat(nombres," ", apellidos) as 'Nombres',DATE_FORMAT(fecha_nacimiento,'%d-%m-%Y') as 'Fecha nacimiento',
        correo,telefono,direccion,dpi,creditos,c.nombre as 'carrera' FROM estudiante as es
        inner join carrera as c on es.carrera=c.id_carrera
        WHERE carnet=c_carnet;
    END IF;
END $$
DELIMITER ;

#Consulta 3
DELIMITER $$
CREATE PROCEDURE consultarDocente(
    IN c_siif INT
)

proc_cdocente: BEGIN
    IF NOT EXISTS(SELECT siif from docente WHERE siif=c_siif) THEN
        SELECT CONCAT("No existe un docente con registro ",c_siif);
        LEAVE proc_cdocente;
    ELSE
        SELECT siif,concat(nombres," ",apellidos) as 'Nombre',DATE_FORMAT(fecha_nacimiento,'%d-%m-%Y') as 'Fecha nacimiento',
        correo as 'Correo',telefono as 'Telefono',direccion as 'Direccion', dpi as 'Dpi'
        from docente
        WHERE siif=c_siif;
    END IF;
END $$
DELIMITER ;

#Consulta 4
DELIMITER $$
CREATE PROCEDURE consultarAsignados(
    IN c_curso INT,
    IN c_ciclo VARCHAR(2),
    IN c_anio INT,
    INT c_seccion CHAR(1)
)

proc_cAsignado: BEGIN
    IF NOT EXISTS(SELECT codigo from curso WHERE codigo=c_curso) THEN
        SELECT CONCAT("No existe el curso con código ",c_curso);
        LEAVE proc_cAsignado;
    ELSEIF existciclo(c_ciclo)=0 THEN
        CALL Message("Por favor, ingrese un ciclo válido");
        LEAVE proc_cAsignado;
    ELSE
        SELECT est.carnet as 'Carnet',concat(est.nombres," ",est.apellidos) as 'Nombres',est.creditos as 'Creditos' from asignacion as a
        inner join estudiante as est on a.carne_est=est.carnet
        WHERE codigo_curso=c_curso AND ciclo=UPPER(c_ciclo) AND anio=c_anio AND seccion=UPPER(c_seccion);
    END IF;
END $$
DELIMITER ;

#Consulta 5
DELIMITER $$
CREATE PROCEDURE consultarAprobacion(
    IN c_curso INT,
    IN c_ciclo VARCHAR(2),
    IN c_anio INT,
    IN c_seccion CHAR(1)
)

proc_cAprobado: BEGIN
    IF NOT EXISTS(SELECT codigo from curso WHERE codigo=c_curso) THEN
        SELECT CONCAT("No existe el curso con código ",c_curso);
        LEAVE proc_cAprobado;
    ELSEIF existciclo(c_ciclo)=0 THEN
        CALL Message("Por favor, ingrese un ciclo válido");
        LEAVE proc_cAprobado;
    ELSE
        SELECT curso_c as 'Codigo',carnet_est as 'Carnet',concat(estudiante.nombres," ",estudiante.apellidos) as 'Nombre',IF(nota>=61,'Aprobado','Reprobado') as 'Estado' FROM nota 
        inner join estudiante on nota.carnet_est=estudiante.carnet
        WHERE curso_c=c_curso AND ciclo=UPPER(c_ciclo) AND anio=c_anio AND seccion=UPPER(c_seccion);
    END IF;
END $$
DELIMITER ;

#Consulta 6
DELIMITER $$
CREATE PROCEDURE consultarActas(
    IN c_curso INT
)

proc_cActa: BEGIN
    IF NOT EXISTS(SELECT codigo from curso WHERE codigo=c_curso) THEN
        SELECT CONCAT("No existe el curso con código ",c_curso);
        LEAVE proc_cActa;
    ELSE
        select h.codigo as 'Codigo', h.seccion as 'Seccion',
        case
        when acta.ciclo='1S' THEN 'Primer semestre' WHEN acta.ciclo='2S' THEN 'Segundo semestre' WHEN acta.ciclo='VD' THEN 'Vacaciones Diciembre' ELSE 'Vacaciones Junio' END as 'Ciclo',
        h.fecha_creacion as 'Año',
        h.cantidad_asignados as 'Asignados',
        date_format(fecha,'%H:%i:%s %d-%m-%Y') as Fecha
        from acta
        inner join habilitacion h on h.id_habilitacion=acta.codigo_h
        WHERE h.codigo=c_curso
        order by Fecha desc;
    END IF;
END $$
DELIMITER ;

#Consulta 7
DELIMITER $$
CREATE PROCEDURE consultarDesasignacion(
    IN c_curso INT,
    IN c_ciclo VARCHAR(2),
    IN c_anio INT,
    IN c_seccion CHAR(1)
)

proc_cDes: BEGIN
    DECLARE codigoh INT;

    IF NOT EXISTS(SELECT codigo from curso WHERE codigo=c_curso) THEN
        SELECT CONCAT("No existe el curso con código ",c_curso);
        LEAVE proc_cDes;
    ELSEIF existciclo(c_ciclo)=0 THEN 
        CALL Message("Por favor ingrese un ciclo válido");
        LEAVE proc_cDes;
    END IF;

    SELECT id_habilitacion INTO codigoh from habilitacion WHERE codigo=c_curso AND ciclo=c_ciclo 
    AND fecha_creacion=c_anio AND seccion=c_seccion;

    if codigoh=1 THEN 
        SELECT h.codigo as 'Curso',h.seccion as 'Seccion',
        case 
        when h.ciclo='1S' THEN 'Primer semestre' WHEN h.ciclo='2S' THEN 'Segundo semestre' 
        WHEN h.ciclo='VD' THEN 'Vacaciones Diciembre' ELSE 'Vacaciones Junio' END as 'Ciclo',
        h.fecha_creacion as 'Año',
        h.cantidad_asignados as Asignados,
        (SELECT COUNT(curso_h) FROM desasignacion WHERE curso_h=codigoh group by curso_h) as Desasignados,
        (SELECT ROUND((Desasignados/Asignados)*100,2)) as 'Porcentaje'
        from desasignacion as d
        inner join habilitacion h on d.curso_h=h.id_habilitacion;
        
    END IF;
        
END $$
DELIMITER ;