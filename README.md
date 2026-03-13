# Questionario

1. Em qual camada foi implementado o mecanismo de cache? Explique por que essa decisão é adequada dentro da arquitetura proposta.

Repository, dentro do Data layer. Abstrai a origem dos dados das camadas superiores.

2. Por que o ViewModel não deve realizar chamadas HTTP diretamente?

lógica de apresentação e lógica de aquisição de dados devem ser separados. O ViewModel apenas prepara os dados para a interface do usuário.

3. O que poderia acontecer se a interface acessasse diretamente o DataSource?

A inteface fica acoplada a uma fonte de dados específica.

4. Como essa arquitetura facilitaria a substituição da API por um banco de dados local?

Nada da interface e viewmodel precisaria ser alterado, apenas datasource e repository.