/* 
------------------------------------------------------------------------------------------------------------
AUTOR: Franklin V Nascimento        DATA: 29/03/2010
------------------------------------------------------------------------------------------------------------
DESCRIÇÃO: ROTINA QUE VASCULHA O VALOR DESEJADO EM TODOS OS CAMPOS DE TODAS AS TABELAS DE UM SCHEMA 
------------------------------------------------------------------------------------------------------------
*/

DECLARE

  VOWNER VARCHAR2(30);    -- VAR OWNER
  VDATATYPE VARCHAR2(30); -- VAR DATATYPE DA COLUNA
  VVALOR VARCHAR2(30);    -- VAR VALOR QUE DESEJA-SE ENCONTRAR
  VSQL VARCHAR2(3000);    -- VAR GERAÇÃO DO SQL
  VLOC NUMBER;            -- VAR FLAG LOCALIZADO

  VTAB VARCHAR2(30);      -- VAR TABELA
  VCOL VARCHAR2(30);      -- VAR COLUNA

  BEGIN
  -- QUE HAJA LUZ! \o/


  -- ATRIBUIÇÕES DE PARÂMETROS
  VOWNER:= 'PCREP';
  VVALOR:= 'C3PO';
  VDATATYPE:='VARCHAR2';

    
  -- VASCULHA TODAS AS TABELAS DO BANCO PELO OWNER
  FOR CTABLE IN (select T.TABLE_NAME from ALL_TABLES T where T.OWNER = VOWNER)
    LOOP
    -- VASCULHA TODAS AS COLUNAS DE CADA TABELA PELO DATATYPE
    FOR CCOL IN(SELECT DISTINCT C.COLUMN_NAME FROM ALL_TAB_COLUMNS C WHERE C.TABLE_NAME = CTABLE.TABLE_NAME AND C.DATA_TYPE = VDATATYPE AND C.OWNER = VOWNER)
      LOOP
      -- GERA COMANDO SELECT PARA LOCALIZAR O VALOR DESEJADO
      VSQL:='SELECT COUNT(1),'''||CTABLE.TABLE_NAME||''','''||CCOL.COLUMN_NAME||''' FROM '||VOWNER||'.'||CTABLE.TABLE_NAME||' WHERE TO_CHAR('||CCOL.COLUMN_NAME||') = '''||VVALOR||'''';
      -- EXECUTA O COMANDO SQL
      EXECUTE IMMEDIATE VSQL INTO VLOC, VTAB, VCOL;
      -- IMPRIME SOMENTE SE LOCALIZAR O VALOR
      IF (VLOC != 0 )
        THEN
          DBMS_OUTPUT.put_line(VLOC||' TABELA: '||VTAB||' | COLUNA: '||VCOL);
        END IF;
    END LOOP;
  END LOOP;
END;
