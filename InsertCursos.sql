delimiter $
create procedure insert_cursos(
disciplina varchar(100)
)
begin
    insert into cursos (disciplina) values (disciplina);
end$
delimiter ;