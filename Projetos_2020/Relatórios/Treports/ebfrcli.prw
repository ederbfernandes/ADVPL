#include 'TOTVS.ch'
#include 'parmtype.ch'
#include 'prtopdef.ch'


user function EBFRCLI()

//VARIAVEIS
private oReport := Nil
private oSecCab := Nil
private cPerg   := "EBFRCLI"

//Fun��o responsavel por chamar a pergunta passada pela varialvel private cPerg
	
	Pergunte (cPerg,.F.)
	
	//Chamada da fun��o que ir� criar o relat�rio
	ReportDef()
	oReport:PrintDialog()
	 
	
return






/*/ {Protheus.doc} ReportDef - Fun��o responsavel por estrutrar as se��es e campos que dar�o forma ao relat�rio, bem como as  outras caracteristicas
   Aqui os campos contidos na querie, que voc� quer que apare�a no relat�rio, s�o adicionadas.
/*/
   
Static Function ReportDef()

   oReport :=TReport():New("EBFRCLI","Relat�rio - Cadastro de Clientes - EBFConsult",cPerg,{|oReport|	PrintReport(oReport)},"Relat�rio de Impressao do Cadastro de Clientes")
   oReport:SetPortrait(.T.) // Significa que o relat�rio ser� em Paisagem

//TRsection - serve para controle da se�ao do relatorio, neste caso, teremos somente uma
oSecCab :=TRSection():New(oReport,"Cadastro de Clientes",{"SQL"})

/*
TrCell serve para inserir os campos /colunas que voce quer no relatorio , lembrando que devem ser os mesmos campos que contem na Querie
Um detalhe importante , todos os campos contidos nas linhas abaixo, devem estar na querie, mas..
voce pode colocar campos 	na querie e adicionar aqui em baixo, conforme a sua necessidade.
*/

TRCell():New( oSecCab, "A1_COD"      , "SQL")
TRCell():New( oSecCab, "A1_LOJA"     , "SQL")
TRCell():New( oSecCab, "A1_NOME"     , "SQL")
TRCell():New( oSecCab, "A1_BAIRRO"   , "SQL")
TRCell():New( oSecCab, "A1_CGC"      , "SQL")	

//ESTA LINHA IRA CONTAR A QUANTIDADE DE REGISTROS LISTADOS NO RELATORIO PARA A UNICA SE�AO QUE TEMOS 
TRFunction():New(oSecCab:Cell("A1_COD"),,"COUNT"    ,,,,,.F.,.T.,.F.,oSecCab)


Return   
   


/*/ {Prtheus.doc} PrintReport
     Nesta fun��o � inserida a querie utilizada para exibi�ao dos dados 
     A fun��o de perguntas � chamada para que os filtros possam ser montados 
     
/*/   
   
Static function PrintReport (oReport)

// Vari�vel Responsavel por armazenar o Alias que ser� utilizado pela querie
Local cAlias:=GetNextAlias()
	
	
//Inicio da query
BeginSql Alias cAlias

   SELECT A1_COD, A1_LOJA, A1_NOME, A1_TIPO,A1_BAIRRO,A1_CGC FROM %table:SA1% SA1 //%table:% � responsavel por trazer o nome da tabela no BANCO DE DADOS
   WHERE A1_COD BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)%    //%exp:& � responsavel por transformar a vari�vel das perguntas em filtros do relat�rio 
   AND D_E_L_E_T_ = ' '	
   // Observe que o campo A1_TIPO n�o ser� listado no relat�rio.
   
   
//Fim da Query
EndSql	


oSecCab:BeginQuery() //Relat�rio come�a a ser estruturado
oSecCab:EndQuery({{"SQL"},cAlias})// Recebe a querie e constroi o relat�rio
oSecCab:Print() // � dada a ordem de impress�o, visto os filtros selecionados

// O Alias usado para a execu��o da querie � fechado.
(cAlias)->(DbCloseArea())   
    
   
Return
   
   
   