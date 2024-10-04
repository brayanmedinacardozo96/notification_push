abstract class IServiceNotification {
  init({String? topic});
  backgroundHandler();
  getToken();
  requestPermission();
}
