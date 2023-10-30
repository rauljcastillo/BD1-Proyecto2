#Esto es un comentario
DELIMITER $$
CREATE PROCEDURE registrarEstudiante(
	IN carne bigint,
    IN e_nombres VARCHAR(40),
    IN e_apellido VARCHAR(40),
    IN nacim VARCHAR(10),
    IN ncorreo VARCHAR(30),
	IN telef INT,
	IN dir VARCHAR(40),
	IN ndpi bigint,
	IN e_carrera INTEGER UNSIGNED
)
student: BEGIN
	DECLARE exist_carne BOOLEAN;
	DECLARE exist_corre BOOLEAN;
	DECLARE exist_dpi BOOLEAN;
	DECLARE exist_carrera BOOLEAN;
	DECLARE fecha_actual DATE;
	DECLARE formato DATE;

	IF carne IS NULL THEN
		CALL Message("Debe ingresar el numero de carnet");
        LEAVE student;
	ELSEIF e_nombres is NULL THEN
		CALL Message("Debe ingresar nombre del student");
        LEAVE student;
	ELSEIF e_apellido IS NULL THEN
		CALL Message("Debe ingresar una fecha ed nacimiento");
		LEAVE student;
    ELSEIF nacim IS NULL THEN
		CALL Message("Por favor, ingrese una fecha de nacimiento");
        LEAVE student;
	ELSEIF ncorreo IS NULL THEN
		CALL Message("Por favor, ingrese un correo electrónico");
        LEAVE student;
	ELSEIF telef IS NULL THEN
		CALL Message("Por favor, ingrese un número de teléfono");
		LEAVE student;
	ELSEIF dir IS NULL THEN
		CALL Message("Por favor, ingrese un numero de dpi");
		LEAVE student;
	ELSEIF e_carrera IS NULL THEN
		CALL Message("Por favor ingrese el número de carrera correspondiente");
		LEAVE student;
	END IF;
	SELECT EXISTS(SELECT carnet from estudiante WHERE carnet=carne) INTO exist_carne;
	SELECT EXISTS(SELECT correo from estudiante WHERE correo=ncorreo) INTO exist_corre;
	SELECT EXISTS(SELECT dpi from estudiante WHERE dpi=ndpi) INTO exist_dpi;
	SELECT EXISTS(SELECT id_carrera from carrera WHERE id_carrera=e_carrera) INTO exist_carrera;


	IF validemail(ncorreo)=1 AND exist_carrera=1 AND exist_carne=0 AND exist_corre=0 AND exist_dpi=0 THEN
		SELECT CURDATE() INTO fecha_actual;
		IF STR_TO_DATE(nacim,'%d-%m-%Y') IS NOT NULL THEN
			SET formato= STR_TO_DATE(nacim,'%d-%m-%Y');
		ELSEIF STR_TO_DATE(nacim,'%Y-%m-%d') IS NOT NULL THEN
			SET formato= STR_TO_DATE(nacim,'%Y-%m-%d');
		ELSE
			CALL Message("Ingrese un formato de fecha válido");
			LEAVE student;
		END IF;

		INSERT INTO estudiante(carnet,nombres,apellidos,fecha_nacimiento,fecha_creacion,correo,telefono,direccion
		,dpi,carrera) VALUES(carne,e_nombres,e_apellido,formato,fecha_actual,ncorreo,telef,dir,ndpi,e_carrera);
	ELSEIF exist_carne>0 THEN
		SELECT CONCAT("Ya existe el carnet ",carne) as 'Error';
		LEAVE student;
	ELSEIF exist_corre>0 THEN
		SELECT CONCAT("Ya existe el correo ",ncorreo) as 'Error';
		LEAVE student;
	ELSEIF exist_dpi>0 THEN
		SELECT CONCAT("Ya existe el dpi ",ndpi) as 'Error';
	ELSEIF exist_carrera=0 THEN
		SELECT CONCAT("La carrera ",e_carrera," no existe") as 'Error';
		LEAVE student;
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Message(msg VARCHAR(100))
	BEGIN 
		SELECT msg as 'Error';
	END $$
DELIMITER ;
	
DELIMITER $$
CREATE PROCEDURE crearCarrera(
	IN c_carrera VARCHAR(50)
)

