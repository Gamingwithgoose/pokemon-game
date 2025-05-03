module QuestModule
  
  # You don't actually need to add any information, but the respective fields in the UI will be blank or "???"
  # I included this here mostly as an example of what not to do, but also to show it's a thing that exists
  Quest0 = {
  
  }
  
  # Here's the simplest example of a single-stage quest with everything specified
  Quest1 = {
    :ID => "1",
    :Name => "A Master's Journey",
    :QuestGiver => "nil",
    :Stage1 => "Explore the Island",
    :Location1 => "Three Island",
    :QuestDescription => "Explore the island to see what the natives have to offer.",
    :RewardString => "nil"
  }
  
  # Here's an extension of the above that includes multiple stages
  Quest2 = {
    :ID => "2",
    :Name => "Lost-Elle?",
    :QuestGiver => "LOSTELLE's dad",
    :Stage1 => "Look for clues.",
    :Location1 => "Three Island",
    :QuestDescription => "LOSTELLE's father mentioned something about Berry Forest. Wonder where that is?",
    :RewardString => "nil"
  }
  
  # Here's an example of a quest with lots of stages that also doesn't have a stage location defined for every stage
  Quest3 = {
    :ID => "3",
    :Name => "Last-minute chores",
    :QuestGiver => "nil",
    :Stage1 => "Deliver the Meteroite to Celio.",
    :Stage2 => "Kanto Bound",
    :Stage3 => "There's a Maniac that wants to see you.",
    :Stage4 => "An Errand for the Professor",
    :QuestDescription => "NOW it's a Master's Journey?",
    :RewardString => "In Depth Data in the Pokedex"
  }
  
  # Here's an example of not defining the quest giver and reward text
  Quest4 = {
    :ID => "4",
    :Name => "Since You're Heading That Way",
    :QuestGiver => "Oak",
    :Stage1 => "Deliver Research to Bill at his cottage.",
    :Location1 => "Seaside Cottage",
    :QuestDescription => "You've proven you can be trusted. Be sure to deliver the research safely.",
    :RewardString => "S.S. Ticket"
  }
  
  # Other random examples you can look at if you want to fill out the UI and check out the page scrolling
  Quest5 = {
    :ID => "5",
    :Name => "Indigo-go",
    :QuestGiver => "Main Story",
    :Stage1 => "Check out Pewter City's Gym.",
	:Stage2 => "Check out Cerulean City's Gym.",
	:Stage3 => "Check out Vermilion City's Gym.",
    :Stage4 => "Check out Celadon City's Gym.",
	:Stage5 => "Check out Fushia City's Gym.",
	:Stage6 => "Check out Saffron City's Gym.",
	:Stage7 => "Check out Cinnabar City's Gym.",
	:Stage8 => "Check out Viridian City's Gym.",
	:Location1 => "Pewter City",
	:Location2 => "Cerulean City",
	:Location3 => "Vermilion City",
	:Location4 => "Celadon City",
	:Location5 => "Fushia City",
	:Location6 => "Saffron City",
	:Location7 => "Cinnabar City",
	:Location8 => "Viridian City",
    :QuestDescription => "Gotta Collect'em All (KANTO EDITION)",
    :RewardString => "You'll be the very best! Duh!"
  }
  
  Quest6 = {
    :ID => "6",
    :Name => "An Important File",
    :QuestGiver => "???",
    :Stage1 => "Take the file to Prof. Oak.",
    :Location1 => "Pallet Town",
    :QuestDescription => "Some scientist-looking guy has given you a file to bring to Prof. Oak. Wonder what it contains.",
    :RewardString => "Special"
  }
  
  Quest7 = {
    :ID => "7",
    :Name => "Pre-Historic Allies",
    :QuestGiver => "BLUE",
    :Stage1 => "Look for fossils!",
    :Location1 => "Rock Tunnel",
    :QuestDescription => "Can you get to the fossils before TEAM ROCKET?",
    :RewardString => "A pre-historic friend."
  }
  
  Quest8 = {
    :ID => "8",
    :Name => "The Elitest of the Four",
    :QuestGiver => "Main Story",
    :Stage1 => "Visit the Elite 4",
    :Location1 => "Indigo Plateau",
    :QuestDescription => "Time so see if you have what it takes to become the champion of KANTO."
  }
  
  Quest9 = {
    :ID => "9",
    :Name => "A Road of Victories",
    :QuestGiver => "Main Story",
    :Stage1 => "Explore Victory Road",
    :Location1 => "Victory Road",
    :QuestDescription => "The path might not be easy, but it has to be done.",
    :RewardString => "nil"
  }
  
  Quest10 = {
    :ID => "10",
    :Name => "Singing in the rain",
    :QuestGiver => "Some old dude",
    :Stage1 => "I've run out of things to write.",
    :Stage2 => "If you're reading this, I hope you have a great day!",
    :Location1 => "Somewhere prone to rain?",
    :QuestDescription => "Whatever you want it to be.",
    :RewardString => "Wet clothes."
  }
  
  Quest11 = {
    :ID => "11",
    :Name => "When is this list going to end?",
    :QuestGiver => "Me",
    :Stage1 => "When IS this list going to end?",
    :Stage2 => "123",
    :Stage3 => "456",
    :Stage4 => "789",
    :QuestDescription => "I'm losing my sanity.",
    :RewardString => "nil"
  }
  
  Quest12 = {
    :ID => "12",
    :Name => "The laaast melon",
    :QuestGiver => "Some stupid dodo",
    :Stage1 => "Fight for the last of the food.",
    :Stage2 => "Don't die.",
    :Location1 => "A volcano/cliff thing?",
    :Location2 => "Good advice for life.",
    :QuestDescription => "Tea and biscuits, anyone?",
    :RewardString => "Food, glorious food!"
  }

end
