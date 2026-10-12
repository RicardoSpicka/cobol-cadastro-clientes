
IDENTIFICATION DIVISION.
PROGRAM-ID. CADCLI.

*> ==================================================
*> CONFIGURACAO DO AMBIENTE E DOS ARQUIVOS
*> ==================================================
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.

    *> Arquivo principal: cadastro de clientes
    SELECT ARQUIVO-CLIENTES
        ASSIGN TO "dados/CLIENTES.DAT"
        ORGANIZATION IS SEQUENTIAL
        FILE STATUS IS WS-FILE-STATUS.

    *> Arquivo temporario: recebe os dados durante
    *> alteracoes e exclusoes antes da substituicao
    SELECT ARQUIVO-TEMPORARIO
        ASSIGN TO "dados/CLIENTES.TMP"
        ORGANIZATION IS SEQUENTIAL
        FILE STATUS IS WS-STATUS-TEMP.

    *> Copia de seguranca do cadastro principal
    SELECT ARQUIVO-BACKUP
        ASSIGN TO "dados/CLIENTES.BAK"
        ORGANIZATION IS SEQUENTIAL
        FILE STATUS IS WS-STATUS-BACKUP.

    *> Arquivo anterior, preservado na substituicao
    SELECT ARQUIVO-RECUPERACAO
        ASSIGN TO "dados/CLIENTES.OLD"
        ORGANIZATION IS SEQUENTIAL
        FILE STATUS IS WS-STATUS-OLD.


*> ==================================================
*> DEFINICAO DOS REGISTROS DOS ARQUIVOS
*> ==================================================
DATA DIVISION.
FILE SECTION.

*> Registro principal do cliente: 114 caracteres
FD ARQUIVO-CLIENTES.
01 REGISTRO-CLIENTE.
   05 ARQ-CODIGO       PIC X(5).
   05 ARQ-NOME         PIC X(40).
   05 ARQ-CPF          PIC X(14).
   05 ARQ-TELEFONE     PIC X(15).
   05 ARQ-EMAIL        PIC X(40).

*> Registro utilizado no processamento temporario
FD ARQUIVO-TEMPORARIO.
01 REGISTRO-TEMPORARIO.
   05 TMP-CODIGO       PIC X(5).
   05 TMP-NOME         PIC X(40).
   05 TMP-CPF          PIC X(14).
   05 TMP-TELEFONE     PIC X(15).
   05 TMP-EMAIL        PIC X(40).

*> Registro da copia de seguranca
FD ARQUIVO-BACKUP.
01 REGISTRO-BACKUP.
   05 BAK-CODIGO       PIC X(5).
   05 BAK-NOME         PIC X(40).
   05 BAK-CPF          PIC X(14).
   05 BAK-TELEFONE     PIC X(15).
   05 BAK-EMAIL        PIC X(40).

*> Registro preservado para recuperacao manual
FD ARQUIVO-RECUPERACAO.
01 REGISTRO-RECUPERACAO PIC X(114).


WORKING-STORAGE SECTION.
*> ==================================================
*> CONTROLE GERAL DO PROGRAMA
*> ==================================================
01 WS-CONTROLE-GERAL.
   05 WS-OPCAO                PIC X VALUE SPACE.
   05 WS-ARQUIVO-ABERTO       PIC X VALUE "N".
   05 WS-FIM-ARQUIVO          PIC X VALUE "N".
   05 WS-FILE-STATUS          PIC XX.

*> ==================================================
*> DADOS DO CLIENTE
*> ==================================================
01 WS-CLIENTE.
   05 WS-CODIGO               PIC X(5).
   05 WS-NOME                 PIC X(40).
   05 WS-CPF                  PIC X(14).
   05 WS-TELEFONE             PIC X(15).
   05 WS-EMAIL                PIC X(40).

*> ==================================================
*> CONTROLE DE CONSULTA
*> ==================================================
01 WS-CONTROLE-CONSULTA.
   05 WS-CODIGO-BUSCA         PIC X(5).
   05 WS-CLIENTE-ENCONTRADO   PIC X VALUE "N".

