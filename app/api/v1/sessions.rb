module V1
  class Sessions < Grape::API
    include V1Base
    include AuthenticateRequest

    resource :sessions do

      desc 'Authenticate user and return user object / access token', http_codes: [
        { code: 200, message: 'success'},
        { code: RESPONSE_CODE[:unauthorized], message: I18n.t('errors.session.invalid') }
      ]
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User Password'
      end

      post do
        email = params[:email]
        password = params[:password]

        if email.nil? or password.nil?
          render_error(RESPONSE_CODE[:unauthorized], I18n.t('errors.session.invalid'))
          return
        end

        user = User.where(email: email.downcase).first
        if user.nil? || !user.valid_password?(password)
          render_error(RESPONSE_CODE[:unauthorized], I18n.t('errors.session.invalid'))
          return
        end

        u_token = user.generate_token
        serialization = UserSerializer.new(user, {show_token: true, token: u_token})

        render_success(serialization.as_json)
      end
    end
  end
end
