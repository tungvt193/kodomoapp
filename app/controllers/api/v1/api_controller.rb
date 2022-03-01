module API::V1
  class ApiController < ActionController::API
    before_action :authorized
    skip_before_action :authorized, only: %i[logged_id current_user]

    class Unauthorized < StandardError; end
    class NotFound < StandardError; end
    class BadRequest < StandardError; end

    rescue_from Unauthorized do |errors|
      render json: { errors: errors || 'unauthorized' }, status: :unauthorized
    end

    rescue_from NotFound do |errors|
      render json: { errors: errors || 'not found' }, status: :not_found
    end

    rescue_from ActionController::ParameterMissing do |errors|
      render json: { errors: errors }, status: :bad_request
    end

    rescue_from ArgumentError do |errors|
      render json: { errors: errors }, status: :bad_request
    end

    rescue_from BadRequest do |errors|
      render json: { errors: errors }, status: :bad_request
    end

    private 

    def logged_id
      header_token = request.headers['token']
      decode_token = JWT.decode(header_token, ENV['HMAC_SECRET'], true, { algorithm: 'HS256' }).first
      return nil unless decode_token['expiry'] && decode_token['expiry'].to_datetime >= DateTime.now
  
      decode_token['user_id']
    rescue JWT::DecodeError
      nil
    end
  
    def authorized
      @current_user = User.find_by id: logged_id
      raise Unauthorized, 'unauthorized' unless @current_user
    end
  end
end
