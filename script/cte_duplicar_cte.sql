SET TERM ^ ;

CREATE OR ALTER PROCEDURE CTE_DUPLICAR_CTE
 ( cte_origem INTEGER ) 
RETURNS 
 ( cod_nova_cte Integer,
   num_nova_cte Integer
 ) 
AS 
BEGIN
  SELECT MAX(cte.CTE_NUMERO) FROM CTE
  into :num_nova_cte;
  num_nova_cte = num_nova_cte + 1;
  cod_nova_cte = GEN_ID(GEN_CTE,1);
  INSERT INTO CTE (COD_CTE, CODEMITENTE, CTE_ESTADO,
    CTE_CHAVE, CTE_CFOP, CTE_NATOP, IFORPAG,
    MODELO, CTE_SERIE, CTE_NUMERO, DHEMI, TPIMP,
    TPOEMISSAO, TIPOAMBIENTE, TIPOCTE, PROCEMI,
    VERPROC, REFCTE, CODIGOMUNICIPIO,
    EMPRESACIDADE, EMPRESAESTADO, MODAL,
    TIPOSERVICO, ENV_CODCIDADE, ENV_CIDADE,
    ENV_ESTADO, INI_CODCIDADE, INI_CIDADE,
    INI_ESTADO, FIM_CODCIDADE, FIM_CIDADE,
    FIM_ESTADO, RETIRA, DETRETIRA, EMITENTE, E_RG,
    E_CNPJCPF, E_IESTADUAL, E_RSOCIAL, E_FANTASIA,
    E_TELEFONE, E_ENDERECO, E_NUMERO,
    E_COMPLEMENTO, E_BAIRRO, E_CODIGOMUNICIPI,
    E_CIDADE, E_CEP, E_ESTADO, E_CODIGOPAIS,
    E_PAIS, TOMADORSERVICO, T_RG, T_CNPJCPF,
    T_IESTADUAL, T_RSOCIAL, T_FANTASIA,
    T_TELEFONE, T_ENDERECO, T_NUMERO,
    T_COMPLEMENTO, T_BAIRRO, T_CODIGOMUNICIPI,
    T_CIDADE, T_CEP, T_ESTADO, T_CODIGOPAIS,
    T_PAIS, REMETENTE, R_RG, R_CNPJCPF,
    R_IESTADUAL, R_RSOCIAL, R_FANTASIA,
    R_TELEFONE, R_ENDERECO, R_NUMERO,
    R_COMPLEMENTO, R_BAIRRO, R_CODIGOMUNICIPI,
    R_CIDADE, R_CEP, R_ESTADO, R_CODIGOPAIS,
    R_PAIS, DESTINATARIO, D_RG, D_CNPJCPF,
    D_IESTADUAL, D_RSOCIAL, D_FANTASIA,
    D_TELEFONE, D_ENDERECO, D_NUMERO,
    D_COMPLEMENTO, D_BAIRRO, D_CODIGOMUNICIPI,
    D_CIDADE, D_CEP, D_ESTADO, D_CODIGOPAIS,
    D_PAIS, EXPEDITOR, EX_RG, EX_CNPJCPF,
    EX_IESTADUAL, EX_RSOCIAL, EX_FANTASIA,
    EX_TELEFONE, EX_ENDERECO, EX_NUMERO,
    EX_COMPLEMENTO, EX_BAIRRO, EX_CODIGOMUNICIPI,
    EX_CIDADE, EX_CEP, EX_ESTADO, EX_CODIGOPAIS,
    EX_PAIS, CARAC_TRANSP, CARAC_SERV, FUNC_EMI,
    DET_RETIRA, VPREST, VREC, COMPONENTE,
    VCOMPONENTE, VALTOTTRI, COMBCODSITTRIB,
    STATUS, VALINFCARGA, PROPRED, OUTCAT, RNTRC,
    DATARODPREV, RGRODLOTACAO, OBS_GERAL, 
    CHCTE, RECEBEDOR, RE_RG, RE_CNPJCPF,
    RE_IESTADUAL, RE_RSOCIAL, RE_FANTASIA,
    RE_TELEFONE, RE_ENDERECO, RE_NUMERO,
    RE_COMPLEMENTO, RE_BAIRRO, RE_CODIGOMUNICIPI,
    RE_CIDADE, RE_CEP, RE_ESTADO, RE_CODIGOPAIS,
    RE_PAIS, OUTPDOC, OUDESCOUTRO, OUNDOC, OUDEMI,
    OUVDOCFISC, ANT_CNPJ, ANT_IE, ANT_UF,
    ANT_NOME, ANT_CHCTE, IN_IMPOSTOS, VALPREDBC,
    VALVBC, VALPICMS, VALVICMS, VALVCRED)
  SELECT :cod_nova_cte, CODEMITENTE, CTE_ESTADO,
    CTE_CHAVE, CTE_CFOP, CTE_NATOP, IFORPAG,
    MODELO, CTE_SERIE, :num_nova_cte, DHEMI, TPIMP,
    TPOEMISSAO, TIPOAMBIENTE, TIPOCTE, PROCEMI,
    VERPROC, REFCTE, CODIGOMUNICIPIO,
    EMPRESACIDADE, EMPRESAESTADO, MODAL,
    TIPOSERVICO, ENV_CODCIDADE, ENV_CIDADE,
    ENV_ESTADO, INI_CODCIDADE, INI_CIDADE,
    INI_ESTADO, FIM_CODCIDADE, FIM_CIDADE,
    FIM_ESTADO, RETIRA, DETRETIRA, EMITENTE, E_RG,
    E_CNPJCPF, E_IESTADUAL, E_RSOCIAL, E_FANTASIA,
    E_TELEFONE, E_ENDERECO, E_NUMERO,
    E_COMPLEMENTO, E_BAIRRO, E_CODIGOMUNICIPI,
    E_CIDADE, E_CEP, E_ESTADO, E_CODIGOPAIS,
    E_PAIS, TOMADORSERVICO, T_RG, T_CNPJCPF,
    T_IESTADUAL, T_RSOCIAL, T_FANTASIA,
    T_TELEFONE, T_ENDERECO, T_NUMERO,
    T_COMPLEMENTO, T_BAIRRO, T_CODIGOMUNICIPI,
    T_CIDADE, T_CEP, T_ESTADO, T_CODIGOPAIS,
    T_PAIS, REMETENTE, R_RG, R_CNPJCPF,
    R_IESTADUAL, R_RSOCIAL, R_FANTASIA,
    R_TELEFONE, R_ENDERECO, R_NUMERO,
    R_COMPLEMENTO, R_BAIRRO, R_CODIGOMUNICIPI,
    R_CIDADE, R_CEP, R_ESTADO, R_CODIGOPAIS,
    R_PAIS, DESTINATARIO, D_RG, D_CNPJCPF,
    D_IESTADUAL, D_RSOCIAL, D_FANTASIA,
    D_TELEFONE, D_ENDERECO, D_NUMERO,
    D_COMPLEMENTO, D_BAIRRO, D_CODIGOMUNICIPI,
    D_CIDADE, D_CEP, D_ESTADO, D_CODIGOPAIS,
    D_PAIS, EXPEDITOR, EX_RG, EX_CNPJCPF,
    EX_IESTADUAL, EX_RSOCIAL, EX_FANTASIA,
    EX_TELEFONE, EX_ENDERECO, EX_NUMERO,
    EX_COMPLEMENTO, EX_BAIRRO, EX_CODIGOMUNICIPI,
    EX_CIDADE, EX_CEP, EX_ESTADO, EX_CODIGOPAIS,
    EX_PAIS, CARAC_TRANSP, CARAC_SERV, FUNC_EMI,
    DET_RETIRA, VPREST, VREC, COMPONENTE,
    VCOMPONENTE, VALTOTTRI, COMBCODSITTRIB,
    STATUS, VALINFCARGA, PROPRED, OUTCAT, RNTRC,
    DATARODPREV, RGRODLOTACAO, OBS_GERAL, 
    CHCTE, RECEBEDOR, RE_RG, RE_CNPJCPF,
    RE_IESTADUAL, RE_RSOCIAL, RE_FANTASIA,
    RE_TELEFONE, RE_ENDERECO, RE_NUMERO,
    RE_COMPLEMENTO, RE_BAIRRO, RE_CODIGOMUNICIPI,
    RE_CIDADE, RE_CEP, RE_ESTADO, RE_CODIGOPAIS,
    RE_PAIS, OUTPDOC, OUDESCOUTRO, OUNDOC, OUDEMI,
    OUVDOCFISC, ANT_CNPJ, ANT_IE, ANT_UF,
    ANT_NOME, ANT_CHCTE, IN_IMPOSTOS, VALPREDBC,
    VALVBC, VALPICMS, VALVICMS, VALVCRED 
    FROM CTE 
    WHERE COD_CTE = :cte_origem;
    Suspend;
end;