*> ==================================================
*> CONTROLE DE ALTERACAO E EXCLUSAO
*> ==================================================
01 WS-CONTROLE-MANUTENCAO.
   05 WS-CODIGO-ALTERAR       PIC X(5).
   05 WS-CLIENTE-ALTERADO     PIC X VALUE "N".
   05 WS-ERRO-ALTERACAO       PIC X VALUE "N".
   05 WS-STATUS-TEMP          PIC XX.

*> ==================================================
*> GERACAO AUTOMATICA DE CODIGO
*> ==================================================
01 WS-CONTROLE-CODIGO.
   05 WS-MAIOR-CODIGO         PIC X(5) VALUE "00000".
   05 WS-PROXIMO-CODIGO       PIC 9(5) VALUE ZERO.
   05 WS-CODIGO-DISPONIVEL    PIC X VALUE "N".

*> ==================================================
*> CONTROLE DE BACKUP
*> ==================================================
01 WS-CONTROLE-BACKUP.
   05 WS-BACKUP-OK            PIC X VALUE "N".
   05 WS-QTD-ORIGINAL         PIC 9(9) VALUE ZERO.
   05 WS-QTD-BACKUP           PIC 9(9) VALUE ZERO.
   05 WS-STATUS-BACKUP        PIC XX.
   05 WS-ERRO-BACKUP          PIC X VALUE "N".
   05 WS-LEITURA-OK           PIC X VALUE "N".
   05 WS-STATUS-LEITURA       PIC XX.
   05 WS-ERRO-LEITURA-CODIGO  PIC X VALUE "N".
   
*> ==================================================
*> CONTROLE DE SUBSTITUICAO E RECUPERACAO
*> ==================================================
01 WS-CONTROLE-SUBSTITUICAO.
   05 WS-SUBSTITUICAO-OK      PIC X VALUE "N".
   05 WS-STATUS-OLD           PIC XX.

PROCEDURE DIVISION.
PRINCIPAL.
    PERFORM EXIBIR-MENU UNTIL WS-OPCAO = "0"
    
    IF WS-ARQUIVO-ABERTO = "S"
       CLOSE ARQUIVO-CLIENTES    
       MOVE "N" TO WS-ARQUIVO-ABERTO    
    END-IF

    DISPLAY "Encerrando Cadastro de Clientes..."
    STOP RUN.


*> ==================================================
*> ROTINAS PRINCIPAIS            
*> ==================================================
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
            PERFORM CADASTRAR-CLIENTE
        WHEN "2"
            PERFORM LISTAR-CLIENTES
        WHEN "3"
            PERFORM CONSULTAR-CLIENTE
        WHEN "4"
            PERFORM ALTERAR-CLIENTE
        WHEN "5"
            PERFORM EXCLUIR-CLIENTE
        WHEN "0"
            CONTINUE
        WHEN OTHER
            DISPLAY "Opcao invalida. Tente novamente."
    END-EVALUATE.


CADASTRAR-CLIENTE.
    PERFORM ABRIR-ARQUIVO-CLIENTES

    IF WS-ARQUIVO-ABERTO = "N"
        EXIT PARAGRAPH
    END-IF

    PERFORM CALCULAR-PROXIMO-CODIGO

    IF WS-CODIGO-DISPONIVEL = "N"
        EXIT PARAGRAPH
    END-IF

    DISPLAY SPACE
    DISPLAY "=== CADASTRO DE CLIENTE ==="
    DISPLAY "Codigo gerado: " WS-CODIGO

    DISPLAY "Nome: "
    ACCEPT WS-NOME

    DISPLAY "CPF: "
    ACCEPT WS-CPF

    DISPLAY "Telefone: "
    ACCEPT WS-TELEFONE

    DISPLAY "E-mail: "
    ACCEPT WS-EMAIL

    MOVE WS-CODIGO   TO ARQ-CODIGO
    MOVE WS-NOME     TO ARQ-NOME
    MOVE WS-CPF      TO ARQ-CPF
    MOVE WS-TELEFONE TO ARQ-TELEFONE
    MOVE WS-EMAIL    TO ARQ-EMAIL

    WRITE REGISTRO-CLIENTE

    IF WS-FILE-STATUS = "00"
        DISPLAY "Cliente gravado com sucesso!"
        DISPLAY "Codigo: " WS-CODIGO
        DISPLAY "Nome: " WS-NOME
    ELSE
        DISPLAY "Erro ao gravar cliente. Status: "
            WS-FILE-STATUS
    END-IF.


