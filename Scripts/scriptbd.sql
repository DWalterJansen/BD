-- Criação das Tabelas do Banco de Dados --
-- DROP DATABASE BDI;
CREATE DATABASE BDI;
USE BDI;

-- Tabela País --
CREATE TABLE Pais( 
	Nome VARCHAR(50), 
	Nacionalidade VARCHAR(80) UNIQUE NOT NULL,
		CONSTRAINT PK_Pais PRIMARY KEY(Nome)
); 

-- Tabela Grupo --
CREATE TABLE Grupo( 
	Nome CHAR(1), 
	CONSTRAINT PK_Grupo PRIMARY KEY (Nome)
);

    -- Tabela Cidade --
	CREATE TABLE Cidade(
		NomeCidade  VARCHAR(50),
        Estado VARCHAR(50) not null, 
			CONSTRAINT PK_Cidade PRIMARY KEY (NomeCidade)
    );

-- Tabela Estádio --
CREATE TABLE Estadio(
	Nome VARCHAR(50) NOT NULL, 
	Cidade VARCHAR(50) NOT NULL, 
	Rua VARCHAR(50) NOT NULL, 
	Bairro VARCHAR(50) NOT NULL, 
	Numero INT, 
	Capacidade INT, 
		CONSTRAINT FK_CIDADE FOREIGN KEY (Cidade) REFERENCES Cidade(NomeCidade),
		CONSTRAINT PK_Estadio PRIMARY KEY (Nome)
); 
	    
-- Tabela Seleção --
CREATE TABLE Selecao(
	NomePais VARCHAR(50) UNIQUE NOT NULL,
    Nome VARCHAR(100) UNIQUE NOT NULL,
    Bandeira VARCHAR(150) NOT NULL,
    Continente VARCHAR(20) NOT NULL,
    LetraHino VARCHAR(4000),
    NomeGrupo CHAR(50) NOT NULL,
		CONSTRAINT FK_Pais FOREIGN KEY (NomePais) REFERENCES Pais(Nome),
		CONSTRAINT PK_Selecao PRIMARY KEY (NomePais, Nome)
);

-- Tabela Classificação --
CREATE TABLE Classificacao(
	NomeGrupo CHAR(1) NOT NULL,
    Posicao INT,
    NumDerrotas INT NOT NULL,
    NumEmpates INT NOT NULL,
    NumVitorias INT NOT NULL,
    Pontos INT NOT NULL,
    GolsMarcados INT NOT NULL,
    GolsSofridos INT NOT NULL, 
    NumCartaoVerm INT NOT NULL,
    NumCartaoAma INT NOT NULL,
    NomePais VARCHAR(50) NOT NULL, 
	NomeSelecao VARCHAR(100) NOT NULL,
		CONSTRAINT FK_Grupo FOREIGN KEY (NomeGrupo) REFERENCES Grupo(Nome),
        CONSTRAINT FK_PaisSelecaoC FOREIGN KEY (NomePais, NomeSelecao) REFERENCES Selecao(NomePais, Nome),
        CONSTRAINT PK_Classificacao PRIMARY KEY (Posicao, NomeGrupo)
);

    -- Tabela PassaporteDataN --
    CREATE TABLE PassaporteDataN(
		Passaporte VARCHAR(20) UNIQUE,
		DataNascimento DATE,
			CONSTRAINT PK_Pessoa PRIMARY KEY (Passaporte)
    );
    
-- Tabela Pessoa --
CREATE TABLE Pessoa(
	CodigoInterno VARCHAR(6),
    Passaporte VARCHAR(20) NOT NULL,
    Nome VARCHAR(200) NOT NULL,
		CONSTRAINT FK_PassaporteDataN FOREIGN KEY (Passaporte) REFERENCES PassaporteDataN(Passaporte),
    	CONSTRAINT PK_Pessoa PRIMARY KEY (CodigoInterno)
);

	-- Tabela Tipo --
    CREATE TABLE Tipo(
		CodigoInterno VARCHAR(6),
        TipoPessoa ENUM('Árbitro', 'Atleta'),
			CONSTRAINT FK_PessoaTipo  FOREIGN KEY (CodigoInterno) REFERENCES Pessoa(CodigoInterno),
			CONSTRAINT PK_Tipo PRIMARY KEY (CodigoInterno)
    );

