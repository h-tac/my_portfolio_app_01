function initMap() {
  // ローディングメッセージを表示するための変数
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

  // マップを表示するための変数
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

  // ジオコーダーを初期化
  let geocoder = new google.maps.Geocoder();

  // 一時的なマーカーを保存するための変数
  let tempMarker = null;

  // 一時的な情報ウィンドウを保存するための変数
  let infoWindow;

  // 位置情報から住所を取得する関数
  function logLocationAddress(location) {
    geocoder.geocode({'location': location}, function(results, status) {
      if (status === 'OK') {
        if (results[0]) {
          console.log(results[0].formatted_address);
        } else {
          console.log('No results found');
        }
      } else {
        console.log('Geocoder failed due to: ' + status);
      }
    });
  }

  // クリックイベントを追加
  addFacilityButton.addEventListener('click', function() {
    let center = map.getCenter();
    
    // 以前の一時的なマーカーが存在する場合は削除
    if(tempMarker) {
      tempMarker.setMap(null);
      if (infoWindow) {
        infoWindow.close();
      }
    }

    // マップの中心に一時的なマーカーを立てる
    tempMarker = new google.maps.Marker({
      position: center,
      map: map,
      draggable: true, // ユーザーがドラッグして位置を変更できるようにする
      icon: 'https://maps.google.com/mapfiles/ms/micons/purple-dot.png'
    });

    // マーカーのクリックイベントを設定
    google.maps.event.addListener(tempMarker, 'click', function() {
      if(!infoWindow) {
        const linkContent = '<a href="#" id="registerLocationLink">この場所を登録する</a>';
        infoWindow = new google.maps.InfoWindow({
          content: linkContent
        });

        // InfoWindowがDOMに追加された後にイベントを追加する
        google.maps.event.addListenerOnce(infoWindow, 'domready', function() {
          // リンクを取得してクリックイベントを追加
          const registerLink = document.getElementById('registerLocationLink');
          registerLink.addEventListener('click', function(e) {
            e.preventDefault();
            logLocationAddress(tempMarker.getPosition());
          });
        });
      }
      infoWindow.open(map, tempMarker);
    });

    // マーカーがドラッグ開始されたときのイベントを設定
    tempMarker.addListener('dragstart', function() {
      if(infoWindow) {
        infoWindow.close();
      }
    });
  });

  // コントロールをマップに追加
  map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(addFacilityButton);
}
