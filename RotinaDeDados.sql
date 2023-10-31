DELIMITER $

CREATE PROCEDURE inserir_curso(
  IN p_disciplina VARCHAR(100)
)
BEGIN
  INSERT INTO Cursos (disciplina) VALUES (p_disciplina);
END;

$

DELIMITER ;