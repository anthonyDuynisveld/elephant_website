# Static list of elephant photos. Each one is shown on the page (and tab) it fits best,
# via the shared/gallery_photo partial, and `page` is where it lives so the old
# /gallery/<slug> links can redirect there. The image is "<slug>.jpg" in the gallery
# asset folder; a placeholder shows if the file is missing.
class GalleryPhoto < Data.define(:slug, :title, :caption, :description, :page)
  ASSET_DIR = Rails.root.join("app/assets/images/gallery")

  def self.all
    ALL
  end

  def self.find(slug)
    all.find { |photo| photo.slug == slug } || raise(ActiveRecord::RecordNotFound)
  end

  # Where an old /gallery/<slug> link should go now
  def self.page_for(slug)
    all.find { |photo| photo.slug == slug }&.page || "/"
  end

  def image_path
    "gallery/#{slug}.jpg" if ASSET_DIR.join("#{slug}.jpg").exist?
  end

  ALL = [
    new(
      slug: "savanna-herd",
      title: "A herd on the grassland",
      caption: "An African elephant family walking across the grassland.",
      description: "A group of elephants is called a herd. The oldest female, called the matriarch, leads the way. " \
                   "She remembers where to find food and water, and her family follows her, sometimes for a very long walk.",
      page: "/life-in-the-wild#what-they-do"
    ),
    new(
      slug: "mother-and-calf",
      title: "Mother and baby",
      caption: "A baby elephant stays close to its mother to keep safe.",
      description: "A baby elephant is called a calf. It weighs about 100 kg when it's born and can stand up within an hour! " \
                   "Calves drink their mother's milk for two years or more, and aunts and big sisters help look after them.",
      page: "/body-and-food#body"
    ),
    new(
      slug: "trunk-at-work",
      title: "The trunk at work",
      caption: "Using its trunk to pull up a clump of grass.",
      description: "A trunk is a nose and top lip joined together. It's strong enough to lift a log, " \
                   "but careful enough to pick up a single peanut!",
      page: "/body-and-food#food"
    ),
    new(
      slug: "mud-bath",
      title: "Mud bath",
      caption: "Rolling in mud to keep cool.",
      description: "Mud and dust work like sunscreen and bug spray for elephants. The wrinkles in their skin hold on to " \
                   "water and mud, which helps them stay cool on hot days.",
      page: "/body-and-food#body"
    ),
    new(
      slug: "asian-elephant-forest",
      title: "Asian elephant in the forest",
      caption: "An Asian elephant walking through a thick forest.",
      description: "Asian elephants are smaller than African elephants and have smaller, rounder ears. " \
                   "Most of them don't have big tusks. Only some males grow them.",
      page: "/classification"
    ),
    new(
      slug: "watering-hole",
      title: "At the water hole",
      caption: "Elephants come to drink at the end of a hot day.",
      description: "A grown-up elephant can drink more than 100 litres of water in a day. That's enough to fill a small bathtub! " \
                   "When it's dry, elephants dig into dry riverbeds with their feet and tusks to find water underground.",
      page: "/life-in-the-wild#where-they-live"
    )
  ].freeze
end
