
IDENTIFICATION DIVISION.
PROGRAM-ID. CADCLI.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 WS-OPCAO PIC X VALUE SPACE.

PROCEDURE DIVISION.
PRINCIPAL.
    PERFORM EXIBIR-MENU UNTIL WS-OPCAO = "0"
    DISPLAY "Encerrando Cadastro de Clientes..."
    STOP RUN.

EXIBIR-MENU.
    DISPLAY SPACE
    DISPLAY "=================================="
    DISPLAY "      CADASTRO DE CLIENTES"
    DISPLAY "=================================="
    DISPLAY "1 - Cadastrar cliente"
    DISPLAY "2 - Listar clientes"
    DISPLAY "3 - Consultar cliente"
    DISPLAY "4 - Alterar cliente"
    DISPLAY "5 - Excluir cliente"
    DISPLAY "0 - Sair"
    DISPLAY "=================================="
    DISPLAY "Escolha uma opcao: "
    ACCEPT WS-OPCAO

    EVALUATE WS-OPCAO
        WHEN "1"
            DISPLAY "Cadastro de cliente - em desenvolvimento."
        WHEN "2"
            DISPLAY "Listagem de clientes - em desenvolvimento."
        WHEN "3"
            DISPLAY "Consulta de cliente - em desenvolvimento."
        WHEN "4"
            DISPLAY "Alteracao de cliente - em desenvolvimento."
        WHEN "5"
            DISPLAY "Exclusao de cliente - em desenvolvimento."
        WHEN "0"
            CONTINUE
        WHEN OTHER
            DISPLAY "Opcao invalida. Tente novamente."
    END-EVALUATE.
 