LISTAR-CLIENTES.   
    DISPLAY SPACE            
    DISPLAY "=== LISTA DE CLIENTES ==="            

    IF WS-ARQUIVO-ABERTO = "S"
        CLOSE ARQUIVO-CLIENTES
        MOVE "N" TO WS-ARQUIVO-ABERTO
    END-IF

    OPEN INPUT ARQUIVO-CLIENTES

    IF WS-FILE-STATUS NOT = "00"
        DISPLAY "Erro ao abrir arquivo para leitura. Status: "
            WS-FILE-STATUS
        EXIT PARAGRAPH
    END-IF

    MOVE "N" TO WS-FIM-ARQUIVO

    PERFORM UNTIL WS-FIM-ARQUIVO = "S"
        READ ARQUIVO-CLIENTES
            AT END
                MOVE "S" TO WS-FIM-ARQUIVO
            NOT AT END
                DISPLAY "------------------------"
                DISPLAY "Codigo: " ARQ-CODIGO
                DISPLAY "Nome: " ARQ-NOME
                DISPLAY "CPF: " ARQ-CPF
                DISPLAY "Telefone: " ARQ-TELEFONE
                DISPLAY "E-mail: " ARQ-EMAIL
        END-READ
    END-PERFORM

    CLOSE ARQUIVO-CLIENTES.


CONSULTAR-CLIENTE.
    DISPLAY SPACE
    DISPLAY "=== CONSULTA DE CLIENTE ==="
    DISPLAY "Digite o codigo: "
    ACCEPT WS-CODIGO-BUSCA

    IF WS-ARQUIVO-ABERTO = "S"
        CLOSE ARQUIVO-CLIENTES
        MOVE "N" TO WS-ARQUIVO-ABERTO
    END-IF

    OPEN INPUT ARQUIVO-CLIENTES

    IF WS-FILE-STATUS NOT = "00"
        DISPLAY "Erro ao abrir arquivo. Status: "
            WS-FILE-STATUS
        EXIT PARAGRAPH
    END-IF

    MOVE "N" TO WS-FIM-ARQUIVO
    MOVE "N" TO WS-CLIENTE-ENCONTRADO

    PERFORM UNTIL WS-FIM-ARQUIVO = "S"
        READ ARQUIVO-CLIENTES
            AT END
                MOVE "S" TO WS-FIM-ARQUIVO
            NOT AT END
                IF ARQ-CODIGO = WS-CODIGO-BUSCA
                    MOVE "S" TO WS-CLIENTE-ENCONTRADO

                    DISPLAY SPACE
                    DISPLAY "=== CLIENTE ENCONTRADO ==="
                    DISPLAY "Codigo: " ARQ-CODIGO
                    DISPLAY "Nome: " ARQ-NOME
                    DISPLAY "CPF: " ARQ-CPF
                    DISPLAY "Telefone: " ARQ-TELEFONE
                    DISPLAY "E-mail: " ARQ-EMAIL

                    MOVE "S" TO WS-FIM-ARQUIVO
                END-IF
        END-READ
    END-PERFORM

    CLOSE ARQUIVO-CLIENTES

    IF WS-CLIENTE-ENCONTRADO = "N"
        DISPLAY "Cliente nao encontrado."
    END-IF.


