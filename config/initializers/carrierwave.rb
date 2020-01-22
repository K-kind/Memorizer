CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.credentials.dig(:s3, :access_key_id),
    aws_secret_access_key: Rails.application.credentials.dig(:s3, :secret_access_key),
    region: 'ap-northeast-1'
  }

  config.fog_directory  = 'memorizer-image'
  config.cache_storage = :fog
end