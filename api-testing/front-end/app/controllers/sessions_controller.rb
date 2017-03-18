 require 'net/http'
 class SessionsController < ApplicationController

  def new
  end

  def create
    uri = URI('http://localhost:3001/api/v1/sessions')
    response = Net::HTTP.post_form(uri, { 'email' => params[:user][:email], 'password' => params[:user][:password]})
    if response.code == '201'
      user = JSON.parse(response.body)
      session[:user_id] = user['id']
      session[:user_auth_token] = user['auth_token']
      redirect_to user_path(user['id'])
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    host = 'localhost'
    port = '3001'
    path = "/api/v1/sessions/#{session[:user_auth_token]}"
    req = Net::HTTP::Delete.new(path)
    response = Net::HTTP.new(host, port).start {|http| http.request(req)}
    session.delete(:user_id)
    session.delete(:user_auth_token)
    redirect_to login_path
  end
end