class BlogsController < ApplicationController

  before_action :authenticate_user!, except: [:show, :indexes]

  def indexes
    @blogs = Blog.all.order("created_at DESC")
  end
  def index
  end

  def new
    @blog = Blog.new
  end
  def create
    @blog = Blog.new(blog_params)
    @circle = Circle.find(params[:circle_id])
    if @blog.valid?
      # if params[:blog][:previewed]
      if true
        @blog.circle_id = params[:circle_id]
        @blog.author_id = current_user.id
        @blog.save
        flash[:success] = "投稿完了"
        redirect_to [@blog.circle, @blog]
      else
        # render 'preview'
      end
    else
      render 'new'
    end
  end

  def show
    @blog = Blog.find(params[:id])
    @circle = @blog.circle
    @author = @blog.author
  end

  def edit
    @blog = Blog.find(params[:id])
  end
  def update
    @blog = Blog.find(params[:id])
    if @blog.update_attributes(blog_params)
      flash[:success] = "編集完了"
      redirect_to [@blog.circle, @blog]
    else
      render 'edit'
    end
  end

  def destroy
    blog = Blog.find(params[:id])
    @circle = blog.circle
    blog.destroy
    flash[:success] = "削除完了"
    redirect_to @circle
  end

  private
    def blog_params
      params.require(:blog).permit(
          :circle_id,
          :title,
          :header_1, :header_2, :header_3,
          :content_1, :content_2, :content_3,
          :picture_1, :picture_2, :picture_3,
        )
    end
end
