create database dbBanco2;
use dbBanco2;

create table tbUF (
	IdUF int auto_increment primary key,
	UF char(2) unique
);

create table tbBairro (
	IdBairro int auto_increment primary key,
	Bairro varchar(200)
);

create table tbCidade (
	IdCidade int auto_increment primary key,
	Cidade varchar(200)
);

create table tbEndereco (
	CEP varchar(8) primary key,
	Logradouro varchar(200),
	IdBairro int,
	IdCidade int,
	IdUF int,
    foreign key (IdBairro) references tbBairro(IdBairro),
    foreign key (IdCidade) references tbCidade(IdCidade),
	foreign key (IdUF) references tbUF(IdUF)
);

create table tbCliente (
	Id int primary key auto_increment,
	Nome varchar(50) not null,
	CEP varchar(8) not null,
	CompEnd varchar(50),
	foreign key (CEP) references tbEndereco(CEP)
);

create table tbClientePF (
	IdCliente int auto_increment,
	Cpf varchar(11) not null primary key,
	Rg varchar(8),
	RgDig varchar(1),
	Nasc date,
	foreign key (IdCliente) references tbCliente(Id)   
);

create table tbClientePJ (
	IdCliente int auto_increment,
	Cnpj varchar(14) not null primary key,
	Ie varchar(9),
    foreign key (IdCliente) references tbCliente(Id)
);

create table tbNotaFiscal (
	NF int primary key,
	TotalNota decimal(7, 2) not null,
	DataEmissao date not null
);

create table tbFornecedor (
	Codigo int primary key auto_increment,
	Cnpj varchar(14) not null,
	Nome varchar(200),
	Telefone varchar(11)
);

create table tbCompra (
	NotaFiscal int primary key,
	DataCompra date not null,
	ValorTotal decimal(8, 2) not null,
	QtdTotal int not null,
	Cod_Fornecedor int,
    IdCliente int,
    foreign key (IdCliente) references tbCliente(Id),    
	foreign key (NotaFiscal) references tbNotaFiscal(NF)
);

create table tbProduto (
	CodBarras bigint primary key,
	Qtd int,
	Nome varchar(50),
	ValorUnitario decimal(6, 2) not null
);

create table tbItemCompra (
	Qtd int not null,
	ValorItem decimal(6, 2) not null,
	NotaFiscal int,
	CodBarras bigint,
	primary key (NotaFiscal, CodBarras),
	foreign key (NotaFiscal) references tbCompra(NotaFiscal),
	foreign key (CodBarras) references tbProduto(CodBarras)
);

create table tbVenda (
	IdCliente int,
	NumeroVenda int auto_increment primary key,
	DataVenda date not null,
	TotalVenda decimal(7, 2) not null,
	NotaFiscal int,
    codigo int,
    foreign key (Codigo) references tbFornecedor(Codigo)
);

create table tbItemVenda (
	NumeroVenda int,
	CodBarras bigint,
	Qtd int,
	ValorItem decimal(6, 2),    
	primary key (NumeroVenda, CodBarras),
	foreign key (NumeroVenda) references tbVenda(NumeroVenda),
	foreign key (CodBarras) references tbProduto(CodBarras)
);
delimiter $$
create procedure spInsertFornecedor (vCNPJ numeric(13), vNome varchar(100) , vTelefone numeric(11))
begin
	insert into tbFornecedor(CNPJ, Nome, telefone) values(vCNPJ, vNome, vTelefone);
end $$

call spInsertFornecedor(1245678937123, "Revenda Chico Loco", 11934567897);
call spInsertFornecedor(1345678937123, "José Faz Tudo S/A", 11934567898);
call spInsertFornecedor(1445678937123, "Vadalto Entregas", 11934567899);
call spInsertFornecedor(1545678937123, "Astrogildo das Estrelas", 11934567800);
call spInsertFornecedor(1645678937123, "Amoroso e Doce", 11934567801);
call spInsertFornecedor(1745678937123, "Marcelo Dedal", 11934567802);
call spInsertFornecedor(1845678937123, "Franciscano Cachaça", 11934567803);
call spInsertFornecedor(1945678937123, "Joãozinho Chupeta", 11934567804);

-- select * from tbfornecedor;

delimiter $$
create procedure spInsertCidade (vCidade varchar(200))
begin
insert into tbCidade(Cidade) values (vCidade);
end
$$

call spInsertCidade("Rio de Janeiro");
call spInsertCidade("São Carlos");
call spInsertCidade("Campinas");
call spInsertCidade("Franco da Rocha");
call spInsertCidade("Osasco");
call spInsertCidade("Pirituba");
call spInsertCidade("Lapa");
call spInsertCidade("Ponta Grossa");

-- select * from tbCidade;
delimiter $$

create procedure spInsertUF (vUF char(2))
begin
insert into tbUf(UF) values (vUF);
end
$$

call spInsertUF("SP");
call spInsertUF("RJ");
call spInsertUF("RS");

-- select * from tbUf order by idUf

delimiter $$
create procedure spInsertBairro (vBairro char(200))
begin
insert into tbBairro(Bairro) values (vBairro);
end
$$

call spInsertBairro("Aclimação");
call spInsertBairro("Capão Redondo");
call spInsertBairro("Pirituba");
call spInsertBairro("Liberdade");

-- select * from tbBairro;

delimiter $$
create procedure spInsertProduto(vCodBarras bigint, vNome varchar(50), vValorUnitario decimal(6, 2), vQtd int)
begin
insert into tbProduto(CodBarras, Nome, ValorUnitario, Qtd) values (vCodBarras, vNome, vValorUnitario, vQtd);
end
$$
call spInsertProduto(12345678910111, "Rei de Papel Mache", 54.61, 120);
call spInsertProduto(12345678910112, "Bolinha de Sabão", 100.45, 120);
call spInsertProduto(12345678910113, "Carro Bate Bate", 44.00, 120);
call spInsertProduto(12345678910114, "Bola Furada", 10.00, 120);
call spInsertProduto(12345678910115, "Maçã Laranja", 99.44, 120);
call spInsertProduto(12345678910116, "Boneco do Hitler", 124.00, 200);
call spInsertProduto(12345678910117, "Farinha de Suruí", 54.61, 120);
call spInsertProduto(12345678910118, "Zelador de Cemitério", 24.50, 100);

-- select * from tbProduto;
/*
drop procedure spInsertEndereco;
delimiter $$
create procedure spInsertEndereco(vCEP varchar(8), vLogradouro varchar(200))
begin
if not exists(select CEP from tbEndereco where CEP = vCEP order by CEP desc limit 1) then
insert into tbendereco(CEP, Logradouro)
values(vCEP, vLogradouro);

end if;
end
$$
call spInsertEndereco('12345050', 'Rua da Federal');
select * from tbendereco
*/
