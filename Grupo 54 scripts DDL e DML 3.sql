-- SCRIPT DDL - Criacao do banco de dados e tabelas
CREATE DATABASE gestao_universitaria;
GO
USE gestao_universitaria;
GO

-- Tabela de usuarios
CREATE TABLE usuarios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    tipo_usuario VARCHAR(20) NOT NULL CHECK (tipo_usuario IN ('administrador', 'aluno', 'docente', 'fornecedor')),
    ativo BIT DEFAULT 1,
    data_criacao DATETIME DEFAULT GETDATE()
);

-- Tabela de Pessoas fisicas
CREATE TABLE pessoa_fisica (
    id INT IDENTITY(1,1) PRIMARY KEY,
    usuario_id INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    data_nascimento DATE,
    telefone VARCHAR(20),
    endereco TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabela de Pessoas Juridicas
CREATE TABLE pessoa_juridica (
    id INT IDENTITY(1,1) PRIMARY KEY,
    usuario_id INT NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    cnpj VARCHAR(18) NOT NULL,
    telefone VARCHAR(20),
    endereco TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabela de alunos
CREATE TABLE alunos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pessoa_fisica_id INT NOT NULL,
    matricula VARCHAR(20) NOT NULL,
    curso VARCHAR(100) NOT NULL,
    data_matricula DATE DEFAULT GETDATE(),
    status VARCHAR(15) DEFAULT 'ativo' CHECK (status IN ('ativo', 'trancado', 'concluido')),
    FOREIGN KEY (pessoa_fisica_id) REFERENCES pessoa_fisica(id) ON DELETE CASCADE
);

-- Tabela de docentes
CREATE TABLE docentes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pessoa_fisica_id INT NOT NULL,
    titulacao VARCHAR(50) NOT NULL,
    area_atuacao VARCHAR(100),
    data_contratacao DATE DEFAULT GETDATE(),
    FOREIGN KEY (pessoa_fisica_id) REFERENCES pessoa_fisica(id) ON DELETE CASCADE
);

-- Tabela de Fornecedores
CREATE TABLE fornecedores (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pessoa_juridica_id INT NOT NULL,
    categoria_servico VARCHAR(100),
    data_cadastro DATE DEFAULT GETDATE(),
    status VARCHAR(15) DEFAULT 'ativo' CHECK (status IN ('ativo', 'inativo')),
    FOREIGN KEY (pessoa_juridica_id) REFERENCES pessoa_juridica(id) ON DELETE CASCADE
);
GO

-- SCRIPT DML - Insercao de dados de exemplo
INSERT INTO usuarios (email, senha_hash, tipo_usuario) VALUES
('admin@universidade.com', '1234', 'administrador'),
('joao.aluno@email.com', '1234', 'aluno'),
('maria.aluno@email.com', '1234', 'aluno'),
('carlos.docente@email.com', '1234', 'docente'),
('ana.docente@email.com', '1234', 'docente'),
('empresaabc@fornecedor.com', '1234', 'fornecedor'),
('techltda@fornecedor.com', '1234', 'fornecedor');

INSERT INTO pessoa_fisica (usuario_id, nome, cpf, data_nascimento, telefone, endereco) VALUES
(2, 'Joao Silva', '1234', '2000-05-15', '1234', 'Rua A, 123 - Sao Paulo/SP'),
(3, 'Maria Souza', '1234', '2001-08-22', '1234', 'Rua B, 456 - Sao Paulo/SP'),
(4, 'Carlos Mendes', '1234', '1985-03-10', '1234', 'Rua C, 789 - Sao Paulo/SP'),
(5, 'Ana Lima', '1234', '1990-07-19', '1234', 'Rua D, 101 - Sao Paulo/SP');

INSERT INTO pessoa_juridica (usuario_id, razao_social, cnpj, telefone, endereco) VALUES
(6, 'Empresa ABC Ltda', '1234', '1234', 'Av. Paulista, 1000 - Sao Paulo/SP'),
(7, 'Tech LTDA', '1234', '1234', 'Rua Tecnologia, 500 - Sao Paulo/SP');

INSERT INTO alunos (pessoa_fisica_id, matricula, curso) VALUES
(1, '1234', 'ADS'),
(2, '1234', 'TI');

INSERT INTO docentes (pessoa_fisica_id, titulacao, area_atuacao) VALUES
(3, 'Mestre', 'Banco de Dados'),
(4, 'Doutora', 'Inteligencia Artificial');

INSERT INTO fornecedores (pessoa_juridica_id, categoria_servico) VALUES
(1, 'Material de escritorio'),
(2, 'Equipamentos de informatica');
GO

-- VIEWS (apenas para VISUALIZACAO)
CREATE VIEW vw_meus_dados_aluno AS
SELECT 
    pf.nome, pf.cpf, pf.data_nascimento, pf.telefone, pf.endereco,
    a.matricula, a.curso, a.status
FROM pessoa_fisica pf
JOIN alunos a ON pf.id = a.pessoa_fisica_id;
GO

CREATE VIEW vw_meus_dados_docente AS
SELECT 
    pf.nome, pf.cpf, pf.data_nascimento, pf.telefone, pf.endereco,
    d.titulacao, d.area_atuacao
FROM pessoa_fisica pf
JOIN docentes d ON pf.id = d.pessoa_fisica_id;
GO

CREATE VIEW vw_meus_dados_fornecedor AS
SELECT 
    pj.razao_social, pj.cnpj, pj.telefone, pj.endereco,
    f.categoria_servico, f.status
FROM pessoa_juridica pj
JOIN fornecedores f ON pj.id = f.pessoa_juridica_id;
GO

-- para ATUALIZACAO
CREATE PROCEDURE atualizar_telefone_endereco_aluno
    @p_usuario_id INT,
    @p_telefone VARCHAR(20),
    @p_endereco TEXT
AS
BEGIN
    UPDATE pessoa_fisica 
    SET telefone = @p_telefone, endereco = @p_endereco
    WHERE usuario_id = @p_usuario_id;
END;
GO

CREATE PROCEDURE atualizar_telefone_endereco_docente
    @p_usuario_id INT,
    @p_telefone VARCHAR(20),
    @p_endereco TEXT
AS
BEGIN
    UPDATE pessoa_fisica 
    SET telefone = @p_telefone, endereco = @p_endereco
    WHERE usuario_id = @p_usuario_id;
END;
GO

CREATE PROCEDURE atualizar_telefone_endereco_fornecedor
    @p_usuario_id INT,
    @p_telefone VARCHAR(20),
    @p_endereco TEXT
AS
BEGIN
    UPDATE pessoa_juridica 
    SET telefone = @p_telefone, endereco = @p_endereco
    WHERE usuario_id = @p_usuario_id;
END;

