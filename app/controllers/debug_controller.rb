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

  # require 'net/http'
  # require 'uri'
  # require 'json'
  include EncodingHelper
  def rec_api
    key = "4b0ca9238f706863"
    form = "json"
    kana = utf8_code("だ") + utf8_code("い") + utf8_code("が") + utf8_code("く")
    if !params[:keyword].blank?
      keyword =  params[:keyword].chars
      kana = keyword.map{|k|utf8_code(k)}.join
    end
    count = 100
    uri = URI.parse("http://webservice.recruit.co.jp/shingaku/school/v1/?key=#{key}&count=#{count}&format=#{form}&order=3&kana=#{kana}")
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)["results"]["school"]

    @kanas = result.map{|r|r["kana"]} if result && 0 < result.count
    render "debug"
  end
  def aaa
    render "debug"
  end


  private
    def env_develop
      redirect_to :top if !Rails.env.development?
    end
end
