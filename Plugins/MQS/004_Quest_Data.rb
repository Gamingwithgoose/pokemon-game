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
    :ID => "6",
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
    :Name => "The journey begins",
    :QuestGiver => "Professor Oak",
    :Stage1 => "Deliver the parcel to the Pokémon Mart in Viridian City.",
    :Stage2 => "Return to the Professor.",
    :Location1 => "Viridian City",
    :Location2 => "nil",
    :QuestDescription => "The Professor has entrusted me with an important delivery for the Viridian City Pokémon Mart. This is my first task, best not mess it up!",
    :RewardString => "nil"
  }
  
  Quest7 = {
    :ID => "7",
    :Name => "Close encounters of the... first kind?",
    :QuestGiver => "nil",
    :Stage1 => "Make contact with the strange creatures.",
    :Location1 => "Rock Tunnel",
    :QuestDescription => "A sudden burst of light, and then...! What are you?",
    :RewardString => "A possible probing."
  }
  
  Quest8 = {
    :ID => "8",
    :Name => "These boots were made for walking",
    :QuestGiver => "Musician #1",
    :Stage1 => "Listen to the musician's, uhh, music.",
    :Stage2 => "Find the source of the power outage.",
    :Location1 => "nil",
    :Location2 => "Celadon City Sewers",
    :QuestDescription => "A musician was feeling down because he thinks no one likes his music. I should help him drum up some business."
  }
  
  Quest9 = {
    :ID => "9",
    :Name => "Got any grapes?",
    :QuestGiver => "Duck",
    :Stage1 => "Listen to The Duck Song.",
    :Stage2 => "Try not to sing it all day.",
    :Location1 => "YouTube",
    :QuestDescription => "Let's try to revive old memes by listening to this funny song about a duck wanting grapes.",
    :RewardString => "A loss of braincells. Hurray!"
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
