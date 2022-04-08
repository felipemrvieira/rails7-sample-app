require "application_system_test_case"

class EmissionUploadsTest < ApplicationSystemTestCase
  setup do
    @emission_upload = emission_uploads(:one)
  end

  test "visiting the index" do
    visit emission_uploads_url
    assert_selector "h1", text: "Emission uploads"
  end

  test "should create emission upload" do
    visit emission_uploads_url
    click_on "New emission upload"

    fill_in "Admin", with: @emission_upload.admin_id
    fill_in "File name", with: @emission_upload.file_name
    check "Published" if @emission_upload.published
    check "Revised" if @emission_upload.revised
    click_on "Create Emission upload"

    assert_text "Emission upload was successfully created"
    click_on "Back"
  end

  test "should update Emission upload" do
    visit emission_upload_url(@emission_upload)
    click_on "Edit this emission upload", match: :first

    fill_in "Admin", with: @emission_upload.admin_id
    fill_in "File name", with: @emission_upload.file_name
    check "Published" if @emission_upload.published
    check "Revised" if @emission_upload.revised
    click_on "Update Emission upload"

    assert_text "Emission upload was successfully updated"
    click_on "Back"
  end

  test "should destroy Emission upload" do
    visit emission_upload_url(@emission_upload)
    click_on "Destroy this emission upload", match: :first

    assert_text "Emission upload was successfully destroyed"
  end
end
