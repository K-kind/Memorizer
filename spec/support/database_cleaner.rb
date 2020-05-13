RSpec.configure do |config|
  # RSpecの実行前に一度、実行
  config.before(:suite) do
    # DBを綺麗にする手段を指定、トランザクションを張ってrollbackするように指定
    DatabaseCleaner.strategy = :transaction
    # truncate table文を実行し、レコードを消す
    DatabaseCleaner.clean_with(:truncation)
  end

  # exampleが始まるごとに実行
  config.before(:each) do
    # strategyがtransactionなので、トランザクションを張る
    DatabaseCleaner.start
  end

  # exampleが終わるごとに実行
  config.after(:each) do
    # strategyがtransactionなので、rollbackする
    DatabaseCleaner.clean
  end
end
