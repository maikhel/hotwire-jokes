require "application_system_test_case"

class JokesRequestsTest < ApplicationSystemTestCase
  setup do
    @jokes_request = jokes_requests(:one)
  end

  test "visiting the index" do
    visit jokes_requests_url
    assert_selector "h1", text: "Jokes requests"
  end

  test "should create jokes request" do
    visit jokes_requests_url
    click_on "New jokes request"

    click_on "Create Jokes request"

    assert_text "Jokes request was successfully created"
    click_on "Back"
  end

  test "should update Jokes request" do
    visit jokes_request_url(@jokes_request)
    click_on "Edit this jokes request", match: :first

    click_on "Update Jokes request"

    assert_text "Jokes request was successfully updated"
    click_on "Back"
  end

  test "should destroy Jokes request" do
    visit jokes_request_url(@jokes_request)
    click_on "Destroy this jokes request", match: :first

    assert_text "Jokes request was successfully destroyed"
  end
end
