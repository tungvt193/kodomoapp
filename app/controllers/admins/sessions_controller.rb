module Admins
  class SessionsController < Devise::SessionsController
    layout 'admin'
  end
end
