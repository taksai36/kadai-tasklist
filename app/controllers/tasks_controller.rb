class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
   before_action :require_user_logged_in
    before_action :correct_user, only: [:update,:destroy]

  
   def index
     if logged_in?
      @user = current_user
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
     end
   end

  def show
  end

  def new
    @task = Task.new
    @task = current_user.tasks.build 
  end

  def create
    @task =Task.new(task_params)
    @task = current_user.tasks.build(task_params) 
    
    if @task.save
      flash[:success] = 'Taskが正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskが投稿されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    
    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    
    flash[:success] ='Taskは正常に削除されました'
    redirect_to tasks_url
  end
  
  
  def correct_user 
    @task = current_user.tasks.find_by(id: params[:id]) 
    unless @task 
    redirect_to root_url 
    end 
  end
  
  private
  def set_task
    @task =Task.find(params[:id])
  end
  
  
  
  private
  #Strong Parameter
  def task_params
    params.require(:task).permit(:content,:status)
  end
  
 
end

