#!/bin/bash

############################################
# Script para validacao de certificado SSL #
#                                          #
# Autor: Romulo Gomes Della Libera         #
############################################

# Entradas
echo "Informe o nome do host com o dominio:"
read SERVIDOR

echo "Informe o numero da porta:"
read PORTA

# Obter a data de validade do certificado
DATA_VALIDADE=$(echo | openssl s_client -servername $SERVIDOR -connect $SERVIDOR:$PORTA 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f 2)

# Verifica a data de validade
if [ -z "$DATA_VALIDADE" ]; then
    echo "Servidor ou porta indisponiveis. Favor verificar as entradas."
    exit 1
fi

# Converter a data de validade para o formato epoch
DATA_VALIDADE_EPOCH=$(date -u -d "$DATA_VALIDADE" +%s)

# Obter a data atual em formato epoch no fuso horario de Brasilia
DATA_ATUAL=$(TZ=America/Sao_Paulo date +%s)

# Calcular a diferenca em segundos
SEGUNDOS_RESTANTES=$((DATA_VALIDADE_EPOCH - DATA_ATUAL))

# Converter a diferenca em dias, horas, minutos e segundos
DIAS=$((SEGUNDOS_RESTANTES / 60 / 60 / 24))
HORAS=$((SEGUNDOS_RESTANTES / 60 / 60 % 24))
MINUTOS=$((SEGUNDOS_RESTANTES / 60 % 60))
SEGUNDOS=$((SEGUNDOS_RESTANTES % 60))

# Converter a data de validade para o formato dd/mm/aa no fuso horario de Brasilia
DATA_VALIDADE_FORMATADA=$(TZ=America/Sao_Paulo date -d "@$DATA_VALIDADE_EPOCH" +%d/%m/%y)

# Verificar se o certificado esta prestes a expirar
if [ "$SEGUNDOS_RESTANTES" -gt 0 ]; then
    echo "O certificado SSL do servidor $SERVIDOR expira em $DIAS dias, $HORAS horas, $MINUTOS minutos e $SEGUNDOS segundos (data de validade: $DATA_VALIDADE_FORMATADA)."
else
    echo "O certificado SSL do servidor $SERVIDOR ja expirou (data de validade: $DATA_VALIDADE_FORMATADA)."
fi

echo "Pressione qualquer tecla para sair..."
read -n 1
