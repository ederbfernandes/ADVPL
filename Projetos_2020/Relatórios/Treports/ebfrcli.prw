#include 'TOTVS.ch'
#include 'parmtype.ch'
#include 'prtopdef.ch'


user function EBFRCLI()

//VARIAVEIS
private oReport := Nil
private oSecCab := Nil
private cPerg   := "EBFRCLI"

//Função responsavel por chamar a pergunta passada pela varialvel private cPerg
	
	Pergunte (cPerg,.F.)
	
	//Chamada da função que irá criar o relatório
	ReportDef()
	oReport:PrintDialog()
	 
	
return






/*/ {Protheus.doc} ReportDef - Função responsavel por estrutrar as seções e campos que darão forma ao relatório, bem como as  outras caracteristicas
   Aqui os campos contidos na querie, que você quer que apareça no relatório, são adicionadas.
/*/
   
Static Function ReportDef()

   oReport :=TReport():New("EBFRCLI","Relatório - Cadastro de Clientes - EBFConsult",cPerg,{|oReport|	PrintReport(oReport)},"Relatório de Impressao do Cadastro de Clientes")
   oReport:SetPortrait(.T.) // Significa que o relatório será em Paisagem

//TRsection - serve para controle da seçao do relatorio, neste caso, teremos somente uma
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

//ESTA LINHA IRA CONTAR A QUANTIDADE DE REGISTROS LISTADOS NO RELATORIO PARA A UNICA SEÇAO QUE TEMOS 
TRFunction():New(oSecCab:Cell("A1_COD"),,"COUNT"    ,,,,,.F.,.T.,.F.,oSecCab)


Return   
   


/*/ {Prtheus.doc} PrintReport
     Nesta função é inserida a querie utilizada para exibiçao dos dados 
     A função de perguntas é chamada para que os filtros possam ser montados 
     
/*/   
   
Static function PrintReport (oReport)

// Variável Responsavel por armazenar o Alias que será utilizado pela querie
Local cAlias:=GetNextAlias()
	
	
//Inicio da query
BeginSql Alias cAlias

   SELECT A1_COD, A1_LOJA, A1_NOME, A1_TIPO,A1_BAIRRO,A1_CGC FROM %table:SA1% SA1 //%table:% é responsavel por trazer o nome da tabela no BANCO DE DADOS
   WHERE A1_COD BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)%    //%exp:& é responsavel por transformar a variável das perguntas em filtros do relatório 
   AND D_E_L_E_T_ = ' '	
   // Observe que o campo A1_TIPO não será listado no relatório.
   
   
//Fim da Query
EndSql	


oSecCab:BeginQuery() //Relatório começa a ser estruturado
oSecCab:EndQuery({{"SQL"},cAlias})// Recebe a querie e constroi o relatório
oSecCab:Print() // é dada a ordem de impressão, visto os filtros selecionados

// O Alias usado para a execução da querie é fechado.
(cAlias)->(DbCloseArea())   
    
   
Return
   
   
   