ALTERAR-CLIENTE.
    DISPLAY SPACE
    DISPLAY "=== ALTERACAO DE CLIENTE ==="
    DISPLAY "Digite o codigo do cliente: "
    ACCEPT WS-CODIGO-ALTERAR

    IF WS-ARQUIVO-ABERTO = "S"
        CLOSE ARQUIVO-CLIENTES
        MOVE "N" TO WS-ARQUIVO-ABERTO
    END-IF

    OPEN INPUT ARQUIVO-CLIENTES

    IF WS-FILE-STATUS NOT = "00"
        DISPLAY "Erro ao abrir arquivo. Status: "
            WS-FILE-STATUS
        EXIT PARAGRAPH
    END-IF

    OPEN OUTPUT ARQUIVO-TEMPORARIO

    IF WS-STATUS-TEMP NOT = "00"
        DISPLAY "Erro ao abrir arquivo temporario. Status: "
            WS-STATUS-TEMP
        CLOSE ARQUIVO-CLIENTES
        EXIT PARAGRAPH
    END-IF

    MOVE "N" TO WS-FIM-ARQUIVO
    MOVE "N" TO WS-CLIENTE-ALTERADO
    MOVE "N" TO WS-ERRO-ALTERACAO

    PERFORM UNTIL WS-FIM-ARQUIVO = "S"

        IF WS-ERRO-ALTERACAO = "S"
            MOVE "S" TO WS-FIM-ARQUIVO
        ELSE
            READ ARQUIVO-CLIENTES
                AT END
                    MOVE "S" TO WS-FIM-ARQUIVO
                NOT AT END
                    IF ARQ-CODIGO = WS-CODIGO-ALTERAR
                        DISPLAY "Cliente encontrado: "
                            ARQ-NOME

                        DISPLAY "Novo nome: "
                        ACCEPT WS-NOME

                        DISPLAY "Novo CPF: "
                        ACCEPT WS-CPF

                        DISPLAY "Novo telefone: "
                        ACCEPT WS-TELEFONE

                        DISPLAY "Novo e-mail: "
                        ACCEPT WS-EMAIL

                        MOVE WS-NOME TO ARQ-NOME
                        MOVE WS-CPF TO ARQ-CPF
                        MOVE WS-TELEFONE TO ARQ-TELEFONE
                        MOVE WS-EMAIL TO ARQ-EMAIL

                        MOVE "S" TO WS-CLIENTE-ALTERADO
                    END-IF

                    MOVE ARQ-CODIGO TO TMP-CODIGO
                    MOVE ARQ-NOME TO TMP-NOME
                    MOVE ARQ-CPF TO TMP-CPF
                    MOVE ARQ-TELEFONE TO TMP-TELEFONE
                    MOVE ARQ-EMAIL TO TMP-EMAIL

                    WRITE REGISTRO-TEMPORARIO

                    IF WS-STATUS-TEMP NOT = "00"
                        MOVE "S" TO WS-ERRO-ALTERACAO
                        DISPLAY
                            "Erro ao gravar arquivo temporario."
                        DISPLAY "Status: " WS-STATUS-TEMP
                    END-IF
            END-READ
        END-IF
    END-PERFORM

    CLOSE ARQUIVO-CLIENTES

    IF WS-FILE-STATUS NOT = "00"
        MOVE "S" TO WS-ERRO-ALTERACAO
        DISPLAY "Erro ao fechar arquivo original: "
            WS-FILE-STATUS
    END-IF

    CLOSE ARQUIVO-TEMPORARIO

    IF WS-STATUS-TEMP NOT = "00"
        MOVE "S" TO WS-ERRO-ALTERACAO
        DISPLAY "Erro ao fechar arquivo temporario: "
            WS-STATUS-TEMP
    END-IF


    IF WS-ERRO-ALTERACAO = "S"
        DISPLAY "Alteracao cancelada por erro de gravacao."
        DISPLAY "O arquivo original foi preservado."
    ELSE
        IF WS-CLIENTE-ALTERADO = "N"
            DISPLAY "Cliente nao encontrado."
        ELSE
            PERFORM CRIAR-BACKUP

            IF WS-BACKUP-OK = "S"
                PERFORM SUBSTITUIR-ARQUIVO

                IF WS-SUBSTITUICAO-OK = "S"
                    DISPLAY "Alteracao concluida com sucesso."
                ELSE
                    DISPLAY "Alteracao nao concluida."
                END-IF
            ELSE
                DISPLAY "Backup nao validado."
                DISPLAY "Arquivo original preservado."
            END-IF

        END-IF
        
    END-IF.

