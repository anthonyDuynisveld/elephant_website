# "Copy" buttons that let kids grab a fact or picture and paste it into their
# project. Behaviour lives in copy_controller.js; both buttons start hidden and
# the controller shows them only if the browser can copy.
module CopyHelper
  # Copies the words of the block it sits in, so put it as the block's last child.
  # `about` names the fact for screen readers, e.g. copy_button("Tusks").
  def copy_button(about)
    copy_control(label: "Copy", aria_label: "Copy: #{about}")
  end

  # Copies a picture so it can be pasted into slides or a document.
  def copy_picture_button(source, about)
    copy_control(label: "Copy picture", aria_label: "Copy picture: #{about}", image: image_path(source))
  end

  private

  def copy_control(label:, aria_label:, image: nil)
    tag.span class: "copy", hidden: true, data: { controller: "copy", copy_image_value: image } do
      button = tag.button(type: "button", class: "copy-button", aria: { label: aria_label }, data: { action: "copy#copy" }) do
        tag.span("📋", aria: { hidden: true }, data: { copy_target: "icon" }) +
          tag.span(label, data: { copy_target: "label" })
      end

      button + tag.span(class: "copy__status", role: "status", data: { copy_target: "status" })
    end
  end
end
