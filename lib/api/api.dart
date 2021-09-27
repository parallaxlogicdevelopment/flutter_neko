

class APIUrl {
  String url = 'parallaxlogic.dev';
  bool local = false;

  Uri getCommonInfo() {
    if (!local) {
      return Uri.https(url, '/erp_dev/api/v1/get-common-info');
    } else {
      return Uri.http(url, '/api/v1/get-common-info');
    }
  }

  Uri createExpense() {
    if (!local) {
      return Uri.https(url, '/erp_dev/api/v1/create-expense');
    } else {
      return Uri.http(url, '/api/v1/create-expense');
    }
  }

  Uri signIn() {
    if (!local) {
      return Uri.https(url, '/erp_dev/api/v1/sign-in');
    } else {
      return Uri.http(url, '/api/v1/sign-in');
    }
  }

  Uri index() {
    if (!local) {
      return Uri.https(url, '/erp_dev/api/v1/index');
    } else {
      return Uri.http(url, '/api/v1/index');
    }
  }

  Uri signOut() {
    if (!local) {
      return Uri.https(url, '/erp_dev/api/v1/sign-out');
    } else {
      return Uri.http(url, '/api/v1/sign-out');
    }
  }

  Uri applyLeave() {
    if (!local) {
      return Uri.https(url, '/erp_dev/api/v1/apply-leave');
    } else {
      return Uri.http(url, '/api/v1/apply-leave');
    }
  }

  Uri clockIn() {
    if (!local) {
      return Uri.https(url, '/erp_dev/api/v1/clock-in');
    } else {
      return Uri.http(url, '/api/v1/clock-in');
    }
  }

  Uri clockOut() {
    if (!local) {
      return Uri.https(url, '/erp_dev/api/v1/clock-out');
    } else {
      return Uri.http(url, '/api/v1/clock-out');
    }
  }
}
