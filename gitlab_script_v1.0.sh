#!/bin/zsh

######################################################################################################
#												     #					
# gitlab_script_v1.0.sh - Script para Automatizar a Criação e Envio de Projetos para o GitLab        #
#												     #
# Autor: Romulo G. Della Libera 		             #
#												     #
# Data: 15/01/2024                                                                                   #  
#                                                                                                    #
######################################################################################################

# Verifica se as variáveis de ambiente GITLAB_TOKEN e GITLAB_USERNAME existem (OPCIONAL, não recomendado)
#if ! grep -q "GITLAB_TOKEN" ~/.zshrc
#then
  #echo "Digite o seu token do GitLab:"
  #read -s GITLAB_TOKEN
  #echo 'export GITLAB_TOKEN='$GITLAB_TOKEN >> ~/.zshrc
  #chmod 600 ~/.zshrc
  #source ~/.zshrc
#fi

#if ! grep -q "GITLAB_USERNAME" ~/.zshrc
#then
  #echo "Digite o seu nome de usuário do GitLab:"
  #read -s GITLAB_USERNAME
  #echo 'export GITLAB_USERNAME='$GITLAB_USERNAME >> ~/.zshrc
  #chmod 600 ~/.zshrc
  #source ~/.zshrc
#fi

# Solicita o nome do novo projeto ao usuário
echo "Digite o nome do projeto:"
read NEW_PROJECT_NAME

# Solicita o caminho do projeto local ao usuário
echo "Digite o caminho do projeto local:"
read LOCAL_PROJECT_PATH

# Solicita a visibilidade do projeto ao usuário
echo "Digite a visibilidade do projeto (public, internal, private):"
read PROJECT_VISIBILITY

# Cria um novo projeto no GitLab
CREATE_PROJECT_RESPONSE=$(curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" -X POST "https://*****************.com.br/******/*********/************=$NEW_PROJECT_NAME&visibility=$PROJECT_VISIBILITY")

# Extrai a URL do projeto do JSON de resposta
PROJECT_URL=$(echo $CREATE_PROJECT_RESPONSE | jq -r '.http_url_to_repo')

# Navega até o diretório do projeto local
cd $LOCAL_PROJECT_PATH

# Inicializa o repositório git local
git init

# Adiciona todos os arquivos ao repositório
git add .

# Faça o commit inicial
git commit -m "Initial Commit"

# Adiciona o repositório remoto do GitLab
git remote add origin $PROJECT_URL

# Faz o push para o repositório do GitLab
git push -u origin master

# Verifica se o útlimo comando (git push) foi bem-sucedido
if [ $? -eq 0 ]
then
  echo "Projeto enviado com sucesso!"
else
  echo "Falha ao enviar o projeto. Por favor, verifique suas configurações e tente novamente."
fi

