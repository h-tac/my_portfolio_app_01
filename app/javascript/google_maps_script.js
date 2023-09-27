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

  // フラッシュメッセージを表示する関数
  function showFlashMessage(message) {
    // 既存のflashMessageがある場合は削除
    const existingFlashMessage = document.querySelector('.alert.alert-info');
    if (existingFlashMessage) {
      existingFlashMessage.remove();
    }

    const flashMessage = document.createElement('div');
    flashMessage.innerText = message;
    flashMessage.className = "alert alert-info";

    const alertContainer = document.getElementsByClassName('alert-container')[0];
    alertContainer.appendChild(flashMessage);
  
    setTimeout(() => {
      flashMessage.remove();
    }, 15000);
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
  function placeMarker(position, isCurrentUserLocation = false) {
    const marker = new google.maps.Marker({
      position: position,
      map: map,
      zIndex: 1
    });

    // 情報ウィンドウを作成
    if (isCurrentUserLocation) {
      const infoWindow = new google.maps.InfoWindow({
        content: '現在地',
        zIndex: 1
      });

      // マーカーのクリックイベントを追加し、情報ウィンドウを表示
      marker.addListener('click', function() {
        infoWindow.open(map, marker);
      });
    }
  }

  // ユーザーの現在地を取得
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition((position) => {
      // URLパラメータから緯度と経度を取得
      const urlParams = new URLSearchParams(window.location.search);
      const lat = parseFloat(urlParams.get('lat'));
      const lng = parseFloat(urlParams.get('lng'));
      const place_name = urlParams.get('place_name');

      let userLocation = {
        lat: position.coords.latitude,
        lng: position.coords.longitude,
      };

      if (lat && lng) {
        // 指定された緯度と経度を使用してマップの中心を設定
        map.setCenter({ lat: lat, lng: lng });

        showFlashMessage(`${place_name}へ移動しました`);
      } else {
        // マップの中心をユーザーの現在地に設定
        map.setCenter(userLocation);
      }

      // マーカーをユーザーの現在地に表示
      placeMarker(userLocation, true);

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

  // 一時的なマーカーを保存するための変数
  let tempMarker = null;

  // 一時的な情報ウィンドウを保存するための変数
  let infoWindow;

  // 与えられた位置情報からURLを生成し、リンクをそのURLに更新する関数
  function updateLinkWithCoordinates(location) {
    const lat = location.lat();
    const lng = location.lng();
    
    const newUrl = `/spots/new?lat=${lat}&lng=${lng}`;
    const registerLink = document.getElementById('registerLocationLink');
    registerLink.href = newUrl;  // ここでリンクの href 属性を更新
  }

  // クリックイベントを追加
  addFacilityButton.addEventListener('click', function() {
    showFlashMessage('登録したい地点にマーカーをドラッグ＆ドロップしてください');

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
      icon: 'https://maps.google.com/mapfiles/ms/micons/purple-dot.png',
      zIndex: 2
    });

    // マーカーのクリックイベントを設定
    google.maps.event.addListener(tempMarker, 'click', showInfoWindow);

    // マーカーがドラッグ開始されたときのイベントを設定
    tempMarker.addListener('dragstart', function() {
      if(infoWindow) {
        infoWindow.close();
      }
    });

    // マーカーがドラッグ終了したときのイベントを設定
    tempMarker.addListener('dragend', showInfoWindow);

    // infoWindowを表示する関数
    function showInfoWindow() {
      if(!infoWindow) {
        const linkContent = '<a href="/spots/new" id="registerLocationLink">この場所を登録する</a>';
        infoWindow = new google.maps.InfoWindow({
          content: linkContent,
          zIndex: 2
        });

        // infoWindowがDOMに追加された後にイベントを追加する
        google.maps.event.addListenerOnce(infoWindow, 'domready', function() {
          // リンクを取得してクリックイベントを追加
          const registerLink = document.getElementById('registerLocationLink');
          registerLink.addEventListener('click', function(e) {
            updateLinkWithCoordinates(tempMarker.getPosition()); // href を更新
          });
        });
      }
      infoWindow.open(map, tempMarker);
    }

    // 最初にinfoWindowを表示
    showInfoWindow();
  });

  // コントロールをマップに追加
  map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(addFacilityButton);
}
