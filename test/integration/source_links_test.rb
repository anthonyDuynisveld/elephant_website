require "test_helper"

class SourceLinksTest < ActionDispatch::IntegrationTest
  test "claims link to their sources in a new tab" do
    { classification_path => 3, life_in_the_wild_path => 2 }.each do |path, count|
      get path
      assert_dom "a.source-link[target=_blank][rel=noopener]", { count: count }, "Expected #{count} sources on #{path}"
    end
  end
end
