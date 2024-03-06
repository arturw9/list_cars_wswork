Com base nos critérios de aceitação, criei um MVP para atender às demandas, com apenas duas views de interação: Login (para salvar o identificador do usuário logado) e Car (para listar as opções de carros da URL fornecida).

A logo da empresa está presente na view de splash e na view de login para proporcionar uma melhor experiência de usuário.

Para evitar confusões e garantir maior compreensão, separei arquivos importantes em pastas. O arquivo dentro da pasta "service" ficou responsável por trazer os dados do servidor a serem exibidos, enquanto o arquivo dentro da pasta "model" é responsável por armazenar e tratar seus atributos para serem exibidos na visualização.

Ao clicar no botão "Eu quero", o carro escolhido e o identificador do usuário são salvos no SQLite, seguido pela apresentação de um popup de confirmação.

A cada 10 segundos, é feita uma requisição POST na URL https://www.wswork.com.br/cars/leads/ (presente na linha 35 da visualização do carro).

Dependências usadas:
- [http] para realizar as requisições;
- [sqflite] para realizar as comunicações com o banco de dados;
- [animated_splash_screen] para a criação da tela de splash.