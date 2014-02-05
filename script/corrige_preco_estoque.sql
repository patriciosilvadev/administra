SET TERM ^ ;
CREATE OR ALTER PROCEDURE CORRIGE_PRECO_ESTOQUE
AS
DECLARE VARIABLE codPro				INTEGER; 
DECLARE VARIABLE precoUltimaCompra 	DOUBLE PRECISION; 
BEGIN
    --#####################################
    --#####################################
    -- Muda o preco de custo e preco medio 
    -- do cadastro do produto pelo da ultima 
    --compra   
    --#####################################
    --#####################################
    /* Pegando Produto a Produto */
	For Select codProduto from Produtos 
	  where ((USA = 'S') or (USA is null))
	    and PRECOMEDIO < 0
		into :codPro
	do begin
      SELECT FIRST 1 movdet.PRECO FROM MOVIMENTODETALHE movdet, MOVIMENTO mov            
       WHERE (mov.CODMOVIMENTO = movdet.CODMOVIMENTO) 
         and (movdet.codProduto = :codPro) 
         and (movdet.baixa IS NOT NULL) 
         and (mov.CODNATUREZA = 4) 
      order by mov.DATAMOVIMENTO desc
      INTO :precoUltimaCompra;
      
      if (precoUltimaCompra is null) THEN 
        precoUltimaCompra = 0;
    
      update PRODUTOS set VALORUNITARIOATUAL = :precoUltimaCompra, PRECOMEDIO = :precoUltimaCompra 
              where CODPRODUTO = :codPro;                        

    END -- Fecha o Produto 
END

