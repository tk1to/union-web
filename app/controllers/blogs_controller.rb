class BlogsController < ApplicationController

  before_action :authenticate_user!, except: [:show, :index]
  before_action :member_check, only: [:new, :edit, :create, :update, :destroy]
  before_action :author_check, only: [:edit, :update, :destroy]
  before_action :editor_check, only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:circle_id]
      @circle = Circle.find(params[:circle_id])
      @blogs  = Blog.where(circle_id: @circle.id).order("created_at DESC").page(params[:page]).per(25)
    else
      @blogs = Blog.objects_per_circles.page(params[:page]).per(25)
    end
  end

  def new
    @blog = Blog.new
  end
  def create
    @blog   = Blog.new(blog_params)
    @circle = Circle.find(params[:circle_id])
    author  = current_user
    @blog.assign_attributes(circle_id: @circle.id, author_id: author.id)
    if @blog.save
      flash[:success] = "投稿完了"
      create_notifications(author, @blog.id)
      redirect_to [@circle, @blog]
    else
      render "new"
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
    if @blog.update(blog_params)
      flash[:success] = "編集完了"
      redirect_to [@blog.circle, @blog]
    else
      render "edit"
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
        :title,
        :header_1, :header_2, :header_3,
        :content_1, :content_2, :content_3,
        :picture_1, :picture_2, :picture_3,
      )
    end
    def create_notifications(author, blog_id)
      author.followers.each do |user|
        user.notifications.create(notification_type: 1, user_id: author.id, blog_id: blog_id)
        user.update_attribute(:new_notifications_exist, true)
      end
    end

    def author_check
      blog = Blog.find(params[:id])
      unless blog.author == current_user
        flash[:alert] = "ブログを投稿したユーザーのみが編集できます"
        redirect_to :top
      end
    end
end
