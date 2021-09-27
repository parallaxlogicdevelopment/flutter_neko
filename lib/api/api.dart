import 'package:flutter_config/flutter_config.dart';

class APIUrl {
  Uri getCommonInfo() {
    if (FlutterConfig.get('APP_ENV') != "local") {
      return Uri.https(FlutterConfig.get('API_URL'), '/erp_dev/api/v1/get-common-info');
    } else {
      return Uri.http(FlutterConfig.get('API_URL'), '/api/v1/get-common-info');
    }
  }

  Uri createExpense() {
    if (FlutterConfig.get('APP_ENV') != "local") {
      return Uri.https(FlutterConfig.get('API_URL'), '/erp_dev/api/v1/create-expense');
    } else {
      return Uri.http(FlutterConfig.get('API_URL'), '/api/v1/create-expense');
    }
  }

  Uri signIn() {
    if (FlutterConfig.get('APP_ENV') != "local") {
      return Uri.https(FlutterConfig.get('API_URL'), '/erp_dev/api/v1/sign-in');
    } else {
      return Uri.http(FlutterConfig.get('API_URL'), '/api/v1/sign-in');
    }
  }

  Uri index() {
    if (FlutterConfig.get('APP_ENV') != "local") {
      return Uri.https(FlutterConfig.get('API_URL'), '/erp_dev/api/v1/index');
    } else {
      return Uri.http(FlutterConfig.get('API_URL'), '/api/v1/index');
    }
  }

  Uri signOut() {
    if (FlutterConfig.get('APP_ENV') != "local") {
      return Uri.https(FlutterConfig.get('API_URL'), '/erp_dev/api/v1/sign-out');
    } else {
      return Uri.http(FlutterConfig.get('API_URL'), '/api/v1/sign-out');
    }
  }

  Uri applyLeave() {
    if (FlutterConfig.get('APP_ENV') != "local") {
      return Uri.https(FlutterConfig.get('API_URL'), '/erp_dev/api/v1/apply-leave');
    } else {
      return Uri.http(FlutterConfig.get('API_URL'), '/api/v1/apply-leave');
    }
  }

  Uri clockIn() {
    if (FlutterConfig.get('APP_ENV') != "local") {
      return Uri.https(FlutterConfig.get('API_URL'), '/erp_dev/api/v1/clock-in');
    } else {
      return Uri.http(FlutterConfig.get('API_URL'), '/api/v1/clock-in');
    }
  }

  Uri clockOut() {
    if (FlutterConfig.get('APP_ENV') != "local") {
      return Uri.https(FlutterConfig.get('API_URL'), '/erp_dev/api/v1/clock-out');
    } else {
      return Uri.http(FlutterConfig.get('API_URL'), '/api/v1/clock-out');
    }
  }
}
