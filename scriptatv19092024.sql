/* Alvaro Oliveira RGM: 11221103413 */

create table Paciente (
id_paciente INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100),
especie VARCHAR(50),
idade int 
);

create table Veterinários (
id_veterinario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100),
especialidade VARCHAR(50)
);

create table Consultas (
    id_consulta INT PRIMARY KEY AUTO_INCREMENT ,
    id_paciente INT,
    id_veterinario INT,
    data_consulta date,
    custo decimal(10, 2),
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_veterinario) REFERENCES Veterinários(id_veterinario)
);
delimiter //
create procedure agendar_consulta(
    IN id_paciente int,
    IN id_veterinario int,
    IN data_consulta date,
    IN custo decimal(10, 2)
)
begin
    insert into Consultas (id_paciente, id_veterinario, data_consulta, custo)
    values (id_paciente, id_veterinario, data_consulta, custo);
end //
delimiter ;
delimiter //
create procedure atualizar_paciente(
    IN id_paciente int,
    IN novo_nome varchar(100),
    IN nova_especie varchar(50),
    IN nova_idade int
)
begin
    update Paciente
    set nome = novo_nome,
        especie = nova_especie,
        idade = nova_idade
    where id_paciente = id_paciente;
end //
delimiter ;
delimiter //
create procedure remover_consulta(
    in id_consulta int
)
begin
   delete from Consultas
    where id_consulta = id_consulta;
end // 
delimiter ;
delimiter //
create function total_gasto_pac(id_paciente int)
returns decimal(10, 2)
begin
    return (
        select (sum(custo), 0)
        from Consultas
        where id_paciente = id_paciente
    );
end //
delimiter ;
DELIMITER //
 create trigger verificar_idade_paciente
before insert on Paciente
for each row
begin   
    if new.idade <= 0 then
	set new.idade = 1;        
    end if;
end //
delimiter ;
create table Log_Consultas (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta int,
    custo_antigo decimal(10, 2),
    custo_novo decimal(10, 2),
    foreign key (id_consulta) references Consultas(id_consulta)
);
delimiter //
create trigger atualizar_custo_consulta
after update on Consultas
for each row
begin
    if old.custo <> new.custo then
        insert into Log_Consultas (id_consulta, custo_antigo, custo_novo)
        values (old.id_consulta, old.custo, new.custo);
    end if;
end //
delimiter ;