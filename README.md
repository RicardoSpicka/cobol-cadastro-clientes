# COBOL — Cadastro de Clientes

**Aplicação de terminal para gerenciamento de clientes, desenvolvida em COBOL com GnuCOBOL.**

![COBOL](https://img.shields.io/badge/COBOL-Programming-orange?style=for-the-badge)
![GnuCOBOL](https://img.shields.io/badge/GnuCOBOL-3.2-blue?style=for-the-badge)
![Windows](https://img.shields.io/badge/Platform-Windows-informational?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Em%20desenvolvimento-yellow?style=for-the-badge)

---

## 📌 Sobre o projeto

O **Cadastro de Clientes em COBOL** é um projeto de estudo e portfólio criado para praticar a linguagem COBOL, a manipulação de arquivos sequenciais e as operações tradicionais de manutenção de registros.

A aplicação funciona no terminal e utiliza arquivos locais para armazenar os dados, permitindo explorar conceitos de processamento de dados sem depender de um ambiente mainframe.

O desenvolvimento é incremental, com foco na organização do código, validação das operações e tratamento de erros.

## 🎯 Objetivos

- Praticar os fundamentos da linguagem COBOL.
- Trabalhar com registros e arquivos sequenciais.
- Implementar operações de cadastro e manutenção de dados.
- Desenvolver validações e tratamento de erros.
- Organizar o código-fonte e utilizar Git para controle de versão.

## ✨ Funcionalidades

| Funcionalidade | Status |
|---|---|
| Menu principal interativo | ✅ Implementado |
| Cadastro de clientes | ✅ Implementado |
| Listagem de clientes | ✅ Implementado |
| Consulta por código | ✅ Implementado |
| Alteração de cadastro | ✅ Implementado |
| Exclusão de cadastro | ✅ Implementado |
| Persistência em arquivo | ✅ Implementado |
| Geração automática de códigos | ✅ Implementado |
| Arquivos temporários para manutenção | ✅ Implementado |
| Backup e recuperação de arquivos | 🚧 Em desenvolvimento/validação |
| Validação e tratamento de erros | 🚧 Em evolução |

## 🛠️ Tecnologias utilizadas

- **COBOL** — linguagem de programação.
- **GnuCOBOL 3.2** — compilação e execução.
- **MSYS2 UCRT64** — ambiente de desenvolvimento no Windows.
- **Git** — controle de versão.
- **GitHub** — hospedagem do código-fonte.
- **Visual Studio Code** — edição do código.

## 📁 Estrutura do projeto

```text
cobol-cadastro-clientes/
├── src/
│   └── CADCLI.cob
├── dados/
│   └── .gitkeep
├── docs/
├── .gitignore
└── README.md
```

| Diretório/arquivo | Descrição |
|---|---|
| `src/` | Código-fonte COBOL |
| `dados/` | Arquivos locais utilizados para armazenar os registros e apoiar as operações de manutenção |
| `docs/` | Espaço para documentação técnica |
| `.gitignore` | Define arquivos que não devem ser versionados |
| `README.md` | Documentação principal do projeto |

Os arquivos de dados gerados durante a execução são locais e não devem ser publicados no repositório.

## ⚙️ Como executar

### Pré-requisitos

- Windows.
- GnuCOBOL instalado.
- MSYS2 com o ambiente UCRT64 configurado.

### 1. Clonar o repositório

```bash
git clone https://github.com/RicardoSpicka/cobol-cadastro-clientes.git
cd cobol-cadastro-clientes
```

### 2. Compilar o programa

Abra o terminal **MSYS2 UCRT64** na pasta do projeto e execute:

```bash
cobc -conf=/ucrt64/share/gnucobol/config/default.conf -x -free -o CADCLI.exe src/CADCLI.cob
```

O comando gera o executável `CADCLI.exe`.

Se a configuração do GnuCOBOL já estiver ajustada no ambiente, talvez seja possível compilar sem o parâmetro `-conf`.

### 3. Executar

```bash
./CADCLI.exe
```

O menu principal será exibido no terminal.

**Observação:** execute o programa a partir da pasta raiz do projeto, pois os caminhos dos arquivos de dados são relativos a essa localização.

## 🗺️ Próximas etapas

- Revisar e ampliar o tratamento de erros.
- Testar cenários de falha na leitura e gravação de arquivos.
- Validar as operações de backup e recuperação.
- Ampliar os testes das operações de cadastro e manutenção.
- Melhorar a documentação técnica em `docs/`.

## 📚 Aprendizados

O projeto permite praticar as divisões de um programa COBOL, a definição de variáveis e registros, estruturas de decisão e repetição, leitura e gravação de arquivos, além da organização de rotinas e do controle de fluxo.

Também serve como exercício de versionamento com Git e documentação de um projeto de software.

## 📄 Licença

A licença do projeto será definida em um arquivo `LICENSE` na raiz do repositório.

---

Projeto desenvolvido para estudo e prática de COBOL.