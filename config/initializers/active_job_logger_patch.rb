ActiveSupport.on_load :active_job do
  class ActiveJob::Logging::LogSubscriber
    private

    # tokenなどのログにfilterにかけるパッチ
    def format(arg)
      case arg
      when Hash
        arg.map do |key, value|
          if key.in? %i[user_activation_token user_reset_token]
            [key, '[FILTERED]']
          else
            [key, format(value)]
          end
        end.to_h
      when Array
        arg.map { |value| format(value) }
      when GlobalID::Identification
        arg.try(:to_global_id) || arg
      else
        arg
      end
    end
  end
end
