<h1 align="center"> Alunos & Cursos </h1>

### No Execício a seguir sera realizada a criação das tabelas Alunos e Cursos Esse modelo lógico reflete as necessidades do banco de dados da universidade, incluindo a relação entre alunos, cursos e áreas, a geração automática de e-mails, as restrições de unicidade e as operações desejadas através de stored procedures e funções. Você precisará traduzir esse modelo em SQL para criar as tabelas e implementar as stored procedures e funções no seu sistema de gerenciamento de banco de dados (por exemplo, MySQL, PostgreSQL, SQL Server, etc.)

• Cada curso pode pertencer a somente uma área;

1-  Utilize Stored Procedures para automatizar a inserção e seleção dos cursos;
Procedure para insert na tabela curso :
```SQL
delimiter $
create procedure insert_cursos(
disciplina varchar(100)
)
begin
    insert into cursos (disciplina) values (disciplina);
end$
delimiter ;
```


Procedure para selecionar os cursos
```SQL
delimiter $
create procedure consulta_cursos()
begin
    select *
    from Cursos;
end$
delimiter ;
```
![image](https://github.com/AndreFelipefer/Faculdade/assets/129207232/a4cf3580-6763-4769-848c-ad93053ab4d8)



<hr>




2-  O aluno possui um e-mail que deve ter seu endereço gerado automaticamente no
seguinte formato: nome.sobrenome@dominio.com
```SQL
DELIMITER $

CREATE TRIGGER gerar_email_aluno
BEFORE INSERT ON Alunos
FOR EACH ROW
BEGIN
  SET NEW.email = CONCAT(NEW.nome, '.', NEW.sobrenome, '@dominio.com');
END$

DELIMITER ;
```
Imagem: 

![image](https://github.com/AndreFelipefer/Faculdade/assets/129207232/16457b2e-b261-4eeb-b0bf-68ede486a31e)


3- Crie uma rotina que recebe os dados de um novo curso e o insere no banco de dados;
```SQL
DELIMITER $

CREATE PROCEDURE inserir_curso(
  IN p_disciplina VARCHAR(100)
)
BEGIN
  INSERT INTO Cursos (disciplina) VALUES (p_disciplina);
END;

$

DELIMITER ;
```
Chamando a função
```SQL
CALL inserir_curso('Banco de Dados');
```

4- Crie uma função que recebe o nome de um curso e sua área, em seguida retorna o id do
curso;
```SQL
DELIMITER $

CREATE FUNCTION obter_id_curso(
  p_nome_curso VARCHAR(100),
  p_area_curso VARCHAR(100)
)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE curso_id INT;
  
  SELECT idCursos INTO curso_id
  FROM Cursos
  WHERE disciplina = p_nome_curso AND area = p_area_curso;
  
  RETURN curso_id;
END;
$

DELIMITER ;

```
Chamando a função:
```SQL
SELECT obter_id_curso('Nome do Curso', 'Área do Curso');
```

5- Crie uma procedure que recebe os dados do aluno e de um curso e faz sua matrícula;
```SQL
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

  -- Insere o aluno na tabela Alunos
  INSERT INTO Alunos (nome, ra, email, Cursos_idCursos)
  VALUES (p_nome_aluno, p_ra_aluno, p_email_aluno, curso_id);
END;

$

DELIMITER ;
```

Chamando a função
```SQL
CALL matricular_aluno('Nome do Aluno', 'RA do Aluno', 'Email do Aluno', 'Nome do Curso');
```

6- Caso o aluno já esteja matriculado em um curso, essa matrícula não pode ser realizada;
```SQL
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
```
Chamando a função:
```SQL
CALL matricular_aluno('Nome do Aluno', 'RA do Aluno', 'Email do Aluno', 'Nome do Curso');
```

6-  Crie o modelo lógico do exercício.
```SQL
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Faculdade
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Faculdade
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Faculdade` DEFAULT CHARACTER SET utf8 ;
USE `Faculdade` ;

-- -----------------------------------------------------
-- Table `Faculdade`.`Cursos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Faculdade`.`Cursos` (
  `idCursos` INT NOT NULL AUTO_INCREMENT,
  `disciplina` VARCHAR(100) NULL,
  PRIMARY KEY (`idCursos`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Faculdade`.`Alunos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Faculdade`.`Alunos` (
  `idAlunos` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NULL,
  `sobrenome` VARCHAR(100) NULL,
  `ra` VARCHAR(100) NULL,
  `email` VARCHAR(100) NULL,
  `Cursos_idCursos` INT NOT NULL,
  PRIMARY KEY (`idAlunos`, `Cursos_idCursos`),
  INDEX `fk_Alunos_Cursos_idx` (`Cursos_idCursos` ASC) VISIBLE,
  CONSTRAINT `fk_Alunos_Cursos`
    FOREIGN KEY (`Cursos_idCursos`)
    REFERENCES `Faculdade`.`Cursos` (`idCursos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


```
![image](https://github.com/AndreFelipefer/Faculdade/assets/129207232/7a47964d-1b57-4ffe-9b09-ec7f3c0fd0f6)

# FIM


