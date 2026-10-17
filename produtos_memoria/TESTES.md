# Testes (T1 a T14 + exercícios)

Preencha a coluna "Observado" depois de executar o app.

| Caso | Procedimento | Esperado | Observado | Passou? |
|---|---|---|---|---|
| T1 | Abrir o app | Lista vazia, quantidade 0 | | |
| T2 | Salvar nome e preço vazios | Erros nos campos, formulário aberto | | |
| T3 | Nome só com espaços, preço 10 | Nome rejeitado | | |
| T4 | Nome Mouse, preço abc | Número inválido | | |
| T5 | Nome Mouse, preço 0 ou -2 | Preço deve ser maior que zero | | |
| T6 | Nome Mouse, preço 12,50, quantidade 1 | Produto na lista, quantidade 1 | | |
| T7 | Cadastrar sem descrição | Detalhes mostra "Sem descrição." | | |
| T8 | Editar Mouse para Mouse USB | Mesmo registro atualizado, total de itens igual | | |
| T9 | Editar nome e cancelar | Nome original preservado | | |
| T10 | Abrir cadastro e cancelar | Nada acrescentado | | |
| T11 | Excluir e cancelar | Lista e contagem preservadas | | |
| T12 | Confirmar exclusão do último | Lista vazia, mensagem de exclusão | | |
| T13 | Cadastrar 3 e editar o segundo | Só o segundo muda | | |
| T14 | Preço NaN ou Infinity | Número inválido | | |
| Ex3 | Nome com 2 letras; descrição de 120 e de 121 caracteres | Rejeita nome curto; 120 ok; 121 rejeita | | |
| Ex5 | Quantidade vazia, abc, -1, 2.5, 0 | Só 0 é válido | | |
| Ex6 | A (10 x 3) e B (20 x 2); excluir A | Total R$ 70.00, depois R$ 40.00 | | |
| Ex7 | Cadastrar Mouse e Teclado; tentar mouse; renomear Teclado para Mouse; editar Mouse sem mudar o nome | mouse rejeitado; renomear rejeitado; editar sem mudar salva | | |
| Ex8 | Cadastrar Mouse, Teclado, Monitor; buscar Teclado; editar o preço | Só Teclado muda | | |
| Ex9 | Criar ids 1, 2, 3; excluir 2; cadastrar outro | Novo id é 4; editar id 3 filtrado mantém id 3 | | |
| Ex10 | Total R$ 70; filtrar só B | Total geral continua R$ 70 | | |