proc_carrera:BEGIN
	DECLARE exist_carrera BOOLEAN;
	IF sololetras(c_carrera)=1 THEN
		SELECT EXISTS(SELECT nombre from carrera WHERE nombre=LOWER(c_carrera)) INTO exist_carrera;

		IF exist_carrera=1 THEN
			SELECT CONCAT("La carrera ",c_carrera, " ya existe") as 'Error';
			LEAVE proc_carrera;
		ELSE 
			INSERT INTO carrera(nombre) VALUES (LOWER(c_carrera));
			SELECT CONCAT('Carrera creada con exito') as 'Respuesta';
		END IF;

	ELSE 
		CALL Message("El nombre de la carrera solo debe contener letras")
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE registrarDocente(
	IN d_nombres VARCHAR(40),
	IN d_apellidos VARCHAR(40),
	IN d_nacim VARCHAR(10),
	IN d_correo VARCHAR(50),
	IN d_telefono INT,
	IN d_direction VARCHAR(60),
	IN d_dpi bigint,
	IN d_siif INT
)
proc_docente: BEGIN
	DECLARE exist_siif BOOLEAN;
	DECLARE exist_correo BOOLEAN;
	DECLARE exist_dpi BOOLEAN;
	DECLARE fecha_actual DATE;
	DECLARE formato DATE;
	IF d_nombres IS NULL THEN
		CALL Message("Debe ingresar el nombre del docente");
        LEAVE proc_docente;
	ELSEIF d_apellidos is NULL THEN
		CALL Message("Debe ingresar los apellidos del docente");
        LEAVE proc_docente;
	ELSEIF d_nacim IS NULL THEN
		CALL Message("Debe ingresar una fecha de nacimiento");
		LEAVE proc_docente;
    ELSEIF d_correo IS NULL THEN
		CALL Message("Por favor, ingrese el correo electrónico");
        LEAVE proc_docente;
	ELSEIF d_telefono IS NULL THEN
		CALL Message("Por favor, ingrese el número de telefono");
        LEAVE proc_docente;
	ELSEIF d_direction IS NULL THEN
		CALL Message("Por favor, ingrese la dirección del docente");
		LEAVE proc_docente;
	ELSEIF d_dpi IS NULL THEN
		CALL Message("Por favor, ingrese el numero de dpi");
		LEAVE proc_docente;
	ELSEIF d_siif IS NULL THEN
		CALL Message("Por favor ingrese, el identifcador siif");
		LEAVE proc_docente;
	END IF;

	SELECT EXISTS(SELECT siif from docente WHERE siif=d_siif) INTO exist_siif;
	SELECT EXISTS(SELECT dpi from docente WHERE dpi=d_dpi) INTO exist_dpi;
	SELECT EXISTS(SELECT correo from docente WHERE correo=d_correo) INTO exist_correo;

	IF validemail(d_correo)=1 AND exist_siif=0 AND exist_dpi=0 AND exist_correo=0 THEN
		SELECT CURDATE() INTO fecha_actual;
		IF STR_TO_DATE(d_nacim,'%d-%m-%Y') IS NOT NULL THEN
			SELECT STR_TO_DATE(d_nacim,'%d-%m-%Y') INTO formato;
		ELSEIF STR_TO_DATE(d_nacim,'%Y-%m-%d') IS NOT NULL THEN
			SELECT STR_TO_DATE(d_nacim,'%Y-%m-%d') INTO formato;
		ELSE
			CALL Message("Ingrese un formato de fecha válido");
			LEAVE proc_docente;
		END IF;

		INSERT INTO docente(siif,nombres,apellidos,fecha_nacimiento,fecha_creacion,correo,telefono,direccion,dpi) VALUES(d_siif,
		d_nombres,d_apellidos,formato,fecha_actual,d_correo,d_telefono,d_direction,d_dpi);
		SELECT CONCAT("Docente agregado con éxito") as 'Mensaje';
	ELSEIF exist_siif=1 THEN
		CALL Message("El docente ya existe");
		LEAVE proc_docente;
	ELSEIF exist_dpi=1 THEN
		CALL Message("El numero de dpi ya existe");
		LEAVE proc_docente;
	ELSEIF exist_correo=1 THEN
		CALL Message("El correo ya está registrado");
	END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE crearCurso(
	IN c_codigo INT,
	IN c_nombre VARCHAR(50),
	IN c_creditosn TINYINT,
	IN c_creditoso TINYINT,
	IN c_carrera INT,
	IN c_obligatorio BOOLEAN
)
proc_curso: BEGIN
	DECLARE exist_codigo BOOLEAN;
	DECLARE exist_carrera BOOLEAN;
	IF c_codigo IS NULL THEN
		CALL Message("Por favor, ingrese el codigo del curso");
		LEAVE proc_curso;
	ELSEIF c_nombre IS NULL THEN
		CALL Message("Por favor, ingrese el nombre del curso");
		LEAVE proc_curso;
	ELSEIF c_creditosn IS NULL THEN
		CALL Message("Por favor, ingrese los creditos necesarios del curso");
		LEAVE proc_curso;
	ELSEIF c_creditoso IS NULL THEN
		CALL Message("Ingrese los creditos que otorga dicho curso");
		LEAVE proc_curso;
	ELSEIF c_carrera IS NULL THEN
		CALL Message("Por favor, ingrese la carrera a la que pertenece");
		LEAVE proc_curso;
	ELSEIF c_obligatorio IS NULL THEN
		CALL Message("Por favor, ingrese el campo obligatorio");
		LEAVE proc_curso;
	END IF;

	SELECT EXISTS(SELECT codigo from curso WHERE codigo=c_codigo) INTO exist_codigo;
	SELECT EXISTS(SELECT id_carrera from carrera WHERE id_carrera=c_carrera) INTO exist_carrera;
	IF exist_codigo=0 AND exist_carrera=1 AND esPositivo(c_creditosn)=1 AND esEntero(c_creditoso)=1 THEN
		INSERT INTO curso(codigo,nombre,creditos_necesarios,creditos_otorga,obligatorio,id_carre) VALUES(c_codigo,c_nombre
		,c_creditosn,c_creditoso,c_obligatorio,c_carrera);
	ELSEIF exist_carrera=0 THEN
		SELECT CONCAT("La carrera ",c_carrera," no existe") as 'Error';
		LEAVE proc_curso;
	ELSEIF exist_codigo=1 THEN
		CALL Message("El curso ya existe");
		LEAVE proc_curso;
	ELSEIF esPositivo(c_creditosn)=0 THEN
		CALL Message("Los creditos necesarios debe ser un numero entero positivo");
		LEAVE proc_curso;
	ELSEIF esEntero(c_creditoso)=0 THEN
		CALL Message("Los creditos que otorga deben ser mayores que 0");
		LEAVE proc_curso;
	END IF;

