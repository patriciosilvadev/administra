SET TERM ^ ;
ALTER PROCEDURE ESTOQUE_VIEW_CUSTO (
    DTA1 DATE,
    PROD1 INTEGER,
    CCUSTO INTEGER,
    LOTE VARCHAR(60) )
RETURNS (
    CODPROD VARCHAR(20),
    MESANO VARCHAR(10),
    CODPRODUTO INTEGER,
    PRODUTO VARCHAR(300),
    GRUPO VARCHAR(30),
    SUBGRUPOPROD VARCHAR(30),
    SALDOINIACUM DOUBLE PRECISION,
    ENTRADA DOUBLE PRECISION,
    SAIDA DOUBLE PRECISION,
    SALDOFIMACUM DOUBLE PRECISION,
    ESTOQUE_MES DOUBLE PRECISION,
    PRECOUNIT DOUBLE PRECISION,
    PRECOCUSTO DOUBLE PRECISION,
    VALORESTOQUE DOUBLE PRECISION,
    VALORVENDA DOUBLE PRECISION,
    PRECOCOMPRA DOUBLE PRECISION,
    PRECOVENDA DOUBLE PRECISION,
    LOTES VARCHAR(60),
    CCUSTOS INTEGER )
AS
DECLARE VARIABLE PROD integer;
DECLARE VARIABLE CCUSTOESTOQUE integer;
DECLARE VARIABLE INI smallint;
DECLARE VARIABLE SOMA_ENTRADA double precision; 
DECLARE VARIABLE SOMA_SAIDA double precision;
DECLARE VARIABLE ESTOQUE_INI double precision; 
DECLARE VARIABLE ESTOQUE_X double precision;
DECLARE VARIABLE SOMA_SAI double precision;
DECLARE VARIABLE SOMA_ENT double precision;
DECLARE VARIABLE ultimoDiaMes date;
DECLARE VARIABLE MesEstoque date;
BEGIN
  -- versao 3.0
  PROD = 0;
  INI  = 0;
  SOMA_ENTRADA = 0;
  SOMA_SAIDA   = 0;
  mesEstoque = '01.01.01';

  select CAST(COALESCE(DADOS, '0') as INTEGER) FROM PARAMETRO WHERE PARAMETRO = 'CCUSTOESTOQUE'
    into :CCUSTOESTOQUE;
    
  if (CCUSTOESTOQUE IS NULL) THEN 
    ccustoEstoque = 0;  
   
  if (ccusto = 0) then 
    ccusto = 1;
  
  --if (ccustoEstoque <> 0) then   
  --  ccusto = 1;

  ultimoDiaMes = UDF_MONTHEND(UDF_YEAR(:DTA1), UDF_MONTH(:DTA1));
  /*
  -- se o estoque esta fechado uso os dados da estoque mes
  for select first 1 em.SALDOESTOQUE, em.PRECOCUSTO, em.PRECOVENDA
     , em.CENTROCUSTO, em.LOTE, em.PRECOCOMPRA, em.PRECOCUSTO, em.PRECOVENDA, em.MESANO
    from ESTOQUEMES em 
   where em.CODPRODUTO = :prod1 
     and em.MESANO = :dta1
     and ((em.CENTROCUSTO = :CCUSTO) or (:CCUSTO = 1))
     and ((em.LOTE = :LOTE) or (em.LOTE is null) or (:LOTE = 'TODOS OS LOTES CADASTRADOS NO SISTEMA')) 
   order by em.MESANO desc 
    into :ESTOQUE_INI, :PRECOUNIT, :VALORVENDA,  :CCUSTOS, :LOTES, 
      :PRECOCOMPRA, :PRECOCUSTO, :PRECOVENDA, :MesEstoque
    do begin 
      if (prod = 0) then 
        saldoiniacum = estoque_ini;
      --prod = 1;
    end  

  if (ultimoDiaMes = mesEstoque) then  
  begin 

  end 
  else begin 
  */
     if (ultimoDiaMes > dta1) then 
        ultimoDiaMes = UDF_MONTHEND(UDF_YEAR(:DTA1), UDF_MONTH(UDF_INCMONTH(:DTA1,-1)));
  
    
    mesEstoque = dta1;  
    prod = 0;   
    --lotes = '1';
    --suspend;
    for select first 1 em.SALDOESTOQUE, em.PRECOCUSTO, em.PRECOVENDA
       , em.CENTROCUSTO, em.LOTE, em.PRECOCOMPRA, em.PRECOCUSTO, em.PRECOVENDA, em.MESANO
      from ESTOQUEMES em 
     where em.CODPRODUTO = :prod1 
       and em.MESANO <= :ultimoDiaMes
       and ((em.CENTROCUSTO = :CCUSTO) or (:CCUSTO = 1))
       and ((em.LOTE = :LOTE) or (em.LOTE is null) or (:LOTE = 'TODOS OS LOTES CADASTRADOS NO SISTEMA')) 
     order by em.MESANO desc 
      into :ESTOQUE_INI, :PRECOUNIT, :VALORVENDA,  :CCUSTOS, :LOTES, 
        :PRECOCOMPRA, :PRECOCUSTO, :PRECOVENDA, :MesEstoque
      do begin 
        if (prod = 0) then 
          saldoiniacum = estoque_ini;
        prod = 1;
        if (MesEstoque = dta1) then 
          ini = 1;
        --lotes = '2';
        --suspend;         
      end  
      --suspend;   
      if (soma_entrada is null) then 
        soma_entrada = 0;
   
      if (soma_saida is null) then 
        soma_saida = 0;

      if (estoque_ini is null) then 
        estoque_ini = 0;
        
      if (mesEstoque = dta1) then 
        mesEstoque = '01/01/01';
      --mesano = datamov; 
      if (ini = 0) then 
      begin  
        FOR SELECT CODPROD, SALDOINIACUM, ENTRADA, SAIDA,      SALDOFIMACUM, PRECOUNIT, VALORVENDA,  CCUSTOS, LOTES, 
          GRUPO, PRECOCOMPRA, PRECOVENDA, PRECOCUSTO
         from SPESTOQUEFILTRO(UDF_INCDAY(:mesEstoque,1) , :DTA1, :Prod1, :Prod1, 'TODOS SUBGRUPOS DO CADASTRO CATEGORIA', 
          100, :CCUSTO, 'TODAS AS MARCAS CADASTRADAS NO SISTEMA', :LOTE, 'TODOS OS GRUPOS CADASTRADOS NO SISTEMA') ep
         into :CODPROD,  :ESTOQUE_X, :SOMA_ENT, :SOMA_SAI, :SALDOFIMACUM, :PRECOUNIT, :VALORVENDA,  :CCUSTOS, :LOTES, 
          :GRUPO, :PRECOCOMPRA, :PRECOVENDA, :PRECOCUSTO
        do begin     
          if (prod = 0) then 
            saldoiniacum = ESTOQUE_X;
          prod = 1;   
          if (soma_ent is null) then 
            soma_ent = 0;
          if (soma_sai is null) then 
            soma_sai = 0;
          if (saldoiniacum is null) then 
            saldoiniacum = 0;       
          SOMA_ENTRADA = SOMA_ENTRADA + SOMA_ENT;
          SOMA_SAIDA = SOMA_SAIDA + SOMA_SAI;
          --lotes = '3' || soma_entrada;
          --suspend;
        end
     end
 --  end  
   ENTRADA = SOMA_ENTRADA;
   SAIDA  = SOMA_SAIDA; 
   
   if (saldoiniacum is null) then 
     saldoiniacum = 0;

     SALDOFIMACUM = ENTRADA + saldoiniacum - SAIDA;   
     
   --if (saldofimacum < 0.00001) then 
   --  saldofimacum = 0;  

   if (lotes = 'TODOS OS LOTES SISTEMA') then 
      lotes = '0';

   if (lotes = '') then 
      lotes = '0';

   if (lotes is null) then 
      lotes = '0';
      
   if (precocusto is null) THEN 
     precocusto = 0;   

     SELECT FIRST 1 movdet.PRECO FROM MOVIMENTODETALHE movdet, MOVIMENTO mov            
       WHERE (mov.CODMOVIMENTO = movdet.CODMOVIMENTO) 
         and (movdet.codProduto = :Prod1) 
         and (movdet.baixa IS NOT NULL) 
         and (mov.CODNATUREZA in (1,4)) 
         and (mov.DATAMOVIMENTO <= :dta1)
      order by mov.DATAMOVIMENTO desc , mov.CODMOVIMENTO desc
      INTO :precoCompra;

   if (precocompra is null) THEN 
     precocompra = 0;   
   
   if (precocusto <= 0) THEN 
     precocusto = precocompra;
     
   if (precocusto <= 0) then -- busca o preco da ultima compra 
   begin 
     SELECT FIRST 1 movdet.PRECO FROM MOVIMENTODETALHE movdet, MOVIMENTO mov            
       WHERE (mov.CODMOVIMENTO = movdet.CODMOVIMENTO) 
         and (movdet.codProduto = :Prod1) 
         and (movdet.baixa IS NOT NULL) 
         and (mov.CODNATUREZA in (1,4)) 
         and (mov.DATAMOVIMENTO <= :dta1)
      order by mov.DATAMOVIMENTO desc, mov.CODMOVIMENTO desc 
      INTO :precoCusto;
      if (precoCusto is null) then 
        precoCusto = 0;
        
      if (precoCusto = 0) then -- procura no cadastro do PRODUTO 
      begin
        SELECT CASE WHEN COALESCE(P.VALORUNITARIOATUAL,0) > 0 then COALESCE(P.VALORUNITARIOATUAL,0) else coalesce(p.PRECOMEDIO, 0) end 
         FROM PRODUTOS P WHERE P.CODPRODUTO = :Prod1 
          into :PrecoCusto;
        if (precoCusto is null) then 
          precoCusto = 0;
      end    
        
      if (precoCompra <= 0) then 
        precoCompra = precoCusto;  
   end  
    
   Suspend;
   
   SOMA_ENTRADA = 0;
   SOMA_SAIDA = 0;
   
END
^
SET TERM ; ^


GRANT EXECUTE
 ON PROCEDURE ESTOQUE_VIEW_CUSTO TO  SYSDBA;