EXCLUIR-CLIENTE.
    DISPLAY SPACE
    DISPLAY "=== EXCLUSAO DE CLIENTE ==="
    DISPLAY "Digite o codigo do cliente: "
    ACCEPT WS-CODIGO-ALTERAR

    IF WS-ARQUIVO-ABERTO = "S"
        CLOSE ARQUIVO-CLIENTES
        MOVE "N" TO WS-ARQUIVO-ABERTO
    END-IF

    OPEN INPUT ARQUIVO-CLIENTES

    IF WS-FILE-STATUS NOT = "00"
        DISPLAY "Erro ao abrir arquivo: " WS-FILE-STATUS
        EXIT PARAGRAPH
    END-IF

    OPEN OUTPUT ARQUIVO-TEMPORARIO

    IF WS-STATUS-TEMP NOT = "00"
        DISPLAY "Erro ao criar arquivo temporario: "
            WS-STATUS-TEMP
        CLOSE ARQUIVO-CLIENTES
        EXIT PARAGRAPH
    END-IF

    MOVE "N" TO WS-FIM-ARQUIVO
    MOVE "N" TO WS-CLIENTE-ALTERADO
    MOVE "N" TO WS-ERRO-ALTERACAO

    PERFORM UNTIL WS-FIM-ARQUIVO = "S"
        READ ARQUIVO-CLIENTES

        EVALUATE WS-FILE-STATUS
            WHEN "00"
                IF ARQ-CODIGO = WS-CODIGO-ALTERAR
                    MOVE "S" TO WS-CLIENTE-ALTERADO
                    DISPLAY "Cliente selecionado: " ARQ-NOME
                ELSE
                    MOVE ARQ-CODIGO TO TMP-CODIGO
                    MOVE ARQ-NOME TO TMP-NOME
                    MOVE ARQ-CPF TO TMP-CPF
                    MOVE ARQ-TELEFONE TO TMP-TELEFONE
                    MOVE ARQ-EMAIL TO TMP-EMAIL

                    WRITE REGISTRO-TEMPORARIO

                    IF WS-STATUS-TEMP NOT = "00"
                        DISPLAY "Erro ao gravar temporario: "
                            WS-STATUS-TEMP
                        MOVE "S" TO WS-ERRO-ALTERACAO
                        MOVE "S" TO WS-FIM-ARQUIVO
                    END-IF
                END-IF

            WHEN "10"
                MOVE "S" TO WS-FIM-ARQUIVO

            WHEN OTHER
                DISPLAY "Erro ao ler arquivo: "
                    WS-FILE-STATUS
                MOVE "S" TO WS-ERRO-ALTERACAO
                MOVE "S" TO WS-FIM-ARQUIVO
        END-EVALUATE
    END-PERFORM

    CLOSE ARQUIVO-CLIENTES

    IF WS-FILE-STATUS NOT = "00"
        MOVE "S" TO WS-ERRO-ALTERACAO
    END-IF

    CLOSE ARQUIVO-TEMPORARIO

    IF WS-STATUS-TEMP NOT = "00"
        MOVE "S" TO WS-ERRO-ALTERACAO
    END-IF

    IF WS-ERRO-ALTERACAO = "S"
        DISPLAY "Exclusao cancelada por erro."
        DISPLAY "Nao execute a substituicao."
    ELSE
        IF WS-CLIENTE-ALTERADO = "N"
            DISPLAY "Cliente nao encontrado."
        ELSE
            PERFORM CRIAR-BACKUP

            IF WS-BACKUP-OK = "S"
                PERFORM SUBSTITUIR-ARQUIVO

                IF WS-SUBSTITUICAO-OK = "S"
                    DISPLAY "Cliente excluido com sucesso."
                ELSE
                    DISPLAY "Exclusao nao concluida."
                END-IF
            ELSE
                DISPLAY "Backup nao validado."
                DISPLAY "Arquivo original preservado."
            END-IF

        END-IF
    END-IF.


