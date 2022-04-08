require "test_helper"

class EmissionUploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @emission_upload = emission_uploads(:one)
  end

  test "should get index" do
    get emission_uploads_url
    assert_response :success
  end

  test "should get new" do
    get new_emission_upload_url
    assert_response :success
  end

  test "should create emission_upload" do
    assert_difference("EmissionUpload.count") do
      post emission_uploads_url, params: { emission_upload: { admin_id: @emission_upload.admin_id, file_name: @emission_upload.file_name, published: @emission_upload.published, revised: @emission_upload.revised } }
    end

    assert_redirected_to emission_upload_url(EmissionUpload.last)
  end

  test "should show emission_upload" do
    get emission_upload_url(@emission_upload)
    assert_response :success
  end

  test "should get edit" do
    get edit_emission_upload_url(@emission_upload)
    assert_response :success
  end

  test "should update emission_upload" do
    patch emission_upload_url(@emission_upload), params: { emission_upload: { admin_id: @emission_upload.admin_id, file_name: @emission_upload.file_name, published: @emission_upload.published, revised: @emission_upload.revised } }
    assert_redirected_to emission_upload_url(@emission_upload)
  end

  test "should destroy emission_upload" do
    assert_difference("EmissionUpload.count", -1) do
      delete emission_upload_url(@emission_upload)
    end

    assert_redirected_to emission_uploads_url
  end
end
