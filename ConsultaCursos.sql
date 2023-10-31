delimiter $
create procedure consulta_cursos()
begin
    select *
    from Cursos;
end$
delimiter ;

call consulta_cursos;