function showLoadingMessage() {
  const loadingMessage = document.getElementById('loadingMessage');
  loadingMessage.style.display = 'block';
  loadingMessage.style.zIndex = '1000';
}

function hideLoadingMessage() {
  const loadingMessage = document.getElementById('loadingMessage');
  loadingMessage.style.display = 'none';
  loadingMessage.style.zIndex = '';
}

function initMap() {
  showLoadingMessage();

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
      hideLoadingMessage();
    }, () => {
      // Geolocationが失敗または拒否された場合、デフォルトの中心を設定
      map.setCenter({lat: 35.686, lng: 139.755});
      hideLoadingMessage();
    });
  } else {
    // ブラウザがGeolocationをサポートしていない場合、デフォルトの中心を設定
    map.setCenter({lat: 35.686, lng: 139.755});
    hideLoadingMessage();
  }
}