-- Tabela Árbitro --
CREATE TABLE Arbitro(
	CodigoInterno VARCHAR(6),
	TipoArbitro ENUM('Árbitro', 'Auxiliar', 'VAR'),
		CONSTRAINT FK_PessoaArbitro  FOREIGN KEY (CodigoInterno) REFERENCES Pessoa(CodigoInterno),
        CONSTRAINT PK_Arbitro PRIMARY KEY (CodigoInterno)
);

-- Tabela Atleta --
CREATE TABLE Atleta(
	CodigoInterno VARCHAR(6),
    Altura decimal,
    Peso decimal,
    NomePais VARCHAR(50) NOT NULL,
    NomeSelecao VARCHAR(100) NOT NULL,
		CONSTRAINT FK_PaisSelecao FOREIGN KEY (NomePais, NomeSelecao) REFERENCES Selecao(NomePais, Nome),
		CONSTRAINT FK_PessoaAtleta  FOREIGN KEY (CodigoInterno) REFERENCES Pessoa(CodigoInterno),
        CONSTRAINT PK_Atleta PRIMARY KEY (CodigoInterno)
);

-- Tabela TipoPublicidade --
CREATE TABLE TipoPublicidade(
	Identificador VARCHAR(6),
    Tipo ENUM('Anunciante', 'Patrocinador'),
		 CONSTRAINT PK_TipoPublicidade PRIMARY KEY (Identificador)
);

-- Tabela Anunciante --
CREATE TABLE Anunciante(
	Identificador VARCHAR(6),
    Nome VARCHAR(50) NOT NULL,
		CONSTRAINT FK_TipoPublicidade1 FOREIGN KEY (Identificador) REFERENCES TipoPublicidade(Identificador),
        CONSTRAINT PK_Anunciante PRIMARY KEY (Identificador)
);

-- Tabela Patrocinador --
CREATE TABLE Patrocinador(
	Identificador VARCHAR(6),
    Nome VARCHAR(50) NOT NULL,
		CONSTRAINT FK_TipoPublicidade2 FOREIGN KEY (Identificador) REFERENCES TipoPublicidade(Identificador),
        CONSTRAINT PK_Patrocinador PRIMARY KEY (Identificador)
);

-- Tabela Jogo --
CREATE TABLE Jogo(
	NumeroIdentificador VARCHAR(6),
    PublicoPresente INT UNSIGNED,
    Fase VARCHAR(20) NOT NULL,
    Horario TIME NOT NULL,
	Renda DOUBLE ,
    Data DATE NOT NULL,
    NomeSelecaoMand VARCHAR(50) NOT NULL,
    NomePaisMand VARCHAR(50) NOT NULL,
    NomeSelecaoVisit VARCHAR(50) NOT NULL,
    NomePaisVisit VARCHAR(50) NOT NULL,
	NomeEstadio VARCHAR(50) NOT NULL,
		CONSTRAINT FK_PaisSelecaoMand FOREIGN KEY (NomePaisMand, NomeSelecaoMand) REFERENCES Selecao(NomePais, Nome),
		CONSTRAINT FK_PaisSelecaoVisit FOREIGN KEY (NomePaisVisit, NomeSelecaoVisit) REFERENCES Selecao(NomePais, Nome),
		CONSTRAINT FK_Estadio FOREIGN KEY (NomeEstadio) REFERENCES Estadio(Nome),
		CONSTRAINT PK_Jogo PRIMARY KEY (NumeroIdentificador)
);

-- Tabela Lance --
CREATE TABLE Lance(
	NumeroIdentificadorJogo VARCHAR(6),
    Instante VARCHAR(6) NOT NULL,
    Tipo ENUM('Gol', 'Penalti', 'Substituição', 'Cartão Vermelho', 'Cartão Amarelo', 'Falta', 'Lance Periogoso'),
    Descricao VARCHAR(150),
		CONSTRAINT FK_LanceJogo FOREIGN KEY (NumeroIdentificadorJogo) REFERENCES Jogo(NumeroIdentificador),
        CONSTRAINT PK_Lance PRIMARY KEY (Instante, Tipo, NumeroIdentificadorJogo)
);

