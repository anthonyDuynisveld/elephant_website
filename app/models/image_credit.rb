# Who made each picture on the site and what licence it is under. The pictures come from
# Wikimedia Commons, and CC BY / CC BY-SA licences require showing the author and licence.
# Keyed by the asset path used with image_tag, e.g. "pages/home-hero.jpg".
class ImageCredit < Data.define(:path, :source, :author, :license, :license_url)
  BY_SA_4 = ["CC BY-SA 4.0", "https://creativecommons.org/licenses/by-sa/4.0/"].freeze
  BY_4 = ["CC BY 4.0", "https://creativecommons.org/licenses/by/4.0/"].freeze
  BY_SA_3_DE = ["CC BY-SA 3.0 de", "https://creativecommons.org/licenses/by-sa/3.0/de/deed.en"].freeze
  CC0 = ["CC0", "https://creativecommons.org/publicdomain/zero/1.0/"].freeze

  def self.entry(path, source, author, license)
    new(path, source, author, *license)
  end

  ALL = [
    entry("pages/home-hero.jpg", "Kruger National Park (ZA), Elefant -- 2024 -- 0642.jpg", "Dietmar Rabich", BY_SA_4),
    entry("pages/anatomy-skeleton.png", "Asian elephant skeleton scale.svg", "Asier Larramendi", BY_4),
    entry("pages/habitat-range-map.png", "Verbreitungskarte Elefanten.svg", "NordNordWest", BY_SA_3_DE),
    entry("gallery/savanna-herd.jpg", "Elephant family near Savanna Lodge.jpg", "Cosal", BY_SA_4),
    entry("gallery/mother-and-calf.jpg", "A mother and calf elephant.jpg", "Smitha Surya", CC0),
    entry("gallery/trunk-at-work.jpg", "Asiatic-Elephant trunk.jpg", "UdayKiran28", CC0),
    entry("gallery/mud-bath.jpg", "Female African Elephant Taking Mud Bath 2019-07-23.jpg", "Axel Tschentscher", BY_SA_4),
    entry("gallery/asian-elephant-forest.jpg", "Asian Elephant in the Forest.jpg", "Sultan Ahmed 09", CC0),
    entry("gallery/watering-hole.jpg", "Elephants at the watering hole.jpg", "MrLDGCA", BY_SA_4)
  ].freeze

  def self.all
    ALL
  end

  def self.for(path)
    ALL.find { |credit| credit.path == path }
  end

  # The file's page on Wikimedia Commons, which shows the original and its full history
  def url
    "https://commons.wikimedia.org/wiki/File:#{source.tr(' ', '_')}"
  end
end
