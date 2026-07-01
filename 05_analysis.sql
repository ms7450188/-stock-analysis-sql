-- =========================================
-- 05. 분석 쿼리 (이동평균선 · 변동성 · 크로스)
-- =========================================


-- -----------------------------------------
-- [Day 3] 이동평균선 (MA20 / MA60 / MA120)
-- 각 종목별로 최근 N일 종가의 평균을 계산 (윈도우 함수)
-- -----------------------------------------
SELECT
    ticker,
    trade_date,
    close,
    ROUND(AVG(close) OVER (
        PARTITION BY ticker ORDER BY trade_date
        ROWS BETWEEN 19 PRECEDING AND CURRENT ROW), 2) AS ma20,
    ROUND(AVG(close) OVER (
        PARTITION BY ticker ORDER BY trade_date
        ROWS BETWEEN 59 PRECEDING AND CURRENT ROW), 2) AS ma60,
    ROUND(AVG(close) OVER (
        PARTITION BY ticker ORDER BY trade_date
        ROWS BETWEEN 119 PRECEDING AND CURRENT ROW), 2) AS ma120
FROM stock_prices
WHERE ticker = 'AAPL'
ORDER BY trade_date;


-- -----------------------------------------
-- [Day 4] 변동성 (일간 수익률 + 20일 이동 표준편차)
-- 수익률 = (오늘 종가 - 어제 종가) / 어제 종가
-- 변동성 = 최근 20일 수익률의 표준편차
-- -----------------------------------------
WITH returns AS (
    SELECT
        ticker,
        trade_date,
        close,
        (close - LAG(close) OVER (PARTITION BY ticker ORDER BY trade_date))
        / LAG(close) OVER (PARTITION BY ticker ORDER BY trade_date) AS daily_return
    FROM stock_prices
    WHERE ticker = 'AAPL'
)
SELECT
    ticker,
    trade_date,
    close,
    ROUND(daily_return * 100, 2) AS daily_return_pct,
    ROUND(STDDEV(daily_return) OVER (
        PARTITION BY ticker ORDER BY trade_date
        ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) * 100, 2) AS volatility_20d
FROM returns
ORDER BY trade_date;


-- -----------------------------------------
-- [Day 5] 골든크로스 / 데드크로스 탐지
-- ma20이 ma60을 위로 뚫으면 Golden, 아래로 뚫으면 Dead
-- LAG로 '어제의 이평선'과 '오늘의 이평선'을 비교
-- -----------------------------------------
WITH ma AS (
    SELECT ticker, trade_date, close,
        AVG(close) OVER (PARTITION BY ticker ORDER BY trade_date
            ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) AS ma20,
        AVG(close) OVER (PARTITION BY ticker ORDER BY trade_date
            ROWS BETWEEN 59 PRECEDING AND CURRENT ROW) AS ma60
    FROM stock_prices
    WHERE ticker = 'AAPL'
),
signals AS (
    SELECT ticker, trade_date, close, ma20, ma60,
        CASE
            WHEN ma20 > ma60 AND LAG(ma20) OVER (PARTITION BY ticker ORDER BY trade_date)
                 <= LAG(ma60) OVER (PARTITION BY ticker ORDER BY trade_date)
            THEN 'Golden Cross'
            WHEN ma20 < ma60 AND LAG(ma20) OVER (PARTITION BY ticker ORDER BY trade_date)
                 >= LAG(ma60) OVER (PARTITION BY ticker ORDER BY trade_date)
            THEN 'Dead Cross'
        END AS cross_signal
    FROM ma
)
SELECT trade_date, close, ROUND(ma20, 2) AS ma20, ROUND(ma60, 2) AS ma60, cross_signal
FROM signals
WHERE cross_signal IS NOT NULL
ORDER BY trade_date;


-- -----------------------------------------
-- [Day 6] 통합 뷰 (stock_analysis)
-- 위 분석(이평선·변동성·크로스)을 7종목 전체로 합쳐 하나의 뷰로 저장
-- Tableau 등에서 SELECT * FROM stock_analysis 한 줄로 활용
-- -----------------------------------------
CREATE VIEW stock_analysis AS
WITH base AS (
    SELECT
        ticker,
        trade_date,
        close,
        -- 이동평균선
        AVG(close) OVER (PARTITION BY ticker ORDER BY trade_date
            ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) AS ma20,
        AVG(close) OVER (PARTITION BY ticker ORDER BY trade_date
            ROWS BETWEEN 59 PRECEDING AND CURRENT ROW) AS ma60,
        AVG(close) OVER (PARTITION BY ticker ORDER BY trade_date
            ROWS BETWEEN 119 PRECEDING AND CURRENT ROW) AS ma120,
        -- 일간 수익률
        (close - LAG(close) OVER (PARTITION BY ticker ORDER BY trade_date))
        / LAG(close) OVER (PARTITION BY ticker ORDER BY trade_date) AS daily_return
    FROM stock_prices
),
calc AS (
    SELECT
        *,
        -- 변동성 (20일 수익률 표준편차)
        STDDEV(daily_return) OVER (PARTITION BY ticker ORDER BY trade_date
            ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) AS volatility_20d
    FROM base
)
SELECT
    ticker,
    trade_date,
    close,
    ROUND(ma20, 2) AS ma20,
    ROUND(ma60, 2) AS ma60,
    ROUND(ma120, 2) AS ma120,
    ROUND(daily_return * 100, 2) AS daily_return_pct,
    ROUND(volatility_20d * 100, 2) AS volatility_20d_pct,
    CASE
        WHEN ma20 > ma60 AND LAG(ma20) OVER (PARTITION BY ticker ORDER BY trade_date)
             <= LAG(ma60) OVER (PARTITION BY ticker ORDER BY trade_date)
        THEN 'Golden Cross'
        WHEN ma20 < ma60 AND LAG(ma20) OVER (PARTITION BY ticker ORDER BY trade_date)
             >= LAG(ma60) OVER (PARTITION BY ticker ORDER BY trade_date)
        THEN 'Dead Cross'
    END AS cross_signal
FROM calc
ORDER BY ticker, trade_date;


-- -----------------------------------------
-- 뷰 활용 예시
-- -----------------------------------------
-- 특정 종목 전체 분석 결과
SELECT * FROM stock_analysis WHERE ticker = 'AAPL' ORDER BY trade_date;

-- 크로스 신호 발생일만 (7종목 전체)
SELECT ticker, trade_date, close, ma20, ma60, cross_signal
FROM stock_analysis
WHERE cross_signal IS NOT NULL
ORDER BY ticker, trade_date;