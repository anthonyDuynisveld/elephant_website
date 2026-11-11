# Static list of gallery photos. Images aren't added yet, so each entry renders
# a placeholder until an image file is attached to it.
class GalleryPhoto < Data.define(:slug, :title, :caption, :description)
  def self.all
    ALL
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
      title: "A herd on the savanna",
      caption: "An African savanna elephant family crossing open grassland.",
      description: "Elephant herds are led by the oldest female, the matriarch. She remembers where to find water and food, " \
                   "and the rest of the family follows her lead, sometimes walking dozens of kilometres in a day."
    ),
    new(
      slug: "mother-and-calf",
      title: "Mother and calf",
      caption: "A calf stays close to its mother for protection.",
      description: "Calves weigh around 100 kg at birth and can stand within an hour. They nurse for two years or more, " \
                   "and aunts and older sisters help look after them, a behaviour called allomothering."
    ),
    new(
      slug: "trunk-at-work",
      title: "The trunk at work",
      caption: "Using the trunk to pull up a clump of grass.",
      description: "The trunk is a fusion of the nose and upper lip. It is strong enough to lift a log, " \
                   "yet precise enough to pick up a single peanut."
    ),
    new(
      slug: "mud-bath",
      title: "Mud bath",
      caption: "Coating the skin in mud to keep cool.",
      description: "Mud and dust work like sunscreen and bug spray. The wrinkles in an elephant's skin trap moisture, " \
                   "helping the animal stay cool in the heat."
    ),
    new(
      slug: "asian-elephant-forest",
      title: "Asian elephant in the forest",
      caption: "An Asian elephant moving through dense forest.",
      description: "Asian elephants are smaller than their African cousins and have smaller, rounded ears. " \
                   "Usually only some males grow large tusks."
    ),
    new(
      slug: "watering-hole",
      title: "At the watering hole",
      caption: "Elephants gather to drink at the end of a hot day.",
      description: "An adult elephant can drink well over 100 litres of water a day. In dry seasons, " \
                   "elephants dig into dry riverbeds with their feet and tusks to reach water underground."
    )
  ].freeze
end