*> ==================================================
*> ROTINAS AUXILIARES                                
*> ==================================================
CALCULAR-PROXIMO-CODIGO.

    MOVE "N" TO WS-ERRO-LEITURA-CODIGO
    MOVE "00000" TO WS-MAIOR-CODIGO
    MOVE "N" TO WS-CODIGO-DISPONIVEL
    MOVE "N" TO WS-FIM-ARQUIVO

    IF WS-ARQUIVO-ABERTO = "S"
        CLOSE ARQUIVO-CLIENTES
        MOVE "N" TO WS-ARQUIVO-ABERTO
    END-IF

    OPEN INPUT ARQUIVO-CLIENTES

    IF WS-FILE-STATUS NOT = "00"
        DISPLAY "Erro ao ler cadastro: " WS-FILE-STATUS
        EXIT PARAGRAPH
    END-IF

    PERFORM UNTIL WS-FIM-ARQUIVO = "S"

        READ ARQUIVO-CLIENTES

        EVALUATE WS-FILE-STATUS
            WHEN "00"
                IF ARQ-CODIGO > WS-MAIOR-CODIGO
                    MOVE ARQ-CODIGO TO WS-MAIOR-CODIGO
                END-IF

            WHEN "10"
                MOVE "S" TO WS-FIM-ARQUIVO

            WHEN OTHER
                DISPLAY "Erro durante a leitura: "
                    WS-FILE-STATUS
                MOVE "S" TO WS-ERRO-LEITURA-CODIGO
                MOVE "S" TO WS-FIM-ARQUIVO
                MOVE "N" TO WS-CODIGO-DISPONIVEL
        END-EVALUATE

    END-PERFORM

    CLOSE ARQUIVO-CLIENTES

    IF WS-FILE-STATUS NOT = "00"
        DISPLAY "Erro ao fechar cadastro: " WS-FILE-STATUS
        EXIT PARAGRAPH
    END-IF

    MOVE WS-MAIOR-CODIGO TO WS-PROXIMO-CODIGO

    IF WS-PROXIMO-CODIGO = 99999
        DISPLAY "Limite de codigos atingido."
        EXIT PARAGRAPH
    END-IF

    ADD 1 TO WS-PROXIMO-CODIGO
    MOVE WS-PROXIMO-CODIGO TO WS-CODIGO

    OPEN EXTEND ARQUIVO-CLIENTES

    IF WS-FILE-STATUS = "00"
        MOVE "S" TO WS-ARQUIVO-ABERTO
        MOVE "S" TO WS-CODIGO-DISPONIVEL
    ELSE
        DISPLAY "Erro ao reabrir cadastro: "
            WS-FILE-STATUS
    END-IF.

ABRIR-ARQUIVO-CLIENTES.
    IF WS-ARQUIVO-ABERTO = "S"
        EXIT PARAGRAPH
    END-IF

    OPEN EXTEND ARQUIVO-CLIENTES

    IF WS-FILE-STATUS = "35"
        OPEN OUTPUT ARQUIVO-CLIENTES
    END-IF

    IF WS-FILE-STATUS = "00"
        MOVE "S" TO WS-ARQUIVO-ABERTO
    ELSE
        DISPLAY "Erro ao abrir arquivo. Status: "
            WS-FILE-STATUS
    END-IF.    