-- Tabela Determina --
CREATE TABLE Determina(
	JogoDeterminado VARCHAR(6), 
    Fase VARCHAR(20) NOT NULL, 
    Jogo1 VARCHAR(6) NOT NULL,
    Jogo2 VARCHAR(6) NOT NULL,
		CONSTRAINT FK_Jogo1 FOREIGN KEY (Jogo1) REFERENCES Jogo(NumeroIdentificador),
        CONSTRAINT FK_Jogo2 FOREIGN KEY (Jogo2) REFERENCES Jogo(NumeroIdentificador), 
        CONSTRAINT FK_JogoDeterminado FOREIGN KEY (JogoDeterminado) REFERENCES Jogo(NumeroIdentificador), 
        CONSTRAINT PK_Determina PRIMARY KEY	(Jogo1, Jogo2, Fase)
);

-- Tabela PatrocinaJogo --
CREATE TABLE PatrocinaJogo(
	IdJogo VARCHAR(6),
    IdAnunciante VARCHAR(6),
		CONSTRAINT FK_JogoId FOREIGN KEY (IdJogo) REFERENCES Jogo(NumeroIdentificador),
        CONSTRAINT FK_Anunciante FOREIGN KEY (IdAnunciante) REFERENCES Anunciante(Identificador),
        CONSTRAINT PK_PatrocinaJogo PRIMARY KEY (IdJogo, IdAnunciante)
);

-- Tabela PatrocinaSeleção --
CREATE TABLE PatrocinaSelecao(
	IdPatrocinador VARCHAR(6),
    NomePais VARCHAR(50),
    NomeSelecao VARCHAR(100),
		CONSTRAINT FK_Patrocinador FOREIGN KEY (IdPatrocinador) REFERENCES Patrocinador(Identificador),
		CONSTRAINT FK_PaisSelecaoPatrocina FOREIGN KEY (NomePais, NomeSelecao) REFERENCES Selecao(NomePais, Nome),
		CONSTRAINT PK_PatrocinaSelecao PRIMARY KEY (NomePais, NomeSelecao, IdPatrocinador)
);

-- Tabela Participa --
CREATE TABLE Participa(
	CodAtleta VARCHAR(6),
    InstanteLance VARCHAR(6) NOT NULL,
    TipoLance ENUM('Gol', 'Penalti', 'Substituição', 'Cartão Vermelho', 'Cartão Amarelo', 'Falta', 'Lance Periogoso'),
    IdJogo VARCHAR(6),
		CONSTRAINT FK_ParticipaAtleta FOREIGN KEY (CodAtleta) REFERENCES Atleta(CodigoInterno),
        CONSTRAINT FK_ParticipaLance FOREIGN KEY (InstanteLance, TipoLance) REFERENCES Lance(Instante, Tipo),
		CONSTRAINT FK_ParticipaJogo FOREIGN KEY (IdJogo) REFERENCES Jogo(NumeroIdentificador),
        CONSTRAINT PK_Participa PRIMARY KEY (CodAtleta, InstanteLance, TipoLance, IdJogo)
);

-- Tabela Apita --
CREATE TABLE Apita(
	CodArbitro VARCHAR(6),
    IdJogo VARCHAR(6),
		CONSTRAINT FK_ApitaArbitro FOREIGN KEY(CodArbitro) REFERENCES Arbitro(CodigoInterno),
        CONSTRAINT FK_ApitaJogo FOREIGN KEY (IdJogo) REFERENCES Jogo(NumeroIdentificador),
        CONSTRAINT PK_Apita PRIMARY KEY (CodArbitro, IdJogo)
);

-- Tabela  PessoaTemPais --
CREATE TABLE PessoaTemPais(
	NomePais VARCHAR(50),
    CodigoInterno VARCHAR(6),
		CONSTRAINT FK_PaisP FOREIGN KEY (NomePais) REFERENCES Pais(Nome),
        CONSTRAINT FK_PessoaP FOREIGN KEY (CodigoInterno) REFERENCES Pessoa(CodigoInterno),
        CONSTRAINT PK_PessoaTemPais PRIMARY KEY (NomePais, CodigoInterno)
);

-- Tabela DisputaJogo --
CREATE TABLE DisputaJogo(
	CodAtleta VARCHAR(6),
    IDJogo VARCHAR(6),
    TitulaBanco ENUM('Titular', 'Banco'),
		CONSTRAINT FK_DisputaAtleta FOREIGN KEY (CodAtleta) REFERENCES Atleta(CodigoInterno),
        CONSTRAINT FK_DisputaJogo FOREIGN KEY (IdJogo) REFERENCES Jogo(NumeroIdentificador),
        CONSTRAINT PK_DisputaJogo PRIMARY KEY (CodAtleta, IdJogo)
);

