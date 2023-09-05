// let map;

// async function initMap() {
//   const { Map } = await google.maps.importLibrary("maps");

//   map = new Map(document.getElementById("map"), {
//     center: { lat: 35.686, lng: 139.755 },
//     zoom: 15,
//   });
// }

// initMap();

function initMap() {
  let map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 35.686, lng: 139.755},
    zoom: 15,
  });
}
