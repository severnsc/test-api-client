 require 'net/http'
 class SessionsController < ApplicationController

  def new
  end

  def create
    uri = URI('http://localhost:3001/api/v1/sessions')
    response = Net::HTTP.post_form(uri, { 'email' => params[:user][:email], 'password' => params[:user][:password]})
    user = JSON.parse(response.body)
    session[:user_id] = user['id']
    session[:user_auth_token] = user['auth_token']
    redirect_to user_path(user['id'])
  end

  def destroy
    uri = URI("http://localhost:3001/api/v1/sessions?id=#{session[:user_auth_token]}")
    response = Net::HTTP.delete(uri)
    session.delete(:user_id)
    session.delete(:user_auth_token)
    redirect_to login_path
  end
end