END $$
DELIMITER ;
	
DELIMITER $$
CREATE PROCEDURE habilitarCurso(
	IN h_codigoc INT,
	IN h_ciclo VARCHAR(2),
	IN h_docente INT,
	IN h_cupo INT,
	IN h_seccion CHAR(1)
)
proc_habilitar: BEGIN
	DECLARE exist_curso BOOLEAN;
	DECLARE exist_docente BOOLEAN;
	DECLARE fecha_actual INT;
	DECLARE existeh TINYINT;
	IF h_codigoc IS NULL THEN
		SELECT CONCAT("El curso ",h_codigoc," no existe");
		LEAVE proc_habilitar;
	ELSEIF h_ciclo IS NULL THEN
		CALL Message("Ingrese un ciclo válido");
		LEAVE proc_habilitar;
	ELSEIF h_docente IS NULL THEN
		CALL Message("Ingrese el docente que imparte el curso");
		LEAVE proc_habilitar;
	ELSEIF h_seccion IS NULL THEN
		CALL Message("Ingrese la sección del curso");
		LEAVE proc_habilitar;
	END IF;

	SELECT EXISTS(SELECT codigo FROM curso WHERE codigo=h_codigoc) INTO exist_curso;
	SELECT EXISTS(SELECT siif FROM docente WHERE siif=h_docente) INTO exist_docente;
	IF exist_curso=1 AND existciclo(UPPER(h_ciclo))=1 AND esEntero(h_cupo)=1 AND exist_docente=1 THEN

		SELECT count(*)  INTO existeh FROM habilitacion WHERE ciclo=h_ciclo AND seccion=h_seccion AND codigo=h_codigoc;
		IF existeh=0 THEN
			SELECT year(CURDATE()) INTO fecha_actual;
			INSERT INTO habilitacion(ciclo,seccion,cupo_maximo,fecha_creacion,codigo,siif) VALUES(
				h_ciclo,UPPER(h_seccion),h_cupo,fecha_actual,h_codigoc,h_docente
			);
			SELECT CONCAT("Curso habilitado con éxito") as 'Mensaje';
		ELSE 
			SELECT CONCAT("El curso ya está habilitado") as 'Error';
			LEAVE proc_habilitar;
		END IF;

	ELSEIF exist_curso=0 THEN
		SELECT CONCAT("El curso ",h_codigoc," no existe") as 'Error';
		LEAVE proc_habilitar;
	ELSEIF existciclo(UPPER(h_ciclo))=0 THEN
		CALL Message("Ingrese un ciclo válido");
		LEAVE proc_habilitar;
	ELSEIF esEntero(h_cupo)=0 THEN
		CALL Message("El numero de cupo debe ser mayor que 0");
	ELSEIF exist_seccion=1 THEN
		SELECT CONCAT("La seccion ",h_seccion," ya existe") as 'Error';
		LEAVE proc_habilitar;
	ELSEIF exist_docente=0 THEN
		SELECT CONCAT("El docente con indentificacion ", siif," no existe") as 'Error';
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE agregarHorario(
	IN id_cursohab INT,
	IN h_dia INT,
	IN h_horario VARCHAR(12)
)

