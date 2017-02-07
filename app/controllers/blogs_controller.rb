class BlogsController < ApplicationController

  def new
    @blog = Blog.new
  end
  def create
    @blog = Blog.new(blog_params)
    @blog.circle_id = params[:circle_id]
    @blog.author_id = current_user.id
    if @blog.save
      flash[:success] = "投稿完了"
      redirect_to [@blog.circle, @blog]
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
    @blog = Blog.find(params[:id])
    @circle = @blog.circle
    @blog.destroy
    flash[:success] = "削除完了"
    redirect_to @circle
  end

  private
    def blog_params
      params.require(:blog).permit(
          :title, :content, :circle_id
        )
    end
end
