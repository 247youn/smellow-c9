class [scope]::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
  def create
  auth = request.env["omniauth.auth"]

  # Try to find authentication first
  authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])

  if authentication
    # Authentication found, sign the user in.
    flash[:notice] = "Signed in successfully."
    sign_in_and_redirect(:user, authentication.user)
  else
    # Authentication not found, thus a new user.
    user = User.new
    user.apply_omniauth(auth)
    if user.save(:validate => false)
      flash[:notice] = "Account created and signed in successfully."
      sign_in_and_redirect(:user, user)
    else
      flash[:error] = "Error while creating a user account. Please try again."
      redirect_to root_url
    end
  end
end
end
