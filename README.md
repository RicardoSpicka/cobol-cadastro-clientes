# 🧾 COBOL — Cadastro de Clientes

<p align="center">
  <strong>Uma aplicação de terminal para gerenciamento de clientes, desenvolvida em COBOL com GnuCOBOL.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/COBOL-Programming-orange?style=for-the-badge" alt="COBOL">
  <img src="https://img.shields.io/badge/GnuCOBOL-3.2-blue?style=for-the-badge" alt="GnuCOBOL 3.2">
  <img src="https://img.shields.io/badge/Platform-Windows-informational?style=for-the-badge" alt="Windows">
  <img src="https://img.shields.io/badge/Status-In%20Development-yellow?style=for-the-badge" alt="Em desenvolvimento">
</p>

---

## 📌 Sobre o projeto

O **Cadastro de Clientes em COBOL** é um projeto de estudo e portfólio que tem como objetivo explorar a linguagem COBOL, conceitos tradicionais de processamento de dados e operações de manutenção de registros.

A aplicação será desenvolvida incrementalmente, começando por um menu interativo e evoluindo para operações completas de cadastro, consulta, alteração, exclusão e armazenamento de dados.

O projeto utiliza **GnuCOBOL**, permitindo compilar e executar o programa localmente no Windows, sem depender de um mainframe.

## 🎯 Objetivos

- 📚 Praticar os fundamentos da linguagem COBOL.
- 🗂️ Trabalhar com registros e arquivos.
- 🔎 Implementar operações de consulta e manutenção de dados.
- 🛡️ Desenvolver validações e tratamento de erros.
- 🧑‍💻 Manter um projeto organizado e versionado com Git.

## ✨ Funcionalidades

| Funcionalidade | Status |
|---|---|
| Menu principal interativo | ✅ Implementado |
| Cadastro de clientes | 🚧 Planejado |
| Listagem de clientes | 🚧 Planejado |
| Consulta por código | 🚧 Planejado |
| Alteração de cadastro | 🚧 Planejado |
| Exclusão de cadastro | 🚧 Planejado |
| Persistência em arquivo | 🚧 Planejado |
| Validação de entradas | 🚧 Planejado |

> **Nota:** o menu inicial está implementado. As demais funcionalidades serão adicionadas nas próximas etapas.

## 🛠️ Tecnologias utilizadas

- **COBOL** — linguagem de programação.
- **GnuCOBOL 3.2** — compilação e execução.
- **Git** — controle de versão.
- **GitHub** — hospedagem e documentação do projeto.
- **Visual Studio Code** — editor de código.

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
| `dados/` | Arquivos de dados locais da aplicação |
| `docs/` | Documentação técnica |
| `.gitignore` | Arquivos ignorados pelo Git |
| `README.md` | Documentação principal |

## ⚙️ Como executar

### Pré-requisitos

- Windows.
- GnuCOBOL instalado.
- Terminal MSYS2 UCRT64, caso esteja usando a instalação descrita neste projeto.

### 1. Clonar o repositório

```bash
git clone https://github.com/RicardoSpicka/cobol-cadastro-clientes.git
cd cobol-cadastro-clientes
```

### 2. Compilar o programa

No ambiente MSYS2 UCRT64, execute:

```bash
cobc -conf=/ucrt64/share/gnucobol/config/default.conf -x -free -o CADCLI.exe src/CADCLI.cob
```

### 3. Executar

```bash
./CADCLI.exe
```

O menu principal será exibido no terminal. Se sua instalação do GnuCOBOL já estiver com o caminho de configuração corrigido, o parâmetro `-conf` poderá não ser necessário.

## 🗺️ Próximas etapas

- [x] Preparar o ambiente de desenvolvimento.
- [x] Criar a estrutura inicial do projeto.
- [x] Implementar o menu principal.
- [ ] Definir a estrutura de dados do cliente.
- [ ] Implementar cadastro e listagem.
- [ ] Implementar consulta, alteração e exclusão.
- [ ] Persistir registros em arquivo.
- [ ] Adicionar validações e tratamento de erros.
- [ ] Ampliar os testes e a documentação.

## 📚 Aprendizados

Este projeto também serve como laboratório para estudar divisões de um programa COBOL, variáveis, estruturas de decisão, repetição, manipulação de arquivos e organização do código.

## 📄 Licença

Este projeto será distribuído sob a licença MIT. Consulte o arquivo [`LICENSE`](LICENSE) quando ele for adicionado ao repositório.

---

<p align="center">
  Desenvolvido como projeto de estudo e portfólio profissional.
</p>
