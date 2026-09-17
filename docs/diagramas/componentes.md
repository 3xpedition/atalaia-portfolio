# Diagrama de componentes

Diagrama conceitual e sanitizado da solução:

```mermaid
flowchart LR
    U[Usuários autorizados] --> W[Interface web\nBlade + Bootstrap]
    W --> A[Aplicação Laravel]
    A --> D[Serviços de domínio]
    D --> M[(MySQL)]
    D --> R[(Redis)]
    A --> Q[Relatórios e exportações]
    Q --> B[Camada analítica\nMicroStrategy]
    N[Nginx] --> W
```

As conexões são ilustrativas e não representam nomes, endereços, portas ou topologia de produção.
