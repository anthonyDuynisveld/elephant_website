# Outside reading for each topic page, in two groups: kid-friendly sites for learning, and
# sources a student can cite in a research report. Every link opens in a new tab.
class PageResource < Data.define(:label, :url, :blurb)
  NAT_GEO_AFRICAN = new(
    "National Geographic Kids: African elephant",
    "https://kids.nationalgeographic.com/animals/mammals/facts/african-elephant",
    "Fun facts, photos and videos made for kids."
  )
  NAT_GEO_ASIAN = new(
    "National Geographic Kids: Asian elephant",
    "https://kids.nationalgeographic.com/animals/mammals/facts/asian-elephant",
    "Fun facts, photos and videos made for kids."
  )
  SAN_DIEGO_ZOO = new(
    "San Diego Zoo Animals: Elephant",
    "https://animals.sandiegozoo.org/animals/elephant",
    "Easy-to-read facts from the people who look after elephants."
  )
  DK_FIND_OUT = new(
    "DK Find Out: Elephants",
    "https://www.dkfindout.com/us/animals-and-nature/elephants/",
    "Colourful pictures and short facts, great for a first look."
  )
  WWF = new(
    "World Wildlife Fund: Elephants",
    "https://www.worldwildlife.org/species/elephant",
    "Why elephants need our help and how people protect them."
  )
  NATIONAL_ZOO = new(
    "Smithsonian's National Zoo: Asian elephant",
    "https://nationalzoo.si.edu/animals/asian-elephant",
    "Facts and conservation work from a museum and zoo. A solid source to cite."
  )
  SMITHSONIAN = new(
    "Smithsonian: Elephants",
    "https://www.si.edu/spotlight/elephants",
    "Collections and articles from the Smithsonian. A solid source to cite."
  )
  ELEPHANT_VOICES = new(
    "ElephantVoices",
    "https://www.elephantvoices.org",
    "Scientists' research on how elephants talk and behave, with a big library of calls and gestures."
  )
  SAVE_THE_ELEPHANTS = new(
    "Save the Elephants",
    "https://www.savetheelephants.org",
    "A research group in Kenya that tracks elephants and shares what it learns."
  )
  IUCN = new(
    "IUCN Red List",
    "https://www.iucnredlist.org",
    "The official list of which animals are in danger. Search \"elephant\" to see each species' status."
  )

  # Tools for any report, shown on every page.
  GOOGLE_SCHOLAR = new(
    "Google Scholar",
    "https://scholar.google.com",
    "Search real research papers. Ask a teacher or grown-up to help, as some papers use hard words."
  )
  CITATION_HELP = new(
    "Purdue OWL: Citing sources",
    "https://owl.purdue.edu/owl/research_and_citation/resources.html",
    "Step-by-step help for writing down where your facts came from."
  )

  Links = Data.define(:learn, :research)

  SETS = {
    anatomy: Links.new(learn: [NAT_GEO_AFRICAN, NAT_GEO_ASIAN, DK_FIND_OUT], research: [NATIONAL_ZOO, SMITHSONIAN]),
    behavior: Links.new(learn: [SAN_DIEGO_ZOO, DK_FIND_OUT], research: [ELEPHANT_VOICES, SAVE_THE_ELEPHANTS]),
    classification: Links.new(learn: [NAT_GEO_ASIAN, DK_FIND_OUT], research: [IUCN, SMITHSONIAN]),
    diet: Links.new(learn: [SAN_DIEGO_ZOO, NAT_GEO_AFRICAN], research: [NATIONAL_ZOO, SMITHSONIAN]),
    habitat: Links.new(learn: [WWF, SAN_DIEGO_ZOO], research: [SAVE_THE_ELEPHANTS, IUCN])
  }.freeze

  TOOLS = [GOOGLE_SCHOLAR, CITATION_HELP].freeze

  def self.for(page)
    SETS.fetch(page)
  end
end
