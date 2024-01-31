######################################################################################################
#                                                                                                    #
# gitlab_script.ps1 - Script para Automatizar o Envio de Projetos para o GitLab                      #
#                                                                                                    #
# Autor: Romulo Della Libera                                 										 #
#                                                                                                    #
# Data: 15/01/2024                                                                                   #
#                                                                                                    #
######################################################################################################

# Solicita o token do GitLab ao usuário
$GITLAB_TOKEN = Read-Host -Prompt "Digite o seu token do GitLab" -AsSecureString 

# Converte a SecureString para String - (descriptografa a variável)
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($GITLAB_TOKEN)
$UnsecureGitLabToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Solicita o nome de usuário do GitLab ao usuário
$GITLAB_USERNAME = Read-Host -Prompt "Digite o seu nome de usuário do GitLab" -AsSecureString

# Converte SecureString para String
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($GITLAB_USERNAME)
$UnsecureGitLabUsername = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Solicita o nome do novo projeto ao usuário
$NEW_PROJECT_NAME = Read-Host -Prompt "Digite o nome do novo projeto"

# Solicita o caminho do projeto local ao usuário
$LOCAL_PROJECT_PATH = Read-Host -Prompt "Digite o caminho do projeto local"

# Solicita as credenciais do usuário
$credential = Get-Credential

# Define a URL do proxy (OPCIONAL)
#$proxyUrl = "http://"

# Cria um objeto de proxy com a URL (OPCIONAL)
#$proxy = New-Object System.Net.WebProxy($proxyUrl, $true)

# Configura as credenciais para o proxy (OPCIONAL)
#$proxy.Credentials = $credential

# Configura o proxy para o PowerShell (OPCIONAL)
#[System.Net.WebRequest]::DefaultWebProxy = $proxy

# Cria um novo projeto no GitLab
$CREATE_PROJECT_RESPONSE = Invoke-RestMethod -Uri "https://**************.com.br/****/*****/**********=$NEW_PROJECT_NAME" -Method Post -Headers @{"PRIVATE-TOKEN" = $UnsecureGitLabToken}

# Extrai a URL do projeto do JSON de resposta
$PROJECT_URL = $CREATE_PROJECT_RESPONSE.http_url_to_repo

# Navega até o diretório do projeto local
Set-Location -Path $LOCAL_PROJECT_PATH

# Inicializa o repositório git local
git init

# Adiciona todos os arquivos ao repositório
git add .

# Faz o commit inicial
git commit -m "Initial commit"

# Adiciona o repositório remoto do GitLab
git remote add origin $PROJECT_URL

# Desativa a verificação SSL (opcional)
#git config http.sslVerify false

# Faz o push para o repositório do GitLab
git push -u origin master 2>&1

# Imprime sucesso na tela
echo "Projeto enviado com sucesso para o GitLab"

