# Acessibilidade do portfólio

Este portfólio busca atender aos princípios aplicáveis das WCAG 2.2 no nível AA. A acessibilidade é tratada como requisito contínuo de engenharia, não como declaração de certificação formal.

## Verificações implementadas

| Área | Medidas adotadas |
| --- | --- |
| Alternativas textuais | Todas as imagens publicadas possuem atributo `alt`; elementos estritamente decorativos usam `aria-hidden`. |
| Estrutura e títulos | Idioma `pt-BR`, região principal identificada, um único `h1` por página e níveis de título sem saltos. |
| Navegação por teclado | Link para saltar ao conteúdo, foco visível, menu fechado por `Escape` e abas navegáveis por setas, `Home` e `End`. |
| Componentes demonstrativos | Controles que apenas ilustram telas são retirados da ordem de foco; abas expõem papéis, estados e relações ARIA. |
| Contraste | Cores principais de texto são verificadas automaticamente contra a razão mínima de 4,5:1; o foco usa contorno duplo para fundos claros e escuros. |
| Movimento | `prefers-reduced-motion` desativa animações, transições prolongadas e rolagem suave; a rotação automática da jornada não inicia nessa preferência. |
| Texto e zoom | Não há bloqueio de zoom; fontes declaradas não ficam abaixo de `0.75rem`; grades passam de três para duas e uma coluna conforme a largura disponível. |
| Alvos de interação | Botões principais, menu e abas mantêm área mínima de aproximadamente 44 por 44 pixels. |
| Responsividade | Conteúdo principal se reorganiza para telas estreitas, tabelas e código permitem rolagem própria e a página evita largura fixa para textos. |

## Validação automática

O script `tests/validate-portfolio.ps1` verifica continuamente:

- idioma, landmarks e link de salto;
- hierarquia dos títulos;
- alternativas de imagens;
- ausência de restrição de zoom;
- tamanho mínimo declarado das fontes;
- contraste das cores estruturais;
- foco visível e redução de movimento;
- suporte de teclado no menu e nas abas;
- referências locais e estrutura pública segura.

## Limites da auditoria

Validações estáticas não substituem testes manuais com leitores de tela, ampliação do navegador, diferentes sistemas operacionais ou pessoas com deficiência. Mudanças relevantes de conteúdo ou interação devem ser verificadas novamente com teclado, zoom de 200% e, quando disponível, tecnologia assistiva.

Problemas de acessibilidade podem ser informados pelos canais disponibilizados no repositório público.
