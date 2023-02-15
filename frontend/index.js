setTimeout(() => {
  getStatistics();
}, 600);

function getStatistics() {
  // const data with the four mage houses of Hogwarts
  const data = [
    { name: "Gryffindor", total: 500 },
    { name: "Hufflepuff", total: 450 },
    { name: "Ravenclaw", total: 400 },
    { name: "Slytherin", total: 350 },
  ];
  // loop through the data and add the name and total to the div
  for (let i = 0; i < data.length; i++) {
    getHouseText(data[i]);
  }
}

function getHouseText(house) {
  const houseDiv = document.getElementById(
    house.name.toLowerCase() + "-content"
  );
  const text = `<p><strong>${house.name}:</strong> ${house.total}</p>`;
  houseDiv.innerHTML = text;
}

const apiUrl =
  "https://tactd3rsaxb6bculfgbgwowx2m0akarz.lambda-url.eu-west-3.on.aws/";

function callApi() {
  fetch(apiUrl)
    .then((res) => res.json())
    .then((data) => {
      console.log(data);
      const houseDiv = document.getElementById(
        data.name.toLowerCase() + "-content"
      );
      $(houseDiv).effect("bounce", "slow");
    });
}
