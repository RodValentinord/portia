#!/bin/bash

# === CONFIGURAÇÕES ESPERADAS ===

EXPECTED_ACCOUNT="rodolfo861998@gmail.com"
EXPECTED_PROJECT="gen-lang-client-0646104371"

REGION="us-central1"
REPO_NAME="nest-api-repo"
SERVICE_NAME="nest-api"
IMAGE_NAME="nest-api"

# === VERIFICAÇÃO DE CONTA E PROJETO ===

CURRENT_ACCOUNT=$(gcloud config get-value account 2>/dev/null)
CURRENT_PROJECT=$(gcloud config get-value project 2>/dev/null)

if [[ "$CURRENT_ACCOUNT" != "$EXPECTED_ACCOUNT" ]]; then
  echo "⛔ Conta incorreta: $CURRENT_ACCOUNT"
  echo "✅ Este script só pode ser executado com: $EXPECTED_ACCOUNT"
  echo "💡 Use: gcloud config set account $EXPECTED_ACCOUNT"
  exit 1
fi

if [[ "$CURRENT_PROJECT" != "$EXPECTED_PROJECT" ]]; then
  echo "⛔ Projeto incorreto: $CURRENT_PROJECT"
  echo "✅ Este script só pode ser executado com o projeto: $EXPECTED_PROJECT"
  echo "💡 Use: gcloud config set project $EXPECTED_PROJECT"
  exit 1
fi

echo "✅ Conta verificada: $CURRENT_ACCOUNT"
echo "✅ Projeto verificado: $CURRENT_PROJECT"

# === GERAÇÃO DE TAG COM TIMESTAMP ===

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
TAG=$TIMESTAMP
IMAGE_URL="$REGION-docker.pkg.dev/$EXPECTED_PROJECT/$REPO_NAME/$IMAGE_NAME:$TAG"

echo "📦 Tag da imagem: $TAG"
echo "📁 URL da imagem: $IMAGE_URL"

# === BUILD ===

echo "🔨 Buildando imagem Docker..."
docker build -t "$IMAGE_URL" .

# === AUTENTICAÇÃO ===

echo "🔐 Autenticando com o Artifact Registry..."
gcloud auth configure-docker "$REGION-docker.pkg.dev"

# === PUSH ===

echo "🚀 Enviando imagem para o Artifact Registry..."
docker push "$IMAGE_URL"

# === DEPLOY ===

echo "🌐 Realizando deploy no Cloud Run..."
gcloud run deploy "$SERVICE_NAME" \
  --image "$IMAGE_URL" \
  --platform managed \
  --region "$REGION" \
  --allow-unauthenticated \
  --project "$EXPECTED_PROJECT"

echo "✅ Deploy finalizado com sucesso! 🚀"
