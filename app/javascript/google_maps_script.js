function initMap() {
  let map = new google.maps.Map(document.getElementById('map'), {
    zoom: 15,
  });

  // ユーザーの現在地を取得
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition((position) => {
      let userLocation = {
        lat: position.coords.latitude,
        lng: position.coords.longitude,
      };

      // マップの中心をユーザーの現在地に設定
      map.setCenter(userLocation);
    }, () => {
      // Geolocationが失敗または拒否された場合、デフォルトの中心を設定
      map.setCenter({lat: 35.686, lng: 139.755});
    });
  } else {
    // ブラウザがGeolocationをサポートしていない場合、デフォルトの中心を設定
    map.setCenter({lat: 35.686, lng: 139.755});
  }
}
