.DEFAULT_GOAL := help

SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DIST_DIR := $(ROOT_DIR)/dist

.PHONY: help install build local watch clean dist-path load-dist load-local

help:
	@echo "Vimium C 로컬 빌드용 Makefile"
	@echo ""
	@echo "사용법:"
	@echo "  make install     # npm 의존성 설치 (npm ci 우선, 실패 시 npm install)"
	@echo "  make build       # dist/ 생성 (Chrome 로드 권장)"
	@echo "  make local       # 리포지토리 내에 JS를 '제자리' 빌드"
	@echo "  make watch       # 개발용 watch (자동 재빌드)"
	@echo "  make clean       # dist/ 및 gulp clean"
	@echo ""
	@echo "Chrome에서 로드:"
	@echo "  - dist 빌드 로드: chrome://extensions -> 개발자 모드 -> '압축해제된 확장 프로그램 로드' -> $(DIST_DIR)"
	@echo "  - local 빌드 로드: chrome://extensions -> 개발자 모드 -> '압축해제된 확장 프로그램 로드' -> $(ROOT_DIR)"

install:
	@command -v npm >/dev/null 2>&1 || { echo "ERROR: npm이 필요합니다."; exit 1; }
	@cd "$(ROOT_DIR)" && (npm ci || npm install)

build:
	@cd "$(ROOT_DIR)" && npm run build
	@$(MAKE) dist-path

local:
	@cd "$(ROOT_DIR)" && npm run local

watch:
	@cd "$(ROOT_DIR)" && npm run dev

clean:
	@cd "$(ROOT_DIR)" && (npm run clean || true)
	@rm -rf "$(DIST_DIR)"

dist-path:
	@echo "$(DIST_DIR)"

load-dist: build
	@echo ""
	@echo "Chrome 로드 경로: $(DIST_DIR)"
	@echo "chrome://extensions -> 개발자 모드 -> '압축해제된 확장 프로그램 로드' -> 위 경로 선택"

load-local: local
	@echo ""
	@echo "Chrome 로드 경로: $(ROOT_DIR)"
	@echo "chrome://extensions -> 개발자 모드 -> '압축해제된 확장 프로그램 로드' -> 위 경로 선택"

