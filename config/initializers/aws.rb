ActionMailer::Base.add_delivery_method :ses,
                                       AWS::SES::Base,
                                       access_key_id: Rails.application.credentials.ses[:access_key_id],
                                       secret_access_key: Rails.application.credentials.ses[:secret_access_key],
                                       server: 'email.us-west-2.amazonaws.com'
