# Static list of elephants in pop culture, grouped by the kind of reference (movie, book, ...).
# Each reference can link to one of our own pages (`path`, a route helper name, plus an optional
# `anchor` to open a tab) and/or an outside site (`url`).
class PopCultureReference < Data.define(:category, :name, :picture, :colour, :from, :story, :real_fact,
                                        :link_label, :path, :anchor, :url_label, :url)
  Category = Data.define(:key, :label, :title, :picture, :fact_label, :intro, :footnote)

  def initialize(real_fact: nil, link_label: nil, path: nil, anchor: nil, url_label: nil, url: nil, **)
    super
  end

  def self.categories
    CATEGORIES
  end

  def self.for(category)
    ALL.select { |reference| reference.category == category.key }
  end

  CATEGORIES = [
    Category.new(
      key: :movies, label: "Movies & cartoons", title: "Elephants on the big screen", picture: "🎬",
      fact_label: "Real elephant fact", footnote: nil,
      intro: "Lots of movies have elephant stars. Some are cartoons and some are real!"
    ),
    Category.new(
      key: :books, label: "Books", title: "Elephants in stories", picture: "📚",
      fact_label: "Real elephant fact", footnote: nil,
      intro: "Grab a book! These elephants are waiting for you at the library."
    ),
    Category.new(
      key: :documentaries, label: "Nature shows", title: "Real elephants on TV", picture: "📺",
      fact_label: "Real elephant fact", footnote: nil,
      intro: "These shows follow real elephant families in the wild. Ask a grown-up to watch with you."
    ),
    Category.new(
      key: :websites, label: "Websites", title: "Great websites for school projects", picture: "💻",
      fact_label: "Real elephant fact",
      intro: "Want to learn even more? These websites have facts, photos and videos about elephants.",
      footnote: "<strong>Project tip:</strong> Always write down where you found a fact. You can say " \
                "\"The World Wildlife Fund says...\" Then your teacher knows you did great research!"
    ),
    Category.new(
      key: :myths, label: "Myth or fact?", title: "When stories get it wrong", picture: "🤔",
      fact_label: "The truth",
      intro: "Not everything in cartoons and stories is true. Let's check some famous elephant ideas!",
      footnote: "<strong>Why it matters:</strong> Elephants are wild animals, not toys or clowns. " \
                "When we know the truth about them, we can help keep them safe."
    )
  ].freeze

  ALL = [
    # Movies & cartoons
    new(
      category: :movies, name: "Dumbo", picture: "🐘🪶", colour: "kid-card--sky", from: "A Disney movie (1941 & 2019)",
      story: "Dumbo is a baby elephant with very big ears. Everyone laughs at his ears, until he uses them to fly!",
      real_fact: "Real elephants can't fly. But they flap their big ears to cool down on hot days.",
      link_label: "Learn about elephant ears", path: :body_and_food_path, anchor: "body",
      url_label: "Disney's Dumbo", url: "https://movies.disney.com/dumbo-2019"
    ),
    new(
      category: :movies, name: "Colonel Hathi", picture: "🐘🥁", colour: "kid-card--sand",
      from: "The Jungle Book (1967 & 2016)",
      story: "Colonel Hathi leads his elephant troop on a marching parade through the jungle. Hup, two, three, four!",
      real_fact: "\"Hathi\" means \"elephant\" in Hindi. Real Asian elephants live in the forests of India.",
      link_label: "Learn where elephants live", path: :where_they_live_path,
      url_label: "Disney's Jungle Book", url: "https://movies.disney.com/the-jungle-book-2016"
    ),
    new(
      category: :movies, name: "Tantor", picture: "🐘🌿", colour: "kid-card--leaf", from: "Disney's Tarzan (1999)",
      story: "Tantor is Tarzan's best elephant friend. He gets scared easily, but he is very brave when his friends need help.",
      real_fact: "Real elephants look after each other. If a baby is in trouble, the whole family rushes to help.",
      link_label: "Learn about elephant families", path: :what_they_do_path,
      url_label: "Disney's Tarzan", url: "https://movies.disney.com/tarzan"
    ),
    new(
      category: :movies, name: "Manny", picture: "🦣❄️", colour: "kid-card--ice", from: "The Ice Age movies",
      story: "Manny is a woolly mammoth. He is big, grumpy on the outside and kind on the inside.",
      real_fact: "Mammoths are elephant cousins that lived long ago. They had thick hairy coats to stay warm.",
      link_label: "Learn about elephant cousins", path: :classification_path
    ),
    new(
      category: :movies, name: "Bo", picture: "🐘🚁", colour: "kid-card--pink", from: "Operation Dumbo Drop (1995)",
      story: "This movie is based on a true story. Soldiers have to carry an elephant all the way through the jungle " \
             "to a village that needs one.",
      real_fact: "In parts of Asia, elephants are very important to people and are a big part of their history.",
      link_label: "Learn about Asian elephants", path: :classification_path,
      url_label: "See it on IMDb", url: "https://www.imdb.com/title/tt0114048/"
    ),

    # Books
    new(
      category: :books, name: "Babar", picture: "👑🐘", colour: "kid-card--sun", from: "A picture book (1931)",
      story: "Babar is a little elephant who visits a big city, then grows up to be king. He wears a smart green suit and a crown.",
      real_fact: "Real elephant families are led by a grandma elephant called the matriarch.",
      link_label: "Learn about elephant families", path: :what_they_do_path,
      url_label: "Find the book", url: "https://www.amazon.com/Story-Babar-Jean-Brunhoff/dp/0394805755"
    ),
    new(
      category: :books, name: "Horton", picture: "🐘🌸", colour: "kid-card--pink", from: "A Dr. Seuss book",
      story: "Horton hears tiny people living on a speck of dust. He says: \"A person's a person, no matter how small.\"",
      real_fact: "Real elephants have amazing hearing. They can even feel sounds through their feet!",
      link_label: "Learn how elephants talk", path: :what_they_do_path,
      url_label: "Find the book", url: "https://www.amazon.com/Horton-Hears-Who-Dr-Seuss/dp/0394800788"
    ),
    new(
      category: :books, name: "Elmer", picture: "🐘🌈", colour: "kid-card--rainbow", from: "A picture book",
      story: "Elmer is a patchwork elephant covered in bright colours. He is funny and loves to make his friends laugh.",
      real_fact: "Real elephants are grey. They roll in mud and dust to protect their skin from the sun.",
      link_label: "Learn about elephant skin", path: :body_and_food_path, anchor: "body"
    ),
    new(
      category: :books, name: "Gerald", picture: "🐘🐷", colour: "kid-card--leaf", from: "Elephant & Piggie books",
      story: "Gerald is an elephant who worries a lot. His best friend is Piggie, and they always help each other.",
      real_fact: "Real elephants have best friends too. They say hello by wrapping their trunks together.",
      link_label: "Learn about elephant friends", path: :what_they_do_path
    ),
    new(
      category: :books, name: "Stella", picture: "🐘🦍", colour: "kid-card--sand", from: "The One and Only Ivan",
      story: "Stella is a kind elephant who lives in a shopping mall with her friend Ivan the gorilla. " \
             "They dream of a better home.",
      real_fact: "Elephants need lots of space. In the wild, they can walk many kilometres in one day!",
      link_label: "Learn where elephants live", path: :where_they_live_path,
      url_label: "Find the book", url: "https://www.amazon.com/One-Only-Ivan-Katherine-Applegate/dp/0061992275"
    ),
    new(
      category: :books, name: "The Elephant Whisperer", picture: "🐘🧑", colour: "kid-card--sky", from: "A true story",
      story: "A man named Lawrence takes care of a herd of wild elephants in South Africa. " \
             "Over time, the elephants learn to trust him.",
      real_fact: "Elephants are very smart. They can remember friends, both elephants and people, for many years.",
      link_label: "Learn how elephants think", path: :what_they_do_path,
      url_label: "Find the book", url: "https://www.amazon.com/Elephant-Whisperer-Life-Herd-African/dp/1250007828"
    ),

    # Nature shows
    new(
      category: :documentaries, name: "Echo", picture: "🐘👵", colour: "kid-card--sand",
      from: "Echo: An Elephant to Remember (2010)",
      story: "Echo was a grandma elephant who led her family in Kenya. Scientists watched her family for more than 30 years!",
      real_fact: "Elephant families stick together for their whole lives.",
      link_label: "Learn about elephant families", path: :what_they_do_path,
      url_label: "Watch on PBS", url: "https://www.pbs.org/wnet/nature/echo-an-elephant-to-remember-introduction/5560/"
    ),
    new(
      category: :documentaries, name: "Elephant", picture: "🐘🏜️", colour: "kid-card--sun", from: "Disneynature (2020)",
      story: "Follow an elephant family on a very long walk across the Kalahari Desert to find food and water.",
      real_fact: "The matriarch remembers where the water is, even after many years.",
      link_label: "Learn what elephants eat", path: :body_and_food_path, anchor: "food",
      url_label: "See it on IMDb", url: "https://www.imdb.com/title/tt10296790/"
    ),
    new(
      category: :documentaries, name: "Secrets of the Elephants", picture: "🐘🌍", colour: "kid-card--leaf",
      from: "National Geographic (2023)",
      story: "This show visits four different elephant families around the world to see how they live.",
      real_fact: "Elephants in different places have different ways of doing things, just like people!",
      link_label: "Learn where elephants live", path: :where_they_live_path,
      url_label: "See it on IMDb", url: "https://www.imdb.com/title/tt21064498/"
    ),
    new(
      category: :documentaries, name: "The Ivory Game", picture: "🐘🛡️", colour: "kid-card--ice", from: "Netflix (2016)",
      story: "Meet the brave people who work hard to protect elephants and stop people from taking their tusks. " \
             "Best for big kids and grown-ups.",
      real_fact: "Lots of people around the world work every day to keep elephants safe.",
      link_label: "Learn about elephant tusks", path: :body_and_food_path, anchor: "body",
      url_label: "See it on IMDb", url: "https://www.imdb.com/title/tt5952266/"
    ),

    # Websites
    new(
      category: :websites, name: "National Geographic Kids", picture: "🗺️", colour: "kid-card--sun", from: "Website",
      story: "Fun facts, photos and videos about African elephants, made just for kids.",
      link_label: "See our elephant photos", path: :gallery_index_path,
      url_label: "Visit Nat Geo Kids",
      url: "https://kids.nationalgeographic.com/animals/mammals/facts/african-elephant"
    ),
    new(
      category: :websites, name: "World Wildlife Fund", picture: "🐼", colour: "kid-card--leaf", from: "Website",
      story: "Find out why elephants need our help and what people are doing to protect them.",
      link_label: "Learn where elephants live", path: :where_they_live_path,
      url_label: "Visit WWF", url: "https://www.worldwildlife.org/species/elephant"
    ),
    new(
      category: :websites, name: "San Diego Zoo Wildlife Explorers", picture: "🦁", colour: "kid-card--sky", from: "Website",
      story: "Easy-to-read facts and great photos about how elephants live.",
      link_label: "Learn how elephants live", path: :what_they_do_path,
      url_label: "Visit San Diego Zoo", url: "https://sdzwildlifeexplorers.org/animals/african-elephant"
    ),
    new(
      category: :websites, name: "Smithsonian", picture: "🏛️", colour: "kid-card--sand", from: "Website",
      story: "Learn how big elephants are, what they eat and how they live together, from a famous museum and zoo.",
      link_label: "Learn about elephant bodies", path: :body_and_food_path, anchor: "body",
      url_label: "Visit the Smithsonian", url: "https://www.si.edu/spotlight/elephants"
    ),

    # Myth or fact?
    new(
      category: :myths, name: "\"Elephants love doing circus tricks\"", picture: "🎪", colour: "kid-card--pink",
      from: "Myth",
      story: "For a long time, circuses showed elephants standing on balls and doing tricks, like they were having fun.",
      real_fact: "Elephants don't do tricks in the wild. Many countries don't allow elephants in circuses anymore.",
      link_label: "Learn what elephants really do", path: :what_they_do_path
    ),
    new(
      category: :myths, name: "\"Elephants are scared of mice\"", picture: "🐭", colour: "kid-card--sky", from: "Myth",
      story: "In lots of cartoons, a big elephant jumps up on a chair when it sees a tiny mouse.",
      real_fact: "Scientists have never found that elephants are afraid of mice. " \
                 "They can just be careful around small, quick animals.",
      link_label: "Learn how elephants stay safe", path: :what_they_do_path
    ),
    new(
      category: :myths, name: "\"An elephant never forgets\"", picture: "🧠", colour: "kid-card--sun",
      from: "Half true!",
      story: "People say elephants remember everything forever.",
      real_fact: "Elephants have great memories. They remember water holes and friends for years. " \
                 "But like us, they don't remember everything!",
      link_label: "Learn how elephants think", path: :what_they_do_path
    )
  ].freeze
end
