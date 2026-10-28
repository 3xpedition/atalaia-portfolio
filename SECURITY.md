# Segurança do portfólio

Este repositório publica somente um estudo de caso técnico independente, com interfaces demonstrativas e dados fictícios. Vulnerabilidades ou exposições acidentais devem ser comunicadas de forma privada pelos recursos de **Security advisories** do GitHub, sem abrir uma issue pública com dados sensíveis.

## Controles de publicação

- alterações na `main` devem passar por Pull Request e pela validação automática;
- force push e exclusão da `main` devem permanecer bloqueados no ruleset do GitHub;
- o validador bloqueia possíveis segredos, endereços privados, documentos, dumps, certificados, arquivos de ambiente, binários não autorizados e arquivos excessivamente grandes;
- mídias públicas precisam estar no manifesto de procedência;
- versões, rotas, topologia e configurações operacionais não são publicadas.

O repositório não possui dependências gerenciadas por npm, Composer ou outro ecossistema. Por isso, não há configuração de Dependabot neste momento. Ela deverá ser adicionada somente quando existir um manifesto real de dependências.

## Validação local

```powershell
pwsh -NoProfile -File tests/validate-portfolio.ps1
```
