require "test_helper"

class CopyButtonsTest < ActionDispatch::IntegrationTest
  test "fact pages have copy buttons" do
    [ root_path, life_in_the_wild_path, body_and_food_path, classification_path ].each do |path|
      get path

      assert_response :success
      assert_dom "button.copy-button", { minimum: 1 }, "Expected copy buttons on #{path}"
    end
  end

  test "pictures can be copied" do
    get life_in_the_wild_path
    assert_dom ".copy[data-copy-image-value*='habitat-range-map']"

    get body_and_food_path
    assert_dom ".copy[data-copy-image-value*='anatomy-skeleton']"

    photo = GalleryPhoto.all.first
    get gallery_path(photo)
    assert_dom ".copy[data-copy-image-value*='#{photo.slug}'] button[aria-label='Copy picture: #{photo.title}']"
  end
end
