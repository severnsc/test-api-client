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
    response = Net::HTTP.new(host, port).start {|http| http.request(request)}
    if response.code == '201'
      @user = JSON.parse(response.body)
      UserMailer.account_activation(@user).deliver_now
      flash[:notice] = "Check your email for account activation link"
      redirect_to root_path
    else
      message = "Invalid information"
      errors = JSON.parse(response.body)
      errors["errors"].each {|error| message += " | #{error}"}
      flash.now[:danger] = message
      render 'new'
    end
  end

  def show
    host = 'localhost'
    port = '3001'
    path = "/api/v1/users/#{params[:id]}"
    request = Net::HTTP::Get.new(path, initheader = {'Authorize' => "#{session[:user_auth_token]}"})
    response = Net::HTTP.new(host, port).start {|http| http.request(request)}
    if response.code == '200'
      @user = JSON.parse(response.body)
    else
      not_found
    end
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
    response = Net::HTTP.new(host, port).start {|http| http.request(request)}
    if response.code == '200'
      @user = JSON.parse(response.body)
    else
      not_found
    end
  end

  def update
    host = 'localhost'
    port = '3001'
    path = "/api/v1/users/#{params[:id]}"
    request = Net::HTTP::Patch.new(path)
    request.set_form_data({"user[email]" => params[:user][:email], "user[password]" => params[:user][:password], "user[password_confirmation]" => params[:user][:password_confirmation]})
    request['Authorize'] = session[:user_auth_token]
    response = Net::HTTP.new(host, port).start {|http| http.request(request)}
    if response.code == '200'
      user = JSON.parse(response.body)
      flash[:success] = "Profile updated!"
      redirect_to user_path(user['id'])
    else
      message = "Invalid information"
      errors = JSON.parse(response.body)
      errors.each {|error| message += " | #{error}"}
      flash[:danger] = message
      redirect_to edit_user_path(params[:id])
    end
  end

  def destroy
    host = 'localhost'
    port = '3001'
    path = "/api/v1/users/#{params[:id]}"
    request = Net::HTTP::Delete.new(path)
    request['Authorize'] = session[:user_auth_token]
    response = Net::HTTP.new(host, port).start {|http| http.request(request)}
    session.delete(:user_id)
    session.delete(:user_auth_token)
    redirect_to root_path
  end

  private

  def logged_in?
    redirect_to root_path if session[:user_id].nil?
  end
end
