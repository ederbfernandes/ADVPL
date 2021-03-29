#Include 'totvs.ch'
#Include 'FwMvcDef.ch'


/*/{Protheus.doc} User Function BRWSZ9
    Tela básica em MVC
    @type  Function
    @author Eder Fernandes
    @since 29/03/2021
    @version 1.0
    /*/
User Function BRWSZ9()

	Local aArea := GetNextAlias()
	Local oBrowseSz9

        oBrowseSz9 := FwmBrowse():New()
        oBrowseSz9:SetAlias("SZ9")
        oBrowseSz9:SetDescription("Tela Cadastro")
        oBrowseSz9:Activate()

	RestArea(aArea)


Return
