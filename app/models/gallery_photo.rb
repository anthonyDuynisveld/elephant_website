# Static list of gallery photos. Each entry shows "<slug>.jpg" from the gallery
# asset folder, or a placeholder if no image file exists.
class GalleryPhoto < Data.define(:slug, :title, :caption, :description)
  ASSET_DIR = Rails.root.join("app/assets/images/gallery")

  def self.all
    ALL
  end

  # Drop "<slug>.mp4" (and optionally "<slug>.jpg" as the still frame) into
  # app/assets/images/gallery/ and the gallery card will play it on hover.
  def video_path
    "gallery/#{slug}.mp4" if ASSET_DIR.join("#{slug}.mp4").exist?
  end

  def poster_path
    "gallery/#{slug}.jpg" if ASSET_DIR.join("#{slug}.jpg").exist?
  end

  # Photos where the elephants are small in the frame get zoomed in on the
  # gallery tile: slug => [focus x%, focus y%, zoom factor].
  TILE_FOCUS = { "watering-hole" => [47, 53, 3.2] }.freeze

  def tile_image_style
    x, y, zoom = TILE_FOCUS[slug]
    "transform-origin: #{x}% #{y}%; transform: scale(#{zoom});" if x
  end

  def self.find(slug)
    all.find { |photo| photo.slug == slug } || raise(ActiveRecord::RecordNotFound)
  end

  def to_param
    slug
  end

  def previous
    index = self.class.all.index(self)
    self.class.all[index - 1] if index.positive?
  end

  def next
    self.class.all[self.class.all.index(self) + 1]
  end

  ALL = [
    new(
      slug: "savanna-herd",
      title: "A herd on the grassland",
      caption: "An African elephant family walking across the grassland.",
      description: "A group of elephants is called a herd. The oldest female, called the matriarch, leads the way. " \
                   "She remembers where to find food and water, and her family follows her, sometimes for a very long walk."
    ),
    new(
      slug: "mother-and-calf",
      title: "Mother and baby",
      caption: "A baby elephant stays close to its mother to keep safe.",
      description: "A baby elephant is called a calf. It weighs about 100 kg when it's born and can stand up within an hour! " \
                   "Calves drink their mother's milk for two years or more, and aunts and big sisters help look after them."
    ),
    new(
      slug: "trunk-at-work",
      title: "The trunk at work",
      caption: "Using its trunk to pull up a clump of grass.",
      description: "A trunk is a nose and top lip joined together. It's strong enough to lift a log, " \
                   "but careful enough to pick up a single peanut!"
    ),
    new(
      slug: "mud-bath",
      title: "Mud bath",
      caption: "Rolling in mud to keep cool.",
      description: "Mud and dust work like sunscreen and bug spray for elephants. The wrinkles in their skin hold on to " \
                   "water and mud, which helps them stay cool on hot days."
    ),
    new(
      slug: "asian-elephant-forest",
      title: "Asian elephant in the forest",
      caption: "An Asian elephant walking through a thick forest.",
      description: "Asian elephants are smaller than African elephants and have smaller, rounder ears. " \
                   "Most of them don't have big tusks. Only some males grow them."
    ),
    new(
      slug: "watering-hole",
      title: "At the water hole",
      caption: "Elephants come to drink at the end of a hot day.",
      description: "A grown-up elephant can drink more than 100 litres of water in a day. That's enough to fill a small bathtub! " \
                   "When it's dry, elephants dig into dry riverbeds with their feet and tusks to find water underground."
    )
  ].freeze
end
