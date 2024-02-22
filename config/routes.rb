Rails.application.routes.draw do
  namespace :api do
    resources :tasks do
      member do
        post 'assign', to: 'tasks#assign'
        put 'progress', to: 'tasks#update_progress'
      end
      collection do
        get 'overdue', to: 'tasks#overdue'
        get 'status/:status', to: 'tasks#status'
        get 'completed', to: 'tasks#completed_tasks_by_date_range'
        get 'statistics', to: 'tasks#statistics'
        get 'priority_queue', to: 'tasks#priority_queue'
      end
    end
    resources :users, only: [:show] do
      member do
        get 'tasks', to: 'users#tasks'
      end
    end
  end
end
