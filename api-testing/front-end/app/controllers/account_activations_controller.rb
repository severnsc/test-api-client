require 'net/http'
class AccountActivationsController < ApplicationController

  def edit
    host = 'localhost'
    port = '3001'
    path = "/api/v1/account_activations/#{params[:id]}/edit/?activation_token=#{params[:activation_token]}"
    request = Net::HTTP::Get.new(path)
    response = Net::HTTP.new(host, port).start {|http| http.request(request)}
    user = JSON.parse(response.body)
    session[:user_id] = user['id']
    session[:user_auth_token] = user['auth_token']
    redirect_to user_path(user['id'])
  end
end
