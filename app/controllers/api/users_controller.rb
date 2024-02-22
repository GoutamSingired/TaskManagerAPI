class Api::UsersController < ApplicationController
  # GET /api/users/:id/tasks
  def tasks
    @user = User.find(params[:id])
    @tasks = @user.tasks
    render json: @tasks
  end
end
