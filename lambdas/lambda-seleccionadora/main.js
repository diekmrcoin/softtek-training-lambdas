const houses = [
  {
    name: "Gryffindor",
    mascot: "Lion",
    headOfHouse: "Minerva McGonagall",
    houseGhost: "Nearly Headless Nick",
    founder: "Goderic Gryffindor",
    values: ["Bravery", "Nerve", "Chivalry"],
    colors: ["Scarlet", "Gold"],
  },
  {
    name: "Hufflepuff",
    mascot: "Badger",
    headOfHouse: "Pomona Sprout",
    houseGhost: "The Fat Friar",
    founder: "Helga Hufflepuff",
    values: ["Hard Work", "Patience", "Loyalty"],
    colors: ["Yellow", "Black"],
  },
  {
    name: "Ravenclaw",
    mascot: "Eagle",
    headOfHouse: "Filius Flitwick",
    houseGhost: "The Grey Lady",
    founder: "Rowena Ravenclaw",
    values: ["Intelligence", "Creativity", "Learning"],
    colors: ["Blue", "Bronze"],
  },
  {
    name: "Slytherin",
    mascot: "Snake",
    headOfHouse: "Severus Snape",

    houseGhost: "The Bloody Baron",
    founder: "Salazar Slytherin",
    values: ["Ambition", "Cunning", "Leadership"],
    colors: ["Green", "Silver"],
  },
];

module.exports.handler = async (event) => {
  const randomHouse = houses[Math.floor(Math.random() * houses.length)];
  return { chosenHouse: randomHouse };
};
