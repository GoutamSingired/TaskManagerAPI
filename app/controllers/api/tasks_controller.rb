# app/controllers/api/tasks_controller.rb
class Api::TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy, :assign, :update_progress]

  # POST /api/tasks
  def create

    @task = Task.new(task_params)
    @task.status = "Pending"

    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PUT /api/tasks/{taskId}
  def update
    new_task_params = task_params
    # Check if the status is changed to "Completed" and set completed_date accordingly
    if task_params[:status] == "Completed" && @task.status != "Completed"
      new_task_params = new_task_params.merge(:completed_date => Date.today)
      @task.progress = 100
    end

    if @task.update(new_task_params)
      render json: @task
    else
      render json: { error: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/tasks/{taskId}
  def destroy

    if @task
      @task.destroy
      render json: { message: "Task deleted successfully" }, status: :ok
    else
      render json: { error: "Task not found" }, status: :not_found
    end
  end

  # GET /api/tasks
  def index
    @tasks = Task.all
    render json: @tasks
  end

  # POST /api/tasks/{taskId}/assign
  def assign
    user_id = params[:user_id]
    if user_id.blank?
      render json: { error: "User ID is required" }, status: :unprocessable_entity
      return
    end

    user = User.find_by(id: user_id)
    unless user
      render json: { error: "User not found" }, status: :not_found
      return
    end

    @task.user = user

    if @task.save
      render json: { message: "Task assigned to user successfully" }, status: :ok
    else
      render json: { error: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/tasks/{taskId}/progress
  def update_progress

    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/tasks/overdue
  def overdue
    @overdue_tasks = Task.overdue
    render json: @overdue_tasks
  end

  # GET /api/tasks/status/{status}
  def status
    status = params[:status]
    @tasks = Task.where(status: status)
    render json: @tasks
  end

  # GET /api/tasks/completed
  def completed_tasks_by_date_range
    start_date = params[:startDate]
    end_date = params[:endDate]

    if start_date.present? && end_date.present?
      @completed_tasks = Task.where(status: "Completed", completed_date: start_date..end_date)
      render json: @completed_tasks
    else
      render json: { error: "Both startDate and endDate are required parameters" }, status: :bad_request
    end
  end


   # GET /api/tasks/statistics
   def statistics
    total_tasks = Task.count
    completed_tasks = Task.where(status: "Completed").count
    percentage_completed = total_tasks.zero? ? 0 : (completed_tasks.to_f / total_tasks * 100).round(2)

    statistics_data = {
      total_tasks: total_tasks,
      completed_tasks: completed_tasks,
      percentage_completed: percentage_completed
    }

    render json: statistics_data
  end

  # GET /api/tasks/priority_queue
  def priority_queue
    high_priority_due_date_limit = Date.tomorrow
    medium_priority_due_date_limit = 1.week.from_now

    high_priority_tasks = Task.where('due_date <= ?', high_priority_due_date_limit)
    medium_priority_tasks = Task.where('due_date > ? AND due_date <= ?', high_priority_due_date_limit, medium_priority_due_date_limit)
    low_priority_tasks = Task.where('due_date > ?', medium_priority_due_date_limit)

    priority_queue = {
      high: high_priority_tasks.order(due_date: :asc),
      medium: medium_priority_tasks.order(due_date: :asc),
      low: low_priority_tasks.order(due_date: :asc)
    }

    render json: priority_queue
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find_by(id: params[:id])

    unless @task
      render json: { error: "Task not found" }, status: :not_found
    end
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :description, :due_date, :completed_date, :status, :user_id, :progress)
  end
end
