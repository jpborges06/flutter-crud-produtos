# Testes – produtos_memoria

Executado no Chrome (`flutter run -d chrome`) em 16/10/2026.

| Caso | Procedimento | Esperado | Observado | Passou? |
|---|---|---|---|---|
| T1 | Abrir o app | Lista vazia, quantidade 0 | Apareceu "Nenhum produto cadastrado." e cadastrados: 0 | Sim |
| T2 | Salvar nome e preço vazios | Erros nos campos, formulário aberto | Conforme esperado | Sim |
| T3 | Nome só com espaços, preço 10 | Nome rejeitado | Conforme esperado | Sim |
| T4 | Nome Mouse, preço abc | Número inválido | Conforme esperado | Sim |
| T5 | Nome Mouse, preço 0 e -2 | Preço deve ser maior que zero | Conforme esperado | Sim |
| T6 | Nome Mouse, preço 12,50, quantidade 3 | Produto na lista, cadastrados: 1 | Conforme esperado | Sim |
| T7 | Cadastrar sem descrição | Detalhes mostra "Sem descrição." | Conforme esperado | Sim |
| T8 | Editar Mouse para Mouse USB | Mesmo registro atualizado, total de itens igual | Conforme esperado | Sim |
| T9 | Editar nome e cancelar | Nome original preservado | Conforme esperado | Sim |
| T10 | Abrir cadastro e cancelar | Nada acrescentado | Conforme esperado | Sim |
| T11 | Excluir e cancelar | Lista e contagem preservadas | Conforme esperado | Sim |
| T12 | Confirmar exclusão do último | Lista vazia, mensagem de exclusão | Conforme esperado | Sim |
| T13 | Cadastrar 3 e editar o segundo | Só o segundo muda | Conforme esperado | Sim |
| T14 | Preço NaN ou Infinity | Número inválido | Não testado | - |
| Ex7 | Cadastrar Mouse e tentar mouse | Rejeita nome repetido | Conforme esperado | Sim |
| Ex8 | Buscar "tec" | Só Teclado aparece; encontrados: 1 | Conforme esperado | Sim |
| Ex8/9 | Com filtro ativo, editar o preço do Teclado | Só o Teclado muda; os outros ficam iguais | Conforme esperado | Sim |

## Ainda não testados

- Exercício 3 (descrição com 120 e 121 caracteres) e exercício 5 (quantidade vazia, abc, -1, 2.5, 0).
- Exercício 6 (total do estoque com vários produtos e após exclusão).
- Exercício 7: renomear Teclado para Mouse e editar Mouse mantendo o nome.
- Exercício 9: ids após exclusão (cadastro seguinte recebe o próximo número).
- Exercícios 1 e 2 (`formulario_nome`).
