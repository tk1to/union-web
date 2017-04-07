class ApiController < ApplicationController
  include EncodingHelper
  def recruit
    key = "4b0ca9238f706863"
    form = "json"
    if params[:request_type] == "colleges"
      college_name = params[:keyword].bytes.map{|v|"%"+v.to_s(16)}.join
      count = 100
      uri = URI.parse("http://webservice.recruit.co.jp/shingaku/school/v1/?key=#{key}&count=#{count}&format=#{form}&order=3&name=#{college_name}")
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)["results"]["school"]

      if result && 0 < result.count
        @colleges = result
      else
        @colleges = []
      end
      name = params[:origin_controller].nil? ? "college" : "#{params[:origin_controller]}[college]"
      render partial: "shared/ajax_select", locals: {elements: @colleges, name: name}
    elsif params[:request_type] == "faculties"
      code = params[:code]
      uri = URI.parse("http://webservice.recruit.co.jp/shingaku/school/v1/?key=#{key}&format=#{form}&code=#{code}")
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)["results"]["school"][0]["faculty"]

      if result && 0 < result.count
        @faculties = result
      else
        @faculties = []
      end
      name = params[:origin_controller].nil? ? "faculty" : "#{params[:origin_controller]}[faculty]"
      render partial: "shared/ajax_select", locals: {elements: @faculties, name: name}
    end
  end
end
