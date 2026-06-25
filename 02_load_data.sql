-- ========================
-- 02. 데이터 적재
-- ========================

-- A
DROP TABLE IF EXISTS tmp_prices;
CREATE TEMP TABLE tmp_prices (
    trade_date DATE, open NUMERIC(18,8), high NUMERIC(18,8),
    low NUMERIC(18,8), close NUMERIC(18,8), adj_close NUMERIC(18,8), volume NUMERIC(20,2)
);
COPY tmp_prices FROM '/tmp/A.csv' DELIMITER ',' CSV HEADER;
INSERT INTO stock_prices SELECT 'A', * FROM tmp_prices;

-- AAPL
DROP TABLE IF EXISTS tmp_prices;
CREATE TEMP TABLE tmp_prices (
    trade_date DATE, open NUMERIC(18,8), high NUMERIC(18,8),
    low NUMERIC(18,8), close NUMERIC(18,8), adj_close NUMERIC(18,8), volume NUMERIC(20,2)
);
COPY tmp_prices FROM '/tmp/AAPL.csv' DELIMITER ',' CSV HEADER;
INSERT INTO stock_prices SELECT 'AAPL', * FROM tmp_prices;

-- MSFT
DROP TABLE IF EXISTS tmp_prices;
CREATE TEMP TABLE tmp_prices (
    trade_date DATE, open NUMERIC(18,8), high NUMERIC(18,8),
    low NUMERIC(18,8), close NUMERIC(18,8), adj_close NUMERIC(18,8), volume NUMERIC(20,2)
);
COPY tmp_prices FROM '/tmp/MSFT.csv' DELIMITER ',' CSV HEADER;
INSERT INTO stock_prices SELECT 'MSFT', * FROM tmp_prices;

-- AMZN
DROP TABLE IF EXISTS tmp_prices;
CREATE TEMP TABLE tmp_prices (
    trade_date DATE, open NUMERIC(18,8), high NUMERIC(18,8),
    low NUMERIC(18,8), close NUMERIC(18,8), adj_close NUMERIC(18,8), volume NUMERIC(20,2)
);
COPY tmp_prices FROM '/tmp/AMZN.csv' DELIMITER ',' CSV HEADER;
INSERT INTO stock_prices SELECT 'AMZN', * FROM tmp_prices;

-- GOOGL
DROP TABLE IF EXISTS tmp_prices;
CREATE TEMP TABLE tmp_prices (
    trade_date DATE, open NUMERIC(18,8), high NUMERIC(18,8),
    low NUMERIC(18,8), close NUMERIC(18,8), adj_close NUMERIC(18,8), volume NUMERIC(20,2)
);
COPY tmp_prices FROM '/tmp/GOOGL.csv' DELIMITER ',' CSV HEADER;
INSERT INTO stock_prices SELECT 'GOOGL', * FROM tmp_prices;

-- TSLA
DROP TABLE IF EXISTS tmp_prices;
CREATE TEMP TABLE tmp_prices (
    trade_date DATE, open NUMERIC(18,8), high NUMERIC(18,8),
    low NUMERIC(18,8), close NUMERIC(18,8), adj_close NUMERIC(18,8), volume NUMERIC(20,2)
);
COPY tmp_prices FROM '/tmp/TSLA.csv' DELIMITER ',' CSV HEADER;
INSERT INTO stock_prices SELECT 'TSLA', * FROM tmp_prices;

-- NVDA
DROP TABLE IF EXISTS tmp_prices;
CREATE TEMP TABLE tmp_prices (
    trade_date DATE, open NUMERIC(18,8), high NUMERIC(18,8),
    low NUMERIC(18,8), close NUMERIC(18,8), adj_close NUMERIC(18,8), volume NUMERIC(20,2)
);
COPY tmp_prices FROM '/tmp/NVDA.csv' DELIMITER ',' CSV HEADER;
INSERT INTO stock_prices SELECT 'NVDA', * FROM tmp_prices;

-- companies 메타데이터
DROP TABLE IF EXISTS tmp_meta;

CREATE TEMP TABLE tmp_meta (
    nasdaq_traded     CHAR(1),
    symbol            VARCHAR(20),
    security_name     TEXT,
    listing_exchange  VARCHAR(5),
    market_category   VARCHAR(5),
    etf               CHAR(1),
    round_lot_size    NUMERIC(10,1),
    test_issue        CHAR(1),
    financial_status  VARCHAR(5),
    cqs_symbol        VARCHAR(20),
    nasdaq_symbol     VARCHAR(20),
    nextshares        CHAR(1)
);

COPY tmp_meta
FROM '/tmp/symbols_valid_meta.csv'
DELIMITER ',' CSV HEADER;

INSERT INTO companies (symbol, security_name, listing_exchange, market_category, is_etf, round_lot_size)
SELECT symbol, security_name, listing_exchange, market_category, etf, round_lot_size
FROM tmp_meta;