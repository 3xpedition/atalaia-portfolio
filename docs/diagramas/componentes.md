# Diagrama de componentes

Diagrama conceitual e sanitizado da solução:

```mermaid
flowchart LR
    U[Usuários autorizados] --> W[Interface web\nBlade + Bootstrap]
    C[Operação em campo] --> P[App Android\nKotlin + Compose]
    W --> A[Aplicação Laravel]
    P --> O[(Dados locais\nSQLCipher)]
    P --> S[Sincronização\nWorkManager]
    S --> A
    A --> D[Serviços de domínio]
    D --> M[(MySQL\nadministrativo)]
    D --> R[(MySQL\nSSAA)]
    A --> Q[Relatórios e exportações]
    Q --> B[Painel Oficial\nD3.js]
    N[Nginx] --> W
```

As conexões são ilustrativas e não representam nomes, endereços, portas ou topologia de produção.
