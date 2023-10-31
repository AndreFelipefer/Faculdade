DELIMITER $

CREATE PROCEDURE matricular_aluno(
  IN p_nome_aluno VARCHAR(100),
  IN p_ra_aluno VARCHAR(100),
  IN p_email_aluno VARCHAR(100),
  IN p_nome_curso VARCHAR(100)
)
BEGIN
  DECLARE curso_id INT;

  -- Obtém o ID do curso com base no nome do curso
  SELECT idCursos INTO curso_id
  FROM Cursos
  WHERE disciplina = p_nome_curso;

  -- Verifica se o aluno já está matriculado no curso
  IF EXISTS (SELECT 1 FROM Alunos WHERE ra = p_ra_aluno AND Cursos_idCursos = curso_id) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Aluno já matriculado neste curso.';
  ELSE
    -- Insere o aluno na tabela Alunos
    INSERT INTO Alunos (nome, ra, email, Cursos_idCursos)
    VALUES (p_nome_aluno, p_ra_aluno, p_email_aluno, curso_id);
  END IF;
END;

$

DELIMITER ;