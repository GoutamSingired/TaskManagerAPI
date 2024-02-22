require "test_helper"

class Api::TasksControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_tasks_create_url
    assert_response :success
  end

  test "should get update" do
    get api_tasks_update_url
    assert_response :success
  end

  test "should get destroy" do
    get api_tasks_destroy_url
    assert_response :success
  end

  test "should get index" do
    get api_tasks_index_url
    assert_response :success
  end

  test "should get assign" do
    get api_tasks_assign_url
    assert_response :success
  end

  test "should get progress" do
    get api_tasks_progress_url
    assert_response :success
  end

  test "should get overdue" do
    get api_tasks_overdue_url
    assert_response :success
  end

  test "should get status" do
    get api_tasks_status_url
    assert_response :success
  end

  test "should get completed" do
    get api_tasks_completed_url
    assert_response :success
  end

  test "should get statistics" do
    get api_tasks_statistics_url
    assert_response :success
  end
end
