require "test_helper"

class JokesRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jokes_request = jokes_requests(:one)
  end

  test "should get index" do
    get jokes_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_jokes_request_url
    assert_response :success
  end

  test "should create jokes_request" do
    stub_request(:get, FetchJokesService::API_ENDPOINT)
      .to_return(status: 200, body: { value: "Chuck Norris can divide by zero." }.to_json)

    assert_difference("JokesRequest.count") do
      post jokes_requests_url, params: { jokes_request: { amount: 5, delay: 1 } }
    end

    assert_redirected_to jokes_request_url(JokesRequest.last)
    assert JokesRequest.last.jokes.count, 5
  end

  test "should show jokes_request" do
    get jokes_request_url(@jokes_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_jokes_request_url(@jokes_request)
    assert_response :success
  end

  test "should update jokes_request" do
    patch jokes_request_url(@jokes_request), params: { jokes_request: { amount: 20 } }
    assert @jokes_request.reload.amount, 20
    assert_redirected_to jokes_request_url(@jokes_request)
  end

  test "should destroy jokes_request" do
    assert_difference("JokesRequest.count", -1) do
      delete jokes_request_url(@jokes_request)
    end

    assert_redirected_to jokes_requests_url
  end
end
