class ApiController < ApplicationController
  include EncodingHelper
  def recruit
    key = "4b0ca9238f706863"
    form = "json"
    if params[:request_type] == "colleges"
      kana = ""
      if !params[:keyword].blank?
        keyword =  params[:keyword].chars
        kana = keyword.map{|k|utf8_code(k)}.join
      end
      count = 100
      uri = URI.parse("http://webservice.recruit.co.jp/shingaku/school/v1/?key=#{key}&count=#{count}&format=#{form}&order=3&kana=#{kana}")
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)["results"]["school"]

      if result && 0 < result.count
        @colleges = result
      else
        @colleges = []
      end
      name = "user[college]"
      render partial: "shared/college_select", locals: {colleges: @colleges, name: name}
    elsif params[:request_type] == "departments"
      debugger
    end
  end
end
