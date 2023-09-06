let loadingInterval;
let loadingDots = 0;

// ローディングメッセージを表示する関数
function showLoadingMessage() {
  const loadingMessage = document.getElementById('loadingMessage');
  loadingMessage.style.display = 'block';
  loadingMessage.style.zIndex = '1000';

  loadingInterval = setInterval(() => {
    if (loadingDots < 3) {
      loadingMessage.innerText += ".";
      loadingDots++;
    } else {
      loadingMessage.innerText = "Loading map";
      loadingDots = 0;
    }
  }, 500);
}

// ローディングメッセージを非表示にする関数
function hideLoadingMessage() {
  const loadingMessage = document.getElementById('loadingMessage');
  loadingMessage.style.display = 'none';
  loadingMessage.style.zIndex = '';

  clearInterval(loadingInterval);
}

// マップを表示する関数
function initMap() {
  showLoadingMessage();

  let map = new google.maps.Map(document.getElementById('map'), {
    zoom: 15,
  });

  // マーカーをマップの特定の位置に追加する関数
  function placeMarker(position) {
    new google.maps.Marker({
      position: position,
      map: map
    });
  }

  // ユーザーの現在地を取得
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition((position) => {
      let userLocation = {
        lat: position.coords.latitude,
        lng: position.coords.longitude,
      };

      // マップの中心をユーザーの現在地に設定
      map.setCenter(userLocation);

      // マーカーをユーザーの現在地に表示
      placeMarker(userLocation);

      hideLoadingMessage();
    }, () => {
      // Geolocationが失敗または拒否された場合、デフォルトの中心を設定
      let defaultLocation = {lat: 35.686, lng: 139.755};

      map.setCenter(defaultLocation);

      placeMarker(defaultLocation);

      hideLoadingMessage();
    });
  } else {
    // ブラウザがGeolocationをサポートしていない場合、デフォルトの中心を設定
    let defaultLocation = {lat: 35.686, lng: 139.755};

    map.setCenter(defaultLocation);

    placeMarker(defaultLocation);

    hideLoadingMessage();
  }
}
