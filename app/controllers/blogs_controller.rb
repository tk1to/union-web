class BlogsController < ApplicationController

  def new
    @blog = Blog.new
    # @circle_id = params[:circle_id]
  end

  def create
    @blog = Blog.new(blog_params, )
    if @blog.save
      flash[:success] = "投稿完了"
      redirect_to @blog
    else
      render 'new'
    end
  end

  def show
    @blog = Blog.find(params[:id])
  end

  def edit
  end
  def update
  end

  def destroy
  end

  private
    def blog_params
      params.require(:blog).permit(
          :title, :content, :circle_id
        )
    end
end
