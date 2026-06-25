# 📈 주가 변동성 · 이동평균선 분석 (SQL 프로젝트)
## PostgreSQL을 활용해 미국 주식의 가격 데이터를 적재하고,
## 이동평균선·변동성매매 신호(골든크로스/데드크로스)를 SQL로 분석하는 프로잭트입니다.

### 사용 기술
  · Database : PostgreSQL
  · Client : DBeaver + PGAdmin4
  · 시각화 : Tableau Public *(예정)*
  · 데이터 출처 : [Kaggle - Stock Market Dataset](https://www.kaggle.com/datasets/jacksoncrow/stock-market-dataset/data)

### 데이터
  · 미국 주식 일별 시세 데이터(OHLCV)
  · 분석 대상 종목 : A, AAPL, MSFT, AMZN, GOOGL, TSLA, NVDA
  · 종목 메타데이터(회사명, 거래소, ETF여부 등) 포함

### 데이터 모델
두 개의 테이블로 구성된 관계형 구조
테이블 1 - stock_prices : 종목별 일별 시세(가격, 거래량)
테이블 2 - companies : 종목 메타데이터(회사명, 거래소, ETF 여부)
  · stock_prices.ticker -> companies.symbol (외래키, 1:N관계)
<img width="417" height="694" alt="스크린샷 2026-06-25 오후 2 36 00" src="https://github.com/user-attachments/assets/2638245b-080b-4c21-81fd-3ac1734f9ccd" />

### 주요 분석(예정)
· 이동평균선(MA20/MA60/MA120) - 윈도우 함수
· 변동성 분석(일간 수익률, 이동 표준편차)
· 골든크로스 / 데드크로스 탐지
· Tableau 대시보드

### 주요 인사이트 (예정)
분석 완료 후 작성 예정

### 트러블 슈팅
작업 중 마주친 문제와 해결 과정을 기록합니다.
· CSV 적재 시 권한 오류(mac OS) : PostgreSQL 서버가 Download/Desktop 폴더에 접근하지 못해 Permission denied 발생
-> 파일을 /tmp로 복사해 해결
· duplicate key 오류 : Primary Key 제약으로 중복 적재가 차단 -> 의도된 동작임을 확인
· 거래량 형식 불일치 : 일부 종목의 Volume이 67867200.0처럼 소수점 포함 -> 임시 테이블에서 NUMERIC으로 받아 변환 후 적재

