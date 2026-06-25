-- ========================
-- 03. 제약조건 추가(외래키)
-- ========================

-- stock_prices.ticker가 companies.sybol을 참조하도록 FK 설정
ALTER TABLE stock_prices
ADD CONSTRAINT fk_ticker
FOREIGN KEY(ticker) REFERENCES companies(symbol);