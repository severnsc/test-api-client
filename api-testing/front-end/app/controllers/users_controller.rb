require 'net/http'
class UsersController < ApplicationController
  before_action :logged_in?, only: [:show, :index]

  def new
  end

  def show
    host = 'localhost'
    port = '3001'
    path = "/api/v1/users/#{params[:id]}"
    request = Net::HTTP::Get.new(path, initheader = {'Authorize' => "Token token=#{session[:user_auth_token]}"})
    byebug
    user = Net::HTTP.new(host, port).start {|http| http.request(request)}
    @user = JSON.parse(user.body)
  end

  def index
    users = Net::HTTP.get_response("localhost", "/api/v1/users", port = 3001)
    @users = JSON.parse(users.body)
  end

  private

  def logged_in?
    redirect_to root_path if session[:user_id].nil?
  end
end
