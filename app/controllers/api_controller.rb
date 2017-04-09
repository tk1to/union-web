class ApiController < ApplicationController
  include EncodingHelper
  def recruit
    key = "4b0ca9238f706863"
    form = "json"
    if params[:request_type] == "colleges"
      college_name = params[:keyword].bytes.map{|v|"%"+v.to_s(16)}.join
      count = 100
      uri = URI.parse("http://webservice.recruit.co.jp/shingaku/school/v1/?key=#{key}
                      &count=#{count}&format=#{form}&order=3&name=#{college_name}
                      &category_cd=0011&category_cd=0012&category_cd=0013")
      json = Net::HTTP.get(uri)
      @colleges = JSON.parse(json)["results"]["school"]

      render partial: "shared/ajax_select", locals: {elements: @colleges, request_type: "colleges"}
    elsif params[:request_type] == "faculties"
      code = params[:code]
      uri = URI.parse("http://webservice.recruit.co.jp/shingaku/school/v1/?key=#{key}&format=#{form}&code=#{code}")
      json = Net::HTTP.get(uri)
      @faculties = JSON.parse(json)["results"]["school"][0]["faculty"]

      render partial: "shared/ajax_select", locals: {elements: @faculties, request_type: "faculties"}
    end
  end
end
