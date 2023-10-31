DELIMITER $

CREATE TRIGGER gerar_email_aluno
BEFORE INSERT ON Alunos
FOR EACH ROW
BEGIN
  SET NEW.email = CONCAT(NEW.nome, '.', NEW.sobrenome, '@dominio.com');
END$

DELIMITER ;