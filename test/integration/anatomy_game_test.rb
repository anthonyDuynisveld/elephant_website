require "test_helper"

class AnatomyGameTest < ActionDispatch::IntegrationTest
  test "the game page loads with every part to find" do
    get anatomy_game_path
    assert_response :success
    assert_dom "[data-controller=anatomy-game]"
    assert_dom "[data-anatomy-game-target=part]", count: 8
  end

  test "the header links to the game" do
    get root_path
    assert_dom "nav.site-nav a[href='#{anatomy_game_path}']"
  end
end