CRIAR-BACKUP.
    MOVE "N" TO WS-BACKUP-OK
    MOVE "N" TO WS-ERRO-BACKUP
    MOVE "N" TO WS-LEITURA-OK
    MOVE "N" TO WS-FIM-ARQUIVO
    MOVE ZERO TO WS-QTD-ORIGINAL
    MOVE ZERO TO WS-QTD-BACKUP

    OPEN INPUT ARQUIVO-CLIENTES

    IF WS-FILE-STATUS NOT = "00"
        DISPLAY "Erro ao abrir arquivo original: "
            WS-FILE-STATUS
        MOVE "S" TO WS-ERRO-BACKUP
        EXIT PARAGRAPH
    END-IF

    OPEN OUTPUT ARQUIVO-BACKUP

    IF WS-STATUS-BACKUP NOT = "00"
        DISPLAY "Erro ao criar backup: "
            WS-STATUS-BACKUP
        CLOSE ARQUIVO-CLIENTES
        MOVE "S" TO WS-ERRO-BACKUP
        EXIT PARAGRAPH
    END-IF

    PERFORM UNTIL WS-FIM-ARQUIVO = "S"
        READ ARQUIVO-CLIENTES

        EVALUATE WS-FILE-STATUS
            WHEN "00"
                ADD 1 TO WS-QTD-ORIGINAL

                MOVE ARQ-CODIGO TO BAK-CODIGO
                MOVE ARQ-NOME TO BAK-NOME
                MOVE ARQ-CPF TO BAK-CPF
                MOVE ARQ-TELEFONE TO BAK-TELEFONE
                MOVE ARQ-EMAIL TO BAK-EMAIL

                WRITE REGISTRO-BACKUP

                IF WS-STATUS-BACKUP = "00"
                    ADD 1 TO WS-QTD-BACKUP
                ELSE
                    DISPLAY "Erro ao gravar backup: "
                        WS-STATUS-BACKUP
                    MOVE "S" TO WS-ERRO-BACKUP
                    MOVE "S" TO WS-FIM-ARQUIVO
                END-IF

            WHEN "10"
                MOVE "S" TO WS-FIM-ARQUIVO
                MOVE "S" TO WS-LEITURA-OK

            WHEN OTHER
                DISPLAY "Erro ao ler arquivo original: "
                    WS-FILE-STATUS
                MOVE "S" TO WS-ERRO-BACKUP
                MOVE "S" TO WS-FIM-ARQUIVO
        END-EVALUATE
    END-PERFORM

    CLOSE ARQUIVO-CLIENTES

    IF WS-FILE-STATUS NOT = "00"
        DISPLAY "Erro ao fechar arquivo original: "
            WS-FILE-STATUS
        MOVE "S" TO WS-ERRO-BACKUP
    END-IF

    CLOSE ARQUIVO-BACKUP

    IF WS-STATUS-BACKUP NOT = "00"
        DISPLAY "Erro ao fechar arquivo de backup: "
            WS-STATUS-BACKUP
        MOVE "S" TO WS-ERRO-BACKUP
    END-IF

    IF WS-QTD-ORIGINAL NOT = WS-QTD-BACKUP
        DISPLAY "Quantidade de registros divergente."
        MOVE "S" TO WS-ERRO-BACKUP
    END-IF

    IF WS-ERRO-BACKUP = "N"
        IF WS-LEITURA-OK = "S"
            MOVE "S" TO WS-BACKUP-OK
            DISPLAY "Backup concluido com sucesso."
            DISPLAY "Registros copiados: "
                WS-QTD-BACKUP
        ELSE
            DISPLAY "Backup nao validado."
        END-IF
    ELSE
        DISPLAY "Backup incompleto. Nao sera validado."
    END-IF.


SUBSTITUIR-ARQUIVO.
    MOVE "N" TO WS-SUBSTITUICAO-OK

    DISPLAY "Iniciando substituicao..."

    IF WS-BACKUP-OK NOT = "S"
        DISPLAY "Backup nao validado."
        DISPLAY "Substituicao cancelada."
        EXIT PARAGRAPH
    END-IF

    OPEN INPUT ARQUIVO-RECUPERACAO

    IF WS-STATUS-OLD = "00"
        CLOSE ARQUIVO-RECUPERACAO
        DISPLAY "Ja existe CLIENTES.OLD."
        DISPLAY "Arquivo de recuperacao preservado."
        DISPLAY "Substituicao cancelada."
        EXIT PARAGRAPH
    END-IF

    IF WS-STATUS-OLD NOT = "35"
        DISPLAY "Erro ao verificar CLIENTES.OLD: "
            WS-STATUS-OLD
        EXIT PARAGRAPH
    END-IF

    CALL "CBL_RENAME_FILE"
        USING "dados/CLIENTES.DAT"
              "dados/CLIENTES.OLD"

    IF RETURN-CODE NOT = 0
        DISPLAY "Erro ao preservar arquivo original."
        EXIT PARAGRAPH
    END-IF

    CALL "CBL_RENAME_FILE"
        USING "dados/CLIENTES.TMP"
              "dados/CLIENTES.DAT"

    IF RETURN-CODE = 0
        MOVE "S" TO WS-SUBSTITUICAO-OK
        DISPLAY "Arquivo atualizado com sucesso."
        DISPLAY "Copia anterior mantida em CLIENTES.OLD."
    ELSE
        DISPLAY "Erro ao instalar arquivo atualizado."
        DISPLAY "Tentando restaurar o original..."

        CALL "CBL_RENAME_FILE"
            USING "dados/CLIENTES.OLD"
                  "dados/CLIENTES.DAT"

        IF RETURN-CODE = 0
            DISPLAY "Arquivo original restaurado."
        ELSE
            DISPLAY "ATENCAO: restauracao falhou."
            DISPLAY "Preserve CLIENTES.OLD e CLIENTES.BAK."
        END-IF
    END-IF.


