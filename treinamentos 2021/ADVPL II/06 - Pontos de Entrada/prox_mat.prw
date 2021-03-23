#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} PROX_MAT
Funçao para gerar matricula dentro do range original quando há problema de sequencia
@type function
@version 12.1.27,12.1.25
@author Eder Fernandes
@since 20/03/2021
@return 
/*/
User Function PROX_MAT

Local aArea	   := GetArea()
Local cQuery   := ""
Local cRetorno := ""

cQuery:= " SELECT MAX(RA_MAT) AS RA_MAT FROM "+RetSQLName("SRA")+" SRA WHERE D_E_L_E_T_ <> '*' "
cQuery+= " 			AND RA_CATFUNC <> 'A' "
cQuery+= " 			AND RA_MAT <= '888999' "

cQuery := ChangeQuery(cQuery)

if Select("PROX") > 0
	PROX->(DbCloseArea())
endif

TcQuery cQuery New Alias "PROX"

IF !PROX->(EOF())
	cRetorno := PROX->RA_MAT
Endif
cRetorno := soma1(cRetorno)

PROX->(DbCloseArea())

RestArea(aArea)

Return(cRetorno)
