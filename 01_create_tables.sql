-- ========================
-- 01. 테이블 생성
-- ========================

-- 주가 데이터 테이블
CREATE TABLE stock_prices (
ticker VARCHAR(20),
trade_date DATE,
open NUMERIC(18,8),
high NUMERIC(18,8),
low NUMERIC(18,8),
close NUMERIC(18,8),
adj_close NUMERIC(18,8),
volume BIGINT,
PRIMARY KEY (ticker, trade_date));

-- 종목 메타데이터 테이블
CREATE TABLE companies(
symbol VARCHAR(20) PRIMARY KEY,
security_name TEXT,
listing_exchange VARCHAR(5)
market_category VARCHAR(5)
is_etf CHAR(1)
round_lot_size NUMERIC(10,1)
);
