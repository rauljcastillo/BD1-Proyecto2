INSERT INTO carrera (id_carrera,nombre) VALUES (0,'Area Comun');
UPDATE carrera SET id_carrera = 0 WHERE id_carrera = LAST_INSERT_ID();