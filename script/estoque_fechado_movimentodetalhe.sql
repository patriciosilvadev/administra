set term ^ ;
CREATE OR ALTER TRIGGER estoque_fechado_movdet FOR MOVIMENTODETALHE
ACTIVE BEFORE INSERT OR UPDATE OR DELETE POSITION 0
AS
  declare variable data_estoque date; 
  declare variable data_mov date; 
  declare variable natureza integer; 
  declare variable codmov integer; 
BEGIN 
  select first 1 em.MESANO from estoquemes em order by em.MESANO desc 
  	into :data_estoque;

  if (DELETING or UPDATING)	then 
  begin
    codmov = old.CODMOVIMENTO;
  end  
  else begin
    codmov = new.CODMOVIMENTO;
  end
  select m.CODNATUREZA, m.DATAMOVIMENTO from movimento m 
   where m.CODMOVIMENTO = :codMov
    into :natureza, :data_mov;
  
  if ((data_mov <= data_estoque) and (natureza in (1,2,3,4))) then
    exception ESTOQUEFECHADO; 	     

END