proc_horario: BEGIN
	#Si existe el curso habilitado
	DECLARE existe_hab BOOLEAN;
	IF id_cursohab IS NULL THEN
		CALL Message("Por favor, ingrese el id del curso habilitado");
		LEAVE proc_horario;
	ELSEIF h_dia IS NULL THEN
		CALL Message("Por favor, ingrese el dia que se imparte el curso");
		LEAVE proc_horario;
	ELSEIF h_horario IS NULL THEN
		CALL Message("Por favor, ingrese el horario del curso");
		LEAVE proc_horario;
	END IF;

	SELECT EXISTS(SELECT id_habilitacion from habilitacion WHERE id_habilitacion=id_cursohab) INTO existe_hab;
	IF existe_hab=1 AND isDia(h_dia)=1 AND isFecha(h_horario)=1 THEN
		INSERT INTO horario(id_habilitacion,dia,horario) VALUES(id_cursohab,h_dia,h_horario);
		SELECT CONCAT("Horario agregado con exito") as 'Mensaje';
	ELSEIF existe_hab=0 THEN
		SELECT CONCAT("El curso con id", id_cursohab," no está habilitado") as 'Error';
		LEAVE proc_horario;
	ELSEIF isDia(h_dia)=0 THEN
		CALL Message("Ingrese un formato válido para el día");
		LEAVE proc_horario;
	ELSEIF isFecha(h_horario)=0 THEN
		CALL Message("Ingrese un formato valido de horario");
		LEAVE proc_horario;
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE asignarCurso(
	IN a_codigoc INTEGER,
	IN a_ciclo VARCHAR(3),
	IN a_seccion CHAR(1),
	IN a_carnet bigint
)
proc_asignar: BEGIN
	DECLARE exist_carne BOOLEAN;
	DECLARE pertenece BOOLEAN;
	DECLARE ismatch TINYINT;
	DECLARE anio_actual INT;
	DECLARE isArea BOOLEAN;
	DECLARE creditos_n BOOLEAN;
	DECLARE cupo TINYINT;
	DECLARE isAsignado BOOLEAN;
	DECLARE isDes BOOLEAN;

	IF a_codigoc IS NULL THEN
		CALL Message("Por favor, ingrese el código del curso a asignar");
		LEAVE proc_asignar;
	ELSEIF a_ciclo IS NULL THEN
		CALL Message("Por favor, ingrese el ciclo al que pertenece dicho curso");
		LEAVE proc_asignar;
	ELSEIF a_seccion IS NULL THEN
		CALL Message("Por favor, ingrese la seccion a la que desea asignarse");
		LEAVE proc_asignar;
	ELSEIF a_carnet IS NULL THEN
		CALL Message("Por favor, ingrese el numero de carnet ");
		LEAVE proc_asignar;
	END IF;

	SELECT year(CURDATE()) INTO anio_actual;
	SELECT EXISTS(SELECT carnet FROM estudiante WHERE carnet=a_carnet) INTO exist_carne;
	SELECT exists(SELECT codigo,id_carre FROM curso WHERE codigo=a_codigoc AND id_carre=carrera) INTO pertenece from estudiante WHERE carnet=a_carnet;
	SELECT exists(SELECT codigo,id_carre FROM curso WHERE codigo=a_codigoc AND id_carre=0) INTO isArea;
	SELECT COUNT(*) INTO ismatch FROM habilitacion WHERE codigo=a_codigoc AND fecha_creacion=anio_actual AND ciclo=a_ciclo AND seccion=UPPER(a_seccion);
	SELECT EXISTS(SELECT carnet,creditos FROM estudiante WHERE carnet=a_carnet AND creditos>=creditos_necesarios ) INTO creditos_n FROM curso WHERE codigo=a_codigoc;
	SELECT COUNT(*) INTO cupo FROM habilitacion WHERE ciclo=a_ciclo AND seccion=a_seccion AND codigo=a_codigoc AND cantidad_asignados<cupo_maximo;
	SELECT EXISTS(SELECT ciclo,codigo_curso,carne_est FROM asignacion WHERE ciclo=a_ciclo AND codigo_curso=a_codigoc AND carne_est=a_carnet) INTO isAsignado;
	SELECT EXISTS(SELECT * FROM desasignacion WHERE ciclo=a_ciclo AND seccion=a_seccion AND curso_cod=a_codigoc AND carnet_es=a_carnet) INTO isDes;

	IF exist_carne=0 THEN
		SELECT CONCAT("El carnet ",a_carnet, " no existe");
		LEAVE proc_asignar;

	ELSEIF isAsignado=1 THEN
		SELECT CONCAT("Ya está asignado al curso", a_codigoc);
		LEAVE proc_asignar;

	ELSEIF existciclo(UPPER(a_ciclo))=0 THEN
		CALL Message("Ingrese un ciclo válido");
		LEAVE proc_asignar;

	ELSEIF pertenece=0 AND isArea=0 THEN
		SELECT CONCAT("El curso ",a_codigoc," no pertenece a la carrera");
		LEAVE proc_asignar;
	
	ELSEIF ismatch=0 THEN
		CALL Message("Error en el curso. Puede que no esté habilitado o no exista");
		LEAVE proc_asignar;
	ELSEIF creditos_n=0 THEN
		CALL Message("No cumples con los créditos necesarios");
		LEAVE proc_asignar;
	ELSEIF cupo=0 THEN
		CALL Message("Ya no hay cupo disponible");
		LEAVE proc_asignar;
	ELSEIF isDes=1 THEN
		CALL Message("Te desasignaste este curso, no puedes volver a asignarlo");
		LEAVE proc_asignar;
	ELSEIF (pertenece=1 OR isArea=1) AND ismatch=1 AND creditos_n=1 AND cupo>0 THEN
		INSERT INTO asignacion(ciclo,seccion,anio,codigo_curso,carne_est) VALUES(a_ciclo,UPPER(a_seccion),anio_actual,a_codigoc,a_carnet);
		UPDATE habilitacion
		SET cantidad_asignados=cantidad_asignados+1
		WHERE ciclo=a_ciclo AND seccion=UPPER(a_seccion) AND codigo=a_codigoc;
	END IF;
