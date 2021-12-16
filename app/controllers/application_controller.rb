class ApplicationController < ActionController::API
    before_action :createUser
    acts_as_token_authentication_handler_for User
    before_action :require_authentication!
 
    private
    
    def require_authentication!
        throw(:warden, scope: :user) unless current_user.presence
    end

    def createUser
        User.create email: 'teste-api@gmail.com', password: '123456'
    end
end
