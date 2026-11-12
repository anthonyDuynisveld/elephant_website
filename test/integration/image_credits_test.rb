require "test_helper"

class ImageCreditsTest < ActionDispatch::IntegrationTest
  test "every picture on the site has a credit" do
    (Dir["app/assets/images/gallery/*.jpg"] + Dir["app/assets/images/pages/*"]).each do |file|
      path = file.delete_prefix("app/assets/images/")
      assert ImageCredit.for(path), "No credit for #{path}"
    end
  end

  test "credits page lists everyone" do
    get credits_path
    assert_response :success
    ImageCredit.all.each { |credit| assert_dom "a[href=?]", credit.url }
  end

  test "pages with pictures show the credit" do
    [ body_and_food_path, life_in_the_wild_path, classification_path ].each do |path|
      get path
      assert_dom ".image-credit a", { minimum: 1 }, "Expected a credit on #{path}"
    end
  end
end
