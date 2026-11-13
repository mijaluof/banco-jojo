# Catálogo JoJo — Banco de Dados + CRUD (MySQL, Node.js e Express)

Projeto das listas de Banco de Dados: banco `jojo_db` com 5 tabelas, dados de exemplo
(LE5) e um site com CRUD completo em cada entidade.

## O que tem aqui

| Pasta / arquivo | O que é |
| --- | --- |
| `sql/banco_jojo_completo.sql` | Script único: cria o banco, as 5 tabelas e insere todos os registros |
| `sql/povoamento_le5.sql` | Só os `INSERT` (para quando o banco já existe) |
| `site/` | Páginas HTML/CSS/JS (home + 5 telas de cadastro) |
| `index.js` | API Express + conexão com o MySQL |
| `scripts/instalar.bat` | Instala tudo no Windows: `.env`, banco e dependências |
| `scripts/rodar.bat` | Sobe o servidor e abre o navegador |
| `docs/LE5_Povoamento_JoJo.docx` | Atividade LE5 preenchida no template |
| `docs/prints/` | Prints do MySQL usados na atividade |

## Rodar o banco (passo a passo)

### Opção 1 — Windows, tudo automático

1. Instale o [Node.js LTS](https://nodejs.org) e o [MySQL 8](https://dev.mysql.com/downloads/installer/).
2. Dê duplo clique em `scripts/instalar.bat`.
   - Ele pede o usuário e a senha do MySQL (padrão: `root`).
   - Cria o `.env`, importa `sql/banco_jojo_completo.sql` e roda `npm install`.
3. Dê duplo clique em `scripts/rodar.bat` e abra http://localhost:3000.

### Opção 2 — manual (Windows, Linux ou Mac)

```bash
# 1. criar o banco e os dados
mysql -u root -p --default-character-set=utf8mb4 < sql/banco_jojo_completo.sql

# 2. configurar a conexão
cp .env.example .env      # no Windows: copy .env.example .env
# edite o .env e coloque a senha do MySQL em MYSQL_PASSWORD

# 3. instalar e rodar
npm install
npm start
```

Abra http://localhost:3000.

> ⚠️ O script `banco_jojo_completo.sql` **recria** as tabelas do `jojo_db`
> (`DROP TABLE` no começo). Se já tiver dados seus, faça backup antes
> (`mysqldump -u root -p jojo_db > backup.sql`) ou use
> `mysql -u root -p jojo_db < sql/povoamento_le5.sql`, que só insere.

## Tabelas

| Tabela | Registros | Papel |
| --- | --- | --- |
| `parte_obra` | 15 | arco/temporada da obra |
| `personagem` | 20 | entidade principal |
| `stand` | 16 | poder do personagem (1:1) |
| `galeria_imagem` | 18 | imagens do personagem (1:N) |
| `encontro_batalha` | 18 | batalhas do personagem (1:N) |

Ordem de inserção respeitando as chaves estrangeiras:
`parte_obra → personagem → stand → galeria_imagem → encontro_batalha`.

## Telas e rotas

| Entidade | Tela |
| --- | --- |
| `parte_obra` | `/cadastro-parte-obra.html` |
| `personagem` | `/cadastro-personagem.html` |
| `stand` | `/cadastro-stand.html` |
| `galeria_imagem` | `/cadastro-galeria-imagem.html` |
| `encontro_batalha` | `/cadastro-encontro-batalha.html` |

| Método | Rota | Ação |
| --- | --- | --- |
| GET | `/api/home` | personagens com parte, stand e imagem |
| GET | `/api/opcoes` | listas para os campos de seleção |
| GET | `/api/:entidade` | listar registros |
| GET | `/api/:entidade/:id` | consultar um registro |
| POST | `/api/:entidade` | cadastrar |
| PUT | `/api/:entidade/:id` | editar |
| DELETE | `/api/:entidade/:id` | excluir |

## Validações do banco e da API

- Campos obrigatórios são checados no navegador e no servidor.
- Chave estrangeira inexistente retorna erro 400.
- Valor único repetido (parte repetida ou personagem que já tem stand) retorna erro 409.
- Excluir um personagem remove em cascata stand, imagens e batalhas (`ON DELETE CASCADE`).

## Revisão de atributos

- `personagem.titulo` renomeado para `personagem.nome`.
- `parte_obra.numero_parte` com `UNIQUE`.
- `stand.id_personagem` com `UNIQUE` (relação 1:1).
- `descricao`, `habilidade`, `desfecho`, `url_imagem` e `desc_imagem` passaram a `NOT NULL`.
- Tabela `obras` removida: virou `personagem` + `galeria_imagem`.

## Autores

Lucas Faleiros Chagas (30665791) e Miguel Ferreira (3056058) — INFO1.
