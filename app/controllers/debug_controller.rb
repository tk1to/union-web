class DebugController < ApplicationController
  before_action :env_develop
  def switch
    id = params[:id].to_i
    if id == 0
      redirect_to [:destroy, :user, :session]
      return
    elsif user = User.find_by(id: id)
      sign_out
      sign_in user
      flash[:notice] = "#{user.name}でログイン"
    end
    redirect_to :top
  end

  require 'net/http'
  require 'uri'
  require 'json'
  def rec_api
    key = "4b0ca9238f706863"
    form = "json"
    code = "SC000268"
    uri = URI.parse("http://webservice.recruit.co.jp/shingaku/school/v1/?key=#{key}&code=#{code}&format=#{form}")
    json = Net::HTTP.get(uri)
    @result = JSON.parse(json)

    render "debug"
  end
  private
    def env_develop
      redirect_to :top if !Rails.env.development?
    end
end
