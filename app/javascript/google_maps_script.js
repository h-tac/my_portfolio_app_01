// マップを表示する関数
function initMap() {
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
    loadingMessage.innerText = "Loading map";

    clearInterval(loadingInterval);
  }





  showLoadingMessage();

  let map = new google.maps.Map(document.getElementById('map'), {
    zoom: 15,
    fullscreenControl: false,
    streetViewControl: false,
    zoomControlOptions: {
      position: google.maps.ControlPosition.RIGHT_TOP,
    },
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





  // 現在地へ移動するカスタムコントロール
  const currentLocationButton = document.createElement('button');

  currentLocationButton.style.backgroundColor = '#fff';
  currentLocationButton.style.border = '2px solid #fff';
  currentLocationButton.style.borderRadius = '3px';
  currentLocationButton.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
  currentLocationButton.style.color = "rgb(25,25,25)";
  currentLocationButton.style.cursor = 'pointer';
  currentLocationButton.style.lineHeight = "28px";
  currentLocationButton.style.marginRight = '10px';
  currentLocationButton.style.marginTop = '10px';
  currentLocationButton.style.textAlign = 'center';
  currentLocationButton.title = '現在地へ移動する';
  currentLocationButton.className = "hover-opacity-icon";

  // FontAwesomeのアイコンを追加
  const currentLocationIcon = document.createElement('i');
  currentLocationIcon.className = "fa-solid fa-location-crosshairs fa-2xl";
  currentLocationButton.appendChild(currentLocationIcon);

  // クリックイベントを追加
  currentLocationButton.addEventListener('click', function() {
    showLoadingMessage();
    // ここで現在地を取得してマップを移動させる処理
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((position) => {
        let userLocation = {
          lat: position.coords.latitude,
          lng: position.coords.longitude,
        };
        map.setCenter(userLocation);
        hideLoadingMessage();
      });
    }
  });

  // コントロールをマップに追加
  map.controls[google.maps.ControlPosition.RIGHT_TOP].push(currentLocationButton);





  // 施設を登録するカスタムコントロール
  const addFacilityButton = document.createElement('button');

  addFacilityButton.style.backgroundColor = '#fff';
  addFacilityButton.style.border = '2px solid #fff';
  addFacilityButton.style.borderRadius = '3px';
  addFacilityButton.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
  addFacilityButton.style.color = "rgb(25,25,25)";
  addFacilityButton.style.cursor = 'pointer';
  addFacilityButton.style.lineHeight = "28px";
  addFacilityButton.style.marginRight = '10px';
  addFacilityButton.style.marginBottom = '10px';
  addFacilityButton.style.textAlign = 'center';
  addFacilityButton.title = 'マップに施設を登録する';
  addFacilityButton.className = "hover-opacity-icon";

  // FontAwesomeのアイコンを追加
  const addFacilityIcon = document.createElement('i');
  addFacilityIcon.className = "fa-sharp fa-solid fa-location-dot fa-2xl col-12";
  addFacilityButton.appendChild(addFacilityIcon);

  const addFacilityCaption = document.createElement('span');
  addFacilityCaption.innerText = "登録";
  addFacilityButton.appendChild(addFacilityCaption);

  // コントロールをマップに追加
  map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(addFacilityButton);
}
