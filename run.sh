#!/bin/bash

# DocuSeal 맞춤형 구동 스크립트 (박조수 제작)
# 현재 박사님께서 사용 중인 9090 포트 및 실시간 코드 반영 설정을 그대로 유지합니다.

CONTAINER_NAME="docuseal"
PORT=9090
IMAGE="docuseal/docuseal"

echo "=========================================="
echo "   DocuSeal 맞춤형 구동을 시작합니다, 박사님!"
echo "=========================================="

# 1. Docker 실행 여부 확인
if ! docker info > /dev/null 2>&1; then
  echo "❌ [오류] Docker Desktop이 실행 중이지 않습니다."
  exit 1
fi

# 2. 필수 데이터 폴더 확인 및 생성 (git pull 이후 대비)
if [ ! -d "docuseal-data" ]; then
    echo "데이터 폴더(docuseal-data)가 없어 새로 생성합니다..."
    mkdir -p docuseal-data
fi

# 3. 기존 컨테이너 처리
if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "기존에 존재하던 '${CONTAINER_NAME}' 컨테이너를 정리합니다..."
    docker stop ${CONTAINER_NAME} > /dev/null 2>&1
    docker rm ${CONTAINER_NAME} > /dev/null 2>&1
fi

echo "설정된 포트(${PORT})와 마운트 경로로 새 컨테이너를 실행합니다..."

# 3. 박사님의 현재 설정을 그대로 반영한 구동 명령어
docker run -d --name ${CONTAINER_NAME} -p ${PORT}:3000 \
  -v "$(pwd)/docuseal-data:/data" \
  -v "$(pwd)/app/views/shared/_navbar_buttons.html.erb:/app/app/views/shared/_navbar_buttons.html.erb" \
  -v "$(pwd)/app/views/shared/_settings_nav.html.erb:/app/app/views/shared/_settings_nav.html.erb" \
  -v "$(pwd)/app/views/shared/_title.html.erb:/app/app/views/shared/_title.html.erb" \
  -v "$(pwd)/config/locales:/app/config/locales" \
  -v "$(pwd)/app/controllers:/app/app/controllers" \
  -v "$(pwd)/app/views/shared/_navbar.html.erb:/app/app/views/shared/_navbar.html.erb" \
  ${IMAGE}

if [ $? -eq 0 ]; then
  echo "=========================================="
  echo "✅ 성공적으로 구동되었습니다, 박사님!"
  echo "👉 접속 주소: http://localhost:${PORT}"
  echo "=========================================="
else
  echo "❌ 구동 중 문제가 발생했습니다. 로그를 확인해 주세요."
fi
