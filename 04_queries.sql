-- ========================
-- 04. 확인 / 분석 쿼리
-- ========================

-- 종목별 적재 행 수 확인
SELECT ticker, COUNT(*), MIN(trade_date), MAX(trade_date)
FROM stock_prices
GROUP BY ticker
ORDER BY ticker;

-- 가격 + 회사명 연결 확인 (JOIN)
SELECT p.ticker, c.security_name, c.listing_exchange, c.is_etf,
       COUNT(*) AS days, MIN(p.trade_date), MAX(p.trade_date)
FROM stock_prices p
JOIN companies c ON p.ticker = c.symbol
GROUP BY p.ticker, c.security_name, c.listing_exchange, c.is_etf
ORDER BY p.ticker;

