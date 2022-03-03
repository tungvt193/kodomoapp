require 'api_exception'

module AuthenticateRequest
  extend ActiveSupport::Concern

  included do
    helpers do
      # Devise methods overwrites
      def current_user        
        header_token = request.headers['AccessToken']
        return nil if header_token.blank?
        decode_token = JWT.decode(header_token, ENV['HMAC_SECRET'], true, { algorithm: 'HS256' }).first
        return nil unless decode_token['expiry'] && decode_token['expiry'].to_datetime >= DateTime.now
        @current_user ||= User.by_auth_token(decode_token['user_id'])        
      rescue JWT::DecodeError
        nil
      end

      ##
      # Authenticate request with token of user
      ##
      def authenticate!
        raise error!({meta: {code: RESPONSE_CODE[:unauthorized], message: I18n.t("errors.not_authenticated"), debug_info: ''}}, RESPONSE_CODE[:unauthorized]) unless current_user
      end

      ##
      # 
      ##
      def authenticate_request!
        if request.headers['AccessToken'].blank?
          raise error!({meta: {code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.bad_request"), debug_info: ''}}, RESPONSE_CODE[:forbidden])
        else
          
        end
      end
    end
  end


  private

end
