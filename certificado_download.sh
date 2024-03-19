#!/bin/bash

############################################
# Script para baixar certificado SSL       #
#                                          #
# Autor: Romulo Gomes Della Libera         #
############################################

# Entradas
echo "Informe o nome do host com o dominio:"
read SERVIDOR

echo "Informe o numero da porta:"
read PORTA

# Obter o certificado SSL
echo | openssl s_client -servername $SERVIDOR -connect $SERVIDOR:$PORTA 2>/dev/null | openssl x509 > certificado.pem

# Verificar se o arquivo foi criado com sucesso
if [ -f certificado.pem ]; then
    echo "O certificado SSL foi baixado com sucesso."
else
    echo "Houve um erro ao baixar o certificado SSL. Por favor, verifique suas entradas e tente novamente."
fi

echo "Pressione qualquer tecla para sair..."
read -n 1
