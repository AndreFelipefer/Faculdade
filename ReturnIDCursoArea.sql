DELIMITER $

CREATE FUNCTION obter_id_curso(
  p_nome_curso VARCHAR(100),
  p_area_curso VARCHAR(100)
)
RETURNS INT
BEGIN
  DECLARE curso_id INT;
  
  SELECT idCursos INTO curso_id
  FROM Cursos
  WHERE disciplina = p_nome_curso AND area = p_area_curso;
  
  RETURN curso_id;
END;

$

DELIMITER ;