END $$
DELIMITER ;
	
DELIMITER $$
CREATE PROCEDURE desasignarCurso(
	IN d_codigoc INT,
	IN d_ciclo VARCHAR(2),
	IN d_seccion CHAR(1),
	IN d_carnet bigint
)

proc_des: BEGIN
	DECLARE ismatch TINYINT;
	DECLARE anio_actual INT;
	DECLARE isAsignado BOOLEAN;

	IF d_codigoc IS NULL THEN
		CALL Message("Por favor, ingrese el código del curso a asignar");
		LEAVE proc_des;
	ELSEIF d_ciclo IS NULL THEN
		CALL Message("Por favor, ingrese el ciclo al que pertenece dicho curso");
		LEAVE proc_des;
	ELSEIF d_seccion IS NULL THEN
		CALL Message("Por favor, ingrese la seccion a la que desea asignarse");
		LEAVE proc_des;
	ELSEIF d_carnet IS NULL THEN
		CALL Message("Por favor, ingrese el numero de carnet ");
		LEAVE proc_des;
	END IF;

	SELECT year(CURDATE()) INTO anio_actual;
	SELECT COUNT(*) INTO ismatch FROM habilitacion WHERE codigo=d_codigoc AND fecha_creacion=anio_actual AND ciclo=UPPER(d_ciclo) AND seccion=UPPER(d_seccion);
	SELECT EXISTS(SELECT * FROM asignacion WHERE carne_est=d_carnet AND ciclo=UPPER(d_ciclo) AND seccion=UPPER(d_seccion) AND  anio=anio_actual) INTO isAsignado;
	
	IF isAsignado=0 THEN
		SELECT CONCAT("No estás asignado al curso ",d_codigoc," en el ciclo ",d_ciclo);
		LEAVE proc_des;
	ELSEIF existciclo(UPPER(d_ciclo))=0 THEN
		CALL Message("Ingrese un ciclo válido");
		LEAVE proc_des;
	ELSEIF ismatch=0 THEN
		CALL Message("No se puede desasignar, el curso no está habilitado");
		LEAVE proc_des;
	ELSE
		INSERT INTO desasignacion(ciclo,seccion,curso_cod,carnet_es) VALUES(d_ciclo,d_seccion,d_codigoc,d_carnet);
		UPDATE habilitacion
		SET cantidad_asignados=cantidad_asignados-1
		WHERE ciclo=UPPER(d_ciclo) AND seccion=d_seccion AND codigo=d_codigoc AND fecha_creacion=anio_actual;
		DELETE from asignacion WHERE carne_est=d_carnet AND ciclo=UPPER(d_ciclo) AND seccion=UPPER(d_seccion) AND anio=anio_actual AND codigo_curso=d_codigoc;
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ingresarNota(
	IN i_codigoc INT,
	IN i_ciclo VARCHAR(2),
	IN i_seccion CHAR(1),
	IN i_carnet BIGINT,
	IN i_nota INT
)
proc_nota: BEGIN
	DECLARE exist_carne BOOLEAN;
	DECLARE aprobo BOOLEAN;
	DECLARE anio_actual INT;
	IF i_codigoc IS NULL THEN
		CALL Message("Por favor, ingrese el código del curso");
		LEAVE proc_nota;
	ELSEIF i_ciclo IS NULL THEN
		CALL Message("Por favor, ingrese el ciclo al que pertenece");
		LEAVE proc_nota;
	ELSEIF i_seccion IS NULL THEN
		CALL Message("Por favor, ingrese la seccion del curso");
		LEAVE proc_nota;
	ELSEIF i_nota IS NULL THEN
		CALL Message("Por favor, ingrese la nota final");
		LEAVE proc_nota;
	END IF;

	SELECT EXISTS(SELECT carnet FROM estudiante WHERE carnet=i_carnet) INTO exist_carne;
	IF exist_carne=0 THEN
		SELECT CONCAT("El carnet", i_carnet, " no existe");
		LEAVE proc_nota;
	ELSEIF existciclo(UPPER(i_ciclo))=0 THEN
		CALL Message("Por favor, ingrese un numero de ciclo válido");
		LEAVE proc_nota;
	ELSEIF esPositivo(i_nota)=0 THEN
		CALL Message("Por favor, ingrese una nota válida");
		LEAVE proc_nota;
	ELSEIF ROUND(i_nota)>=61 THEN
		SELECT year(CURDATE()) INTO anio_actual;
		INSERT INTO nota(anio,ciclo,seccion,nota,curso_c,carnet_est) VALUES(anio_actual,UPPER(i_ciclo),UPPER(i_seccion),ROUND(i_nota),i_codigoc,i_carnet);
		UPDATE estudiante
		SET creditos=creditos+ (SELECT creditos_otorga FROM curso WHERE codigo=i_codigoc) 
		WHERE carnet=i_carnet;
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE generarActa(
	IN g_curso INT,
	IN g_ciclo VARCHAR(2),
	IN g_seccion CHAR(1)
)
proc_generar:BEGIN
	DECLARE cantidad_Ingresados INT;
	DECLARE fecha_actual DATE;

	IF g_curso IS NULL THEN
		CALL Message("Por favor, ingrese el código del curso");
		LEAVE proc_generar;
	ELSEIF g_ciclo IS NULL THEN
		CALL Message("Por favor, ingrese el ciclo al que pertenece");
		LEAVE proc_generar;
	ELSEIF g_seccion IS NULL THEN
		CALL Message("Por favor, ingrese la seccion del curso");
		LEAVE proc_generar;
	END IF;

	SELECT COUNT(*) INTO cantidad_Ingresados FROM nota WHERE curso_c=g_curso AND ciclo=UPPER(g_ciclo) AND seccion=UPPER(g_seccion);
	IF existciclo(UPPER(g_ciclo))=0 THEN
		CALL Message("Por favor ingrese un formato");
		LEAVE proc_generar;
	ELSEIF cantidad_Ingresados=(SELECT cantidad_asignados FROM habilitacion WHERE ciclo=UPPER(g_ciclo) AND seccion=UPPER(g_seccion) AND codigo=g_curso) THEN
		SELECT CURDATE() INTO fecha_actual;
		INSERT INTO acta(fecha,ciclo,seccion,codigo_c) VALUES(fecha_actual,g_ciclo,g_seccion,g_curso);
		LEAVE proc_generar;
	ELSE
		CALL Message("No se han ingresado todas las notas");
	END IF;
END $$
DELIMITER ;
