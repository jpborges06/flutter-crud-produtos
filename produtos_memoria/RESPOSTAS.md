# Respostas – Capítulo Flutter: Formulários validados e CRUD em memória

**Aluno:** João Pedro Borges Sartori
**Turma:** Ciência da Computação - 6º semestre

## Checkpoint 1

**a)** Um nome com três espaços parece preenchido, mas não identifica ninguém. O `trim()` remove os espaços das pontas e deixa o texto vazio, então a validação consegue rejeitar.

**b)** O `validator` retorna `null` quando o campo está correto. Quando retorna uma String, ela é a mensagem de erro.

**c)** O `controller` lê ou preenche o texto de um campo. A chave (`GlobalKey<FormState>`) dá acesso ao estado do formulário, para chamar operações como `validate()`.

## Checkpoint 2

| Entrada | Retorno do validador |
|---|---|
| vazio | "Informe o preço." |
| abc | "Digite um número válido." |
| 0 | "O preço deve ser maior que zero." |
| -5 | "O preço deve ser maior que zero." |
| 12,50 | `null` (valor válido) |
| NaN | "Digite um número válido." (`isFinite` rejeita NaN) |

O teclado numérico só facilita a digitação, não é uma regra de validação. O usuário pode colar texto ou usar outro tipo de entrada, por isso o valor sempre precisa ser verificado no código.

## Checkpoint 3

Ao **salvar** uma edição, o formulário cria e devolve um novo `Produto`. A tela de detalhes repassa esse resultado para a tela principal, que substitui o item na lista e mantém a mesma quantidade de produtos. Ao **cancelar**, o formulário devolve `null` e o produto original continua como estava.

Usamos a substituição na posição (`produtos[indice] = atualizado`) e não `produtos.add(atualizado)`, porque o `add` criaria um segundo registro e manteria o antigo. O formulário não altera o objeto original durante a digitação porque edita apenas o texto dos controllers e só cria um objeto ao salvar. Assim, dá para desistir sem mudar o registro.

## Checkpoint 4

`false` significa que o usuário clicou em Cancelar. `null` significa que não houve resposta explícita, por exemplo se o diálogo foi fechado sem escolher. Os dois são diferentes de `true`, então não autorizam a exclusão, que só acontece quando o retorno é exatamente `true`. A lista muda na tela principal, porque é ela que guarda a lista. O SnackBar do cadastro aparece depois do retorno à tela principal porque só ali o resultado foi aceito e a operação foi aplicada.

## Explicação curta: validar, devolver o objeto e atualizar a lista

O formulário usa `Form` e `TextFormField` com `validator`. Ao clicar em Salvar, `validate()` executa as regras de todos os campos. Se algum falha, a tela mostra o erro e nada é salvo. Se todos passam, o formulário monta um `Produto` e o devolve com `Navigator.pop`. A tela principal recebe o resultado com `await`, confere se não é `null` e atualiza a lista dentro de `setState()`: `add` no cadastro, substituição na posição na edição. Como a busca muda a lista visível, o app localiza o produto pelo `id` com `indexWhere`, nunca pela posição na lista filtrada.

## Dúvidas

Sem dúvidas pendentes até o momento.

## Fonte de ajuda externa

O código e os rascunhos destes textos foram feitos com ajuda do Claude (Anthropic). Eu executei o app, fiz os testes registrados no `TESTES.md` e revisei o material.
