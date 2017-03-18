module SessionsHelper

  def current_user
    if(user_id = session[:user_id])
      host = 'localhost'
      port = '3001'
      path = "/api/v1/users/#{session[:user_id]}"
      req = Net::HTTP::Get.new(path, initheader = {"Authorize" => "#{session[:user_auth_token]}"})
      response = Net::HTTP.new(host, port).start {|http| http.request(req)}
      current_user ||= JSON.parse(response.body)
    end
  end
end
