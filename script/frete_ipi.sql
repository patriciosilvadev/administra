Set term ^ ;
CREATE OR ALTER TRIGGER FRETE_IPI FOR COMPRA ACTIVE
AFTER INSERT OR UPDATE POSITION 0
AS 
declare variable codm INTEGER;
declare variable coddet INTEGER;
declare variable det1 INTEGER;
declare variable det INTEGER;
declare variable x INTEGER;
declare variable FRETE double precision;
declare variable DESCONTO double precision;
declare variable OUTRAS double precision;
declare variable SEGURO double precision;
declare variable FRETE_UNIT double precision;
declare variable DESCONTO_UNIT double precision;
declare variable OUTRAS_UNIT double precision;
declare variable SEGURO_UNIT double precision;
declare variable FRETE_TOTAL double precision;
declare variable DESCONTO_TOTAL double precision;
declare variable OUTRAS_TOTAL double precision;
declare variable SEGURO_TOTAL double precision;
declare variable valtot double precision;
declare variable vp double precision;
declare variable custo1 varchar(10);
declare variable custo2 varchar(10);
declare variable custo3 varchar(10);
BEGIN
  -- versao 3.1
  /*select pmt.D1, pmt.D2, pmt.D3 from parametro pmt where pmt.PARAMETRO = 'CUSTO_PRODUTO'
    into :custo1, custo2, custo3;
  */
  if ((new.VALOR_FRETE > 0) or (new.VALOR_IPI > 0) or (new.VALOR_SEGURO > 0)) then 
  begin  
   
   vp = new.VALOR; 
   
   FRETE = new.VALOR_FRETE;
   
   DESCONTO = new.VALOR_DESCONTO;
   OUTRAS = new.OUTRAS_DESP;
   SEGURO = new.VALOR_SEGURO;

   if (frete is null) then
    frete = 0;
   if (desconto is null) then
    desconto = 0; 
   if (OUTRAS is null) then
    OUTRAS = 0; 
   if (SEGURO is null) then
    SEGURO = 0; 
    
   if (vp is null) then 
     vp = 0; 
     
   if (vp = 0) then 
   begin
     if (new.BASE_ICMS > 0) then 
       vp = new.BASE_ICMS; 
     if (vp = 0) then 
       vp = new.VALOR_PRODUTO;      
   end 
     

   if ( vp > 0) then
   begin
     Frete_UNIT = new.VALOR_FRETE / vp;
     DESCONTO_UNIT = new.VALOR_DESCONTO / vp;
     OUTRAS_UNIT = new.OUTRAS_DESP / vp;
     SEGURO_UNIT = new.VALOR_SEGURO / vp;
   end
   
   Frete_TOTAL = new.VALOR_FRETE;
   DESCONTO_TOTAL = new.VALOR_DESCONTO;
   OUTRAS_TOTAL = new.OUTRAS_DESP;
   SEGURO_TOTAL = new.VALOR_SEGURO;
   --insert into LOG_ACESSO (ID_LOG, LOGIN, USUARIO) VALUES (GEN_ID(GEN_AVISOS, 1), 'NF', 'FRETE ' || :FRETE_TOTAL || ' VP ' || :vp);
   
   select count(md.CODDETALHE) from MOVIMENTODETALHE md
   where md.CODMOVIMENTO = :codm
   into :det;
   det1 = 1;
   for select md.CODDETALHE, (md.VALTOTAL) from MOVIMENTODETALHE md
   where md.CODMOVIMENTO = :codm
   into :coddet, :valtot
   do begin
	if ((valtot is null) or (valtot = 0)) then
		valtot = 1;
	if (inserting) then
	begin
	 if (levaDesc = 'N') then 
	 begin 
	   update MOVIMENTODETALHE set FRETE = UDF_ROUNDDEC((:Frete_UNIT * :valtot), 2), valor_desconto = UDF_ROUNDDEC((:DESCONTO_UNIT * :valtot), 2), 
	     valor_outros = UDF_ROUNDDEC((:OUTRAS_UNIT * :valtot), 2), valor_SEGURO = UDF_ROUNDDEC((:SEGURO_UNIT * :valtot), 2) where CODDETALHE = :coddet;
	   if ( det = det1) then
	   update MOVIMENTODETALHE set FRETE = :Frete_TOTAL, valor_desconto = :DESCONTO_TOTAL, valor_seguro = :SEGURO_TOTAL, 
	     valor_outros = :OUTRAS_TOTAL where CODDETALHE = :coddet;
	   --insert into LOG_ACESSO (ID_LOG, LOGIN, USUARIO) VALUES (GEN_ID(GEN_AVISOS, 1), 'NF', 'FRETE ' || :FRETE_TOTAL || ' VALTOT ' || :valtot);   
	 end    
	 if (levaDesc = 'S') then 
	 begin 
	   update MOVIMENTODETALHE set FRETE = UDF_ROUNDDEC((:Frete_UNIT * :valtot), 2), 
	     valor_outros = UDF_ROUNDDEC((:OUTRAS_UNIT * :valtot), 2), 
	     valor_SEGURO = UDF_ROUNDDEC((:SEGURO_UNIT * :valtot), 2) 
	     where CODDETALHE = :coddet;
	   if ( det = det1) then
	   update MOVIMENTODETALHE set FRETE = :Frete_TOTAL, valor_seguro = :SEGURO_TOTAL, 
	     valor_outros = :OUTRAS_TOTAL 
	     where CODDETALHE = :coddet;
	 end    
	 
    end
	else begin 
      if((old.VALOR_FRETE <> new.VALOR_FRETE) or (old.VALOR_DESCONTO <> new.VALOR_DESCONTO) or (old.VALOR_SEGURO <> new.VALOR_SEGURO) or (old.OUTRAS_DESP <> new.OUTRAS_DESP)) then
      begin
	   if (levaDesc = 'N') then 
	   begin      
         update MOVIMENTODETALHE set FRETE = UDF_ROUNDDEC((:Frete_UNIT * :valtot), 2), valor_desconto = UDF_ROUNDDEC(((new.VALOR_DESCONTO * :valtot)/(:vp)), 2), 
           valor_outros = UDF_ROUNDDEC((:OUTRAS_UNIT * :valtot), 2), valor_SEGURO = UDF_ROUNDDEC((:SEGURO_UNIT * :valtot), 2)
           where CODDETALHE = :coddet;
         if ( det = det1) then
	       update MOVIMENTODETALHE set FRETE = :Frete_TOTAL, valor_desconto = :DESCONTO_TOTAL, valor_seguro = :SEGURO_TOTAL, 
	         valor_outros = :OUTRAS_TOTAL
	         where CODDETALHE = :coddet;
	   end      
	   if (levaDesc = 'S') then 
	   begin      
         update MOVIMENTODETALHE set FRETE = UDF_ROUNDDEC((:Frete_UNIT * :valtot), 2), 
           valor_outros = UDF_ROUNDDEC((:OUTRAS_UNIT * :valtot), 2), 
           valor_SEGURO = UDF_ROUNDDEC((:SEGURO_UNIT * :valtot), 2)
           where CODDETALHE = :coddet;
         if ( det = det1) then
	       update MOVIMENTODETALHE set FRETE = :Frete_TOTAL, 
	         valor_seguro = :SEGURO_TOTAL, 
	         valor_outros = :OUTRAS_TOTAL
	         where CODDETALHE = :coddet;
	   end      
      end
    end  
    det1 = det1 +1;
    Frete_TOTAL   = Frete_TOTAL - UDF_ROUNDDEC((:Frete_UNIT * :valtot), 2);
    DESCONTO_TOTAL = DESCONTO_TOTAL - UDF_ROUNDDEC(((new.VALOR_DESCONTO * :valtot)/(vp)), 2);
    OUTRAS_TOTAL = OUTRAS_TOTAL - UDF_ROUNDDEC((:OUTRAS_UNIT * :valtot), 2);
    SEGURO_TOTAL = SEGURO_TOTAL - UDF_ROUNDDEC((:SEGURO_UNIT * :valtot), 2);
   end
  end  
END
