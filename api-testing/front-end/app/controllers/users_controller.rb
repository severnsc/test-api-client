require 'net/http'
class UsersController < ApplicationController
  before_action :logged_in?, only: [:show, :index]

  def new
  end

  def create
    host = 'localhost'
    port = '3001'
    path = "/api/v1/users"
    request = Net::HTTP::Post.new(path)
    request.set_form_data({"user[email]" => params[:user][:email], "user[password]" => params[:user][:password], "user[password_confirmation]" => params[:user][:password_confirmation]})
    user = Net::HTTP.new(host, port).start {|http| http.request(request)}
    @user = JSON.parse(user.body)
    byebug
    UserMailer.account_activation(@user).deliver_now
    flash[:notice] = "Check your email for account activation link"
    redirect_to root_path
  end

  def show
    host = 'localhost'
    port = '3001'
    path = "/api/v1/users/#{params[:id]}"
    request = Net::HTTP::Get.new(path, initheader = {'Authorize' => "#{session[:user_auth_token]}"})
    user = Net::HTTP.new(host, port).start {|http| http.request(request)}
    @user = JSON.parse(user.body)
  end

  def index
    host = 'localhost'
    port = '3001'
    path = '/api/v1/users'
    request = Net::HTTP::Get.new(path, initheader = {"Authorize" => "#{session[:user_auth_token]}"})
    users = Net::HTTP.new(host, port).start {|http| http.request(request)}
    @users = JSON.parse(users.body)
  end

  def edit
    host = 'localhost'
    port = '3001'
    path = "/api/v1/users/#{params[:id]}"
    request = Net::HTTP::Get.new(path, initheader = {'Authorize' => "#{session[:user_auth_token]}"})
    user = Net::HTTP.new(host, port).start {|http| http.request(request)}
    @user = JSON.parse(user.body)
  end

  def update
    host = 'localhost'
    port = '3001'
    path = "/api/v1/users/#{params[:id]}"
    request = Net::HTTP::Patch.new(path)
    request.set_form_data({"user[email]" => params[:user][:email], "user[password]" => params[:user][:password], "user[password_confirmation]" => params[:user][:password_confirmation]})
    request['Authorize'] = session[:user_auth_token]
    response = Net::HTTP.new(host, port).start {|http| http.request(request)}
    user = JSON.parse(response.body)
    redirect_to user_path(user['id'])
  end

  private

  def logged_in?
    redirect_to root_path if session[:user_id].nil?
  end
end
