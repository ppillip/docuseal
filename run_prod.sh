#!/bin/bash

# DocuSeal 운영 서버 통합 실행 스크립트 (박조수 제작)
# 빌드된 이미지를 사용하여 무결점 환경을 구동합니다.

COMPOSE_FILE="docker-compose.prod.yml"

echo "=========================================="
echo "   운영 서버 배포를 시작합니다, 박사님!"
echo "=========================================="

# 1. 이미지 존재 확인
if [ -z "$(docker images -q docuseal-custom:prod 2> /dev/null)" ]; then
  echo "⚠️ 운영용 이미지가 없습니다. 먼저 이미지 빌드를 진행합니다."
  ./build_prod.sh
  if [ $? -ne 0 ]; then exit 1; fi
fi

# 2. 호스트 및 포트 설정 확인
export HOST=${HOST:-"localhost"}
export PORT=${PORT:-"9090"}

# 3. 배포 실행
echo "운영 전용 설정을 사용하여 서비스를 구동합니다..."
echo "👉 주소: http://${HOST}:${PORT}"
docker compose -f ${COMPOSE_FILE} up -d

if [ $? -eq 0 ]; then
  echo "=========================================="
  echo "✅ 운영 서버 구동 성공!"
  echo "👉 도메인/주소: http://${HOST}"
  echo "👉 상태 확인: docker compose -f ${COMPOSE_FILE} ps"
  echo "=========================================="
else
  echo "❌ 배포 중 문제가 발생했습니다."
fi
