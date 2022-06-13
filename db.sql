/*CREATE DATABASE dbdistribuidora;
use dbdistribuidora;

create table tbestado(
	estado char(2) not null,
    UFId int primary key auto_increment
);

create table tbcidade(
	idcidade int primary key auto_increment,
    cidade varchar(200) not null
);

create table tbBairro(
    logradouro varchar(100) not null,
    Idbairro varchar(100) primary key
);

create table tbendereco(
	-- IDendereco int primary key auto_increment,
    logradouro varchar(200) not null,
    bairro int,
    cidade int,
    uf int,
    compEndereco int,
    cep int primary key,
    foreign key (uf) references tbestado(UFId),
    foreign key (cidade) references tbcidade(idcidade)
);

alter table tbendereco add constraint fk_tbBairro foreign key (bairro) references tbBairro(Idbairro);

create table tbpessoa(
	idCli int primary key auto_increment,
    nomeCli varchar(200) not null,
	numLog int,
    cep int,
    IDendereco int,
    foreign key (cep) references tbendereco(cep)
);

create table tbclientePJ(
	cnpj numeric(14) not null primary key,
    IE numeric(11) unique,
    idCli int,
    foreign key (idCli) references tbpessoa(idCli)
);

CREATE TABLE tbclientePF (
    cpf numeric(14) PRIMARY KEY,
    dataNasc DATE not null,
    idCli INT,
    rg numeric(9) not null,
    rg_dig char(1) not null,
    FOREIGN KEY (idCli)
        REFERENCES tbpessoa (idCli)
        
);

----------
create table tbfornecedor(
	codFornecedor int primary key auto_increment,
    cnpj numeric(14) unique,
    nomeFornecedor varchar(200) not null,
    tel numeric(11) null
);

create table tbproduto(
	codigoBarras numeric(14) primary key,
    nomeProd varchar(200) not null,
    valorUnit decimal(8,2) not null,
    qtd int null
);

create table tbcompra(
	NotaFiscal int primary key,
    dataCompra date not null,
    valorTotal decimal(8,2) not null,
    qtdTotal int not null,
    codFornecedor numeric(10),
    foreign key (codFornecedor) references tbfornecedor(codFornecedor)
);


----------------------------

create table tbNF(
	NF int primary key,
    totalNota decimal(8,2) not null,
    dataEmissao date not null
);

create table tbvenda(
	numeroVenda int primary key auto_increment,
    dataVenda date default (current_date()),
    totalVenda decimal(8,2) not null,
    NF int,
    Id int,
    idCli int not null,
    foreign key (NF) references tbNF(NF),
    foreign key (idCli) references tbpessoa(idCli)
);
create table tbItemVenda(
    Qtd int not null,
    ValorItem decimal(8,2),
    numeroVenda, CodigoBarras primary key,
    foreign key (numeroVenda) references tbvenda (NumeroVenda),
    foreign key (NotaFiscal) references tb (NotaFiscal)
);

create table tbItemCompra(
    CodigoBarras int,
    NotaFiscal int primary key,
    Qtd int not null,
    ValorItem decimal(8,2) not null,
    foreign key (numeroCompra) references tbCompra (NumeroCompra),
    foreign key (NotaFiscal) references tbCompra (NotaFiscal)
);

drop database dbdistribuidora;*/



-- --------------------------------------------------
create database dbBanco;
use dbBanco;

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
	CodBarras int primary key,
	Qtd int,
	Nome varchar(50),
	ValorUnitario decimal(6, 2) not null
);

create table tbItemCompra (
	Qtd int not null,
	ValorItem decimal(6, 2) not null,
	NotaFiscal int,
	CodBarras int,
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
	CodBarras int,
	Qtd int,
	ValorItem decimal(6, 2),    
	primary key (NumeroVenda, CodBarras),
	foreign key (NumeroVenda) references tbVenda(NumeroVenda),
	foreign key (CodBarras) references tbProduto(CodBarras)
);
use dbbanco;
delimiter $$
-- drop procedure spInsertFornecedor;
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

delimiter $$
create procedure spInsertCidade (vIdCidade int, vCidade varchar(200))
begin
insert into tbCidade(IdCidade, Cidade) values (vIdCidade, vCidade);
end
$$

call spInsertCidade(1, "Rio de Janeiro");
call spInsertCidade(2, "São Carlos");
call spInsertCidade(3, "Campinas");
call spInsertCidade(4, "Franco da Rocha");
call spInsertCidade(5, "Osasco");
call spInsertCidade(6, "Pirituba");
call spInsertCidade(7, "Lapa");
call spInsertCidade(8, "Ponta Grossa");

select * from tbCidade;


delimiter $$

create procedure spInsertUF (vIdUf int, vUF char(2))
begin
insert into tbUf(idUf, UF) values (vIdUf, vUF);
end
$$

call spInsertUF(1, "SP");
call spInsertUF(2, "RJ");
call spInsertUF(3, "RS");

select * from tbuf;
-- delete from tbUf where IdUf>0;

delimiter $$
create procedure spInsertProduto(vCodBarras int, vQtd int, vNome varchar(50), vValorUnitario decimal(6, 2))
begin
insert into tbProduto(CodBarras, Qtd, Nome, ValorUnitario) values (vCodBarras, vQtd, vNome, vValorUnitario);
end
$$
call spInsertProduto(12345678910111, "Rei de Papel Mache", 54.61, 120);
call spInsertProduto(12345678910112, "Bolinha de Sabão", 100.45, 120);
call spInsertProduto(12345678910113, "Carro Bate Bate", 44.00, 120);
call spInsertProduto(12345678910114, "Bola Furada", 10.00, 120);
call spInsertProduto(12345678910115, "Maçã Laranja", 99.44, 120);
call spInsertProduto(12345678910116, "Boneco do Hitler", 124.00, 200);
call spInsertProduto(12345678910117, "Farinha de Suruí", 54.61, 120);

/* insert into tbFornecedor (CNPJ, NomeFornecedor, telefone) values (1245678937123,"Revenda Chico Loco",11934567897);
insert into tbFornecedor (CNPJ, NomeFornecedor, telefone) values (1345678937123,"José Faz Tudo S/A",11934567898);
insert into tbFornecedor (CNPJ, NomeFornecedor, telefone) values (1445678937123,"Vadalto Entregas",11934567899);
insert into tbFornecedor (CNPJ, NomeFornecedor, telefone) values (1545678937123,"Astrogildo das Estrelas",11934567800);
insert into tbFornecedor (CNPJ, NomeFornecedor, telefone) values (1645678937123,"Amoroso e Doce",11934567801);
insert into tbFornecedor (CNPJ, NomeFornecedor, telefone) values (1745678937123,"Marcelo Dedal",11934567802);
insert into tbFornecedor (CNPJ, NomeFornecedor, telefone) values (1845678937123,"Franciscano Cachaça",11934567803);
insert into tbFornecedor (CNPJ, NomeFornecedor, telefone) values (1945678937123,"Joãozinho Chupeta",11934567804); */

/* select * from tbFornecedor 
where Codigo = (select Codigo from tbFornecedor where telefone = 11934567800);
*/

