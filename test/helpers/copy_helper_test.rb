require "test_helper"

class CopyHelperTest < ActionView::TestCase
  test "copy_button starts hidden and is named for the fact it copies" do
    render html: copy_button("Tusks")

    assert_dom "span.copy[hidden][data-controller=copy]:not([data-copy-image-value])" do
      assert_dom "button.copy-button[type=button][aria-label='Copy: Tusks'][data-action='copy#copy']", text: /Copy/
      assert_dom "[role=status][data-copy-target=status]"
    end
  end

  test "copy_picture_button points the controller at the picture" do
    render html: copy_picture_button("gallery/mud-bath.jpg", "Mud bath")

    assert_dom "span.copy[hidden][data-copy-image-value*='gallery/mud-bath']" do
      assert_dom "button[aria-label='Copy picture: Mud bath']", text: /Copy picture/
    end
  end
end
