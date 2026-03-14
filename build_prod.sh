#!/bin/bash

# DocuSeal 운영용 이미지 빌드 스크립트 (박조수 제작)
# 박사님의 최신 코드를 포함하여 '무결점 이미지'를 생성합니다.

IMAGE_NAME="docuseal-custom"
TAG="prod"

echo "=========================================="
echo "   운영용 이미지 빌드를 시작합니다, 박사님!"
echo "=========================================="

# 1. Docker 실행 확인
if ! docker info > /dev/null 2>&1; then
  echo "❌ [오류] Docker가 실행 중이지 않습니다."
  exit 1
fi

# 2. 이미지 빌드 (Dockerfile 기준)
echo "박사님의 최신 소스 코드를 이미지 내부로 복사하여 빌드합니다..."
echo "이 작업은 몇 분 정도 소요될 수 있습니다 (에셋 컴파일 등)..."

docker build -t ${IMAGE_NAME}:${TAG} .

if [ $? -eq 0 ]; then
  echo "=========================================="
  echo "✅ 운영용 이미지 빌드 성공: ${IMAGE_NAME}:${TAG}"
  echo "👉 이제 'run_prod.sh'를 통해 안전하게 배포할 준비가 되었습니다!"
  echo "=========================================="
else
  echo "❌ 빌드 중 오류가 발생했습니다. 로그를 확인해 주세요."
  exit 1
fi
