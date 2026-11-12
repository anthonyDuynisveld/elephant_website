module ApplicationHelper
  # A "Source: ..." link that sits at the end of a fact, so kids can check it and cite it.
  # It's plain text inside the fact, so when a fact is copied the source comes along too.
  def source_link(name, url)
    link_to "Source: #{name} ↗", url, target: "_blank", rel: "noopener", class: "text-link source-link"
  end
end
