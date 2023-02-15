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
getStatistics();
function getHouseText(house) {
  const houseDiv = document.getElementById(
    house.name.toLowerCase() + "-content"
  );
  const text = `<p><strong>${house.name}</strong></p>`;
  houseDiv.innerHTML = text;
}

const apiUrl =
  "https://tactd3rsaxb6bculfgbgwowx2m0akarz.lambda-url.eu-west-3.on.aws/";
let gettingHouse = false;
function callApi() {
  if (gettingHouse) return;
  gettingHouse = true;
  const button = $(".button-call-api");
  // disable button
  button.prop("disabled", true);
  fetch(apiUrl)
    .then((res) => res.json())
    .then((data) => {
      const div = $(`.${data.name.toLowerCase()}-col`);
      // animate the div transparence from totally transparent to 100%
      const milis = 250;
      changeOpacity(div, 0, milis);
      changeOpacity(div, 1, milis);
      changeOpacity(div, 0, milis);
      changeOpacity(div, 1, milis);
      setTimeout(() => {
        gettingHouse = false;
        button.prop("disabled", false);
      }, 2000);
    });
}

function changeOpacity(div, value, miliseconds) {
  div.animate({ opacity: value }, miliseconds);
}
