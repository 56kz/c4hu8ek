class Api::V1::PinsController < ApplicationController
  before_action :basic_auth

  def index
    render json: { data: Pin.all.order('created_at DESC') }
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end

    def basic_auth
      user = User.find_by(email: request.headers['HTTP_X_USER_EMAIL'])
       acces = user ? request.headers['X-API-TOKEN'] == user.api_token : false

       unless acces
         render json: { errors: "Acceso denegado" }, status: 401
       end
    end

end
