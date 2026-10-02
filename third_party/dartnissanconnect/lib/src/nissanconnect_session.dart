import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dartnissanconnect/src/nissanconnect_response.dart';
import 'package:dartnissanconnect/src/nissanconnect_vehicle.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;

class Services {
  static final int BREAKDOWN_ASSISTANCE_CALL = 1;
  static final int SVT_WITH_VEHICLE_BLOCKAGE = 10;
  static final int MAINTENANCE_ALERT = 101;
  static final int VEHICLE_SOFTWARE_UPDATES = 107;
  static final int MY_CAR_FINDER = 12;
  static final int MIL_ON_NOTIFICATION = 15;
  static final int VEHICLE_HEALTH_REPORT = 18;
  static final int ADVANCED_CAN = 201;
  static final int VEHICLE_STATUS_CHECK = 202;
  static final int LOCK_STATUS_CHECK = 2021;
  static final int NAVIGATION_FACTORY_RESET = 208;
  static final int MESSAGES_TO_THE_VEHICLE = 21;
  static final int VEHICLE_DATA = 2121;
  static final int VEHICLE_DATA_2 = 2122;
  static final int VEHICLE_WIFI = 213;
  static final int ADVANCED_VEHICLE_DIAGNOSTICS = 215;
  static final int NAVIGATION_MAP_UPDATES = 217;
  static final int VEHICLE_SETTINGS_TRANSFER = 221;
  static final int LAST_MILE_NAVIGATION = 227;
  static final int GOOGLE_STREET_VIEW = 229;
  static final int GOOGLE_SATELITE_VIEW = 230;
  static final int DYNAMIC_EV_ICE_RANGE = 232;
  static final int ECO_ROUTE_CALCULATION = 233;
  static final int CO_PILOT = 234;
  static final int DRIVING_JOURNEY_HISTORY = 235;
  static final int NISSAN_RENAULT_BROADCASTS = 241;
  static final int ONLINE_PARKING_INFO = 243;
  static final int ONLINE_RESTAURANT_INFO = 244;
  static final int ONLINE_SPEED_RESTRICTION_INFO = 245;
  static final int WEATHER_INFO = 246;
  static final int VEHICLE_ACCESS_TO_EMAIL = 248;
  static final int VEHICLE_ACCESS_TO_MUSIC = 249;
  static final int VEHICLE_ACCESS_TO_CONTACTS = 262;
  static final int APP_DOOR_LOCKING = 27;
  static final int GLONASS = 276;
  static final int ZONE_ALERT = 281;
  static final int SPEEDING_ALERT = 282;
  static final int SERVICE_SUBSCRIPTION = 284;
  static final int PAY_HOW_YOU_DRIVE = 286;
  static final int CHARGING_SPOT_INFO = 288;
  static final int FLEET_ASSET_INFORMATION = 29;
  static final int CHARGING_SPOT_INFO_COLLECTION = 292;
  static final int CHARGING_START = 299;
  static final int CHARGING_STOP = 303;
  static final int INTERIOR_TEMP_SETTINGS = 307;
  static final int CLIMATE_ON_OFF_NOTIFICATION = 311;
  static final int CHARGING_SPOT_SEARCH = 312;
  static final int PLUG_IN_REMINDER = 314;
  static final int CHARGING_STOP_NOTIFICATION = 317;
  static final int BATTERY_STATUS = 319;
  static final int BATTERY_HEATING_NOTIFICATION = 320;
  static final int VEHICLE_STATE_OF_CHARGE_PERCENT = 322;
  static final int BATTERY_STATE_OF_HEALTH_PERCENT = 323;
  static final int PAY_AS_YOU_DRIVE = 34;
  static final int DRIVING_ANALYSIS = 340;
  static final int CO2_GAS_SAVINGS = 341;
  static final int ELECTRICITY_FEE_CALCULATION = 342;
  static final int CHARGING_CONSUMPTION_HISTORY = 344;
  static final int BATTERY_MONITORING = 345;
  static final int BATTERY_DATA = 347;
  static final int APP_BASED_NAVIGATION = 35;
  static final int CHARGING_SPOT_UPDATES = 354;
  static final int RECHARGEABLE_AREA = 358;
  static final int NO_CHARGING_SPOT_INFO = 359;
  static final int EV_RANGE = 360;
  static final int CLIMATE_ON_OFF = 366;
  static final int ONLINE_FUEL_STATION_INFO = 367;
  static final int DESTINATION_SEND_TO_CAR = 37;
  static final int ECALL = 4;
  static final int GOOGLE_PLACES_SEARCH = 40;
  static final int PREMIUM_TRAFFIC = 43;
  static final int AUTO_COLLISION_NOTIFICATION_ACN = 6;
  static final int THEFT_BURGLAR_NOTIFICATION_VEHICLE = 7;
  static final int ECO_CHALLENGE = 721;
  static final int ECO_CHALLENGE_FLEET = 722;
  static final int MOBILE_INFORMATION = 74;
  static final int URL_PRESET_ON_VEHICLE = 77;
  static final int ASSISTED_DESTINATION_SETTING = 78;
  static final int CONCIERGE = 79;
  static final int PERSONAL_DATA_SYNC = 80;
  static final int THEFT_BURGLAR_NOTIFICATION_APP = 87;
  static final int STOLEN_VEHICLE_TRACKING_SVT = 9;
  static final int REMOTE_ENGINE_START = 96;
  static final int HORN_AND_LIGHTS = 97;
  static final int CURFEW_ALERT = 98;
  static final int TEMPERATURE = 2042;
  static final int VALET_PARKING_CALL = 401;
  static final int PANIC_CALL = 406;

  List _services;

  Services(this._services);

  bool hasService(int id) => _services.any((service) =>
      service['id'] == id && service['activationState'] == 'ACTIVATED');
}

class NissanConnectSession {
  Map settings = <String, Map>{
    'EU': <String, String>{
      // MyNISSAN OneID (WSO2) login, see https://github.com/dan-r/HomeAssistant-NissanConnect
      'client_id': 'ZM3WK7ax1OtQKYQ8Qqzcv5VgiA8a',
      'scope': 'openid name profile email offline_access',
      'auth_base_url': 'https://login.mynissan-account.com/',
      'redirect_uri': 'com://wso2.service.nci',
      'auth_brand': 'Nissan',
      'auth_client': 'mynissanapp',
      'auth_platform': 'Android',
      'auth_locale': 'en_GB',
      'car_adapter_base_url': // carAdapter_eu_prod
          'https://alliance-platform-caradapter-prod.apps.eu2.kamereon.io/car-adapter/',
      'user_adapter_base_url': // userAdapter_eu_prod
          'https://alliance-platform-usersadapter-prod.apps.eu2.kamereon.io/user-adapter/',
      'user_base_url':
          'https://nci-bff-web-prod.apps.eu2.kamereon.io/bff-web/' // bffWeb_eu_prod
    }
  };

  var SRP_KEY =
      'D5AF0E14718E662D12DBB4FE42304DF5A8E48359E22261138B40AA16CC85C76A11B43200A1EECB3C9546A262D1FBD51ACE6FCDE558C00665BBF93FF86B9F8F76AA7A53CA74F5B4DFF9A4B847295E7D82450A2078B5A28814A7A07F8BBDD34F8EEB42B0E70499087A242AA2C5BA9513C8F9D35A81B33A121EEF0A71F3F9071CCD';

  bool debug;
  List<String> debugLog = [];

  var username;
  var password;
  var bearerToken;

  late NissanConnectVehicle vehicle;
  late List<NissanConnectVehicle> vehicles;

  NissanConnectSession({this.debug = false});

  Future<NissanConnectResponse> requestWithRetry(
      {required String endpoint,
      String method = 'POST',
      Map<String, String>? additionalHeaders,
      Map? params}) async {
    NissanConnectResponse response = await request(
        endpoint: endpoint,
        method: method,
        additionalHeaders: additionalHeaders,
        params: params);

    if (response.statusCode >= 400 && response.statusCode < 500) {
      _print('Signing in and trying request again: $response');

      await login(username: username, password: password);

      response = await request(
          endpoint: endpoint,
          method: method,
          additionalHeaders: additionalHeaders,
          params: params);
    }
    return response;
  }

  Future<NissanConnectResponse> request(
      {required String endpoint,
      String method = 'POST',
      Map<String, String>? additionalHeaders,
      Map? params}) async {
    _print('Invoking NissanConnect/Kamereon API: $endpoint');
    _print('Params: $params');

    Map<String, String> headers = Map();

    if (bearerToken != null) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    _print('Headers: $headers');

    http.Response response;
    switch (method) {
      case 'GET':
        response = await http.get(Uri.parse(endpoint), headers: headers);
        break;
      default:
        response = await http.post(Uri.parse(endpoint),
            headers: headers, body: json.encode(params));
    }

    dynamic jsonData;
    try {
      jsonData = json.decode(response.body);
      _print('Result: $jsonData');
    } catch (e) {
      _print('JSON decoding failed!');
    }

    return NissanConnectResponse(
        response.statusCode, response.headers, jsonData);
  }

  Future<NissanConnectVehicle> login(
      {required String username, required String password}) async {
    this.username = username;
    this.password = password;
    this.bearerToken = null;

    final Map eu = settings['EU'];
    final http.Client client = http.Client();
    NissanConnectResponse response;
    try {
      _cookies.clear();
      final String verifier = _randomUrlSafe(64);
      final String challenge = base64Url
          .encode(crypto.sha256.convert(ascii.encode(verifier)).bytes)
          .replaceAll('=', '');
      final String state = _randomUrlSafe(32);

      final Uri authorizeUri =
          Uri.parse('${eu['auth_base_url']}oauth2/authorize')
              .replace(queryParameters: <String, String>{
        'response_type': 'code',
        'redirect_uri': eu['redirect_uri'],
        'client_id': eu['client_id'],
        'state': state,
        'scope': eu['scope'],
        'code_challenge': challenge,
        'code_challenge_method': 'S256',
        'locale': eu['auth_locale'],
        'brand': eu['auth_brand'],
        'client': eu['auth_client'],
      });

      // Load the login page, following redirects within the auth host.
      http.Response page = await _authSend(client, 'GET', authorizeUri);
      for (int i = 0; i < 10 && _isRedirect(page); i++) {
        final Uri target = page.request!.url.resolve(page.headers['location']!);
        if (!_isAuthUri(target)) {
          throw Exception('Unexpected Nissan login redirect: $target');
        }
        page = await _authSend(client, 'GET', target);
      }
      final Map<String, String>? form = _findLoginForm(page.body);
      if (page.statusCode != 200 || form == null) {
        throw Exception('Nissan login form is unavailable');
      }

      final Uri formUri = page.request!.url.resolve(form['__action__']!);
      if (!_isAuthUri(formUri)) {
        throw Exception('Unexpected Nissan login form target');
      }
      final Map<String, String> loginData = Map.of(form)..remove('__action__');
      final String region = loginData['regionCode'] ?? '';
      loginData['userName'] = username;
      loginData['username'] =
          region.isNotEmpty ? '$region/$username' : username;
      loginData['password'] = password;

      http.Response step = await _authSend(client, 'POST', formUri,
          headers: <String, String>{
            'Origin': '${formUri.scheme}://${formUri.authority}',
            'Referer': page.request!.url.toString(),
          },
          form: loginData);

      // Follow redirects until the app callback carrying the authorization code.
      final Uri callbackBase = Uri.parse(eu['redirect_uri']);
      Uri callback;
      while (true) {
        if (_isRedirect(step)) {
          final Uri target =
              step.request!.url.resolve(step.headers['location']!);
          if (target.scheme == callbackBase.scheme &&
              target.host == callbackBase.host) {
            callback = target;
            break;
          }
          if (!_isAuthUri(target)) {
            throw Exception('Unexpected Nissan authorization redirect: $target');
          }
          step = await _authSend(client, 'GET', target);
          continue;
        }
        if (step.statusCode == 200 && _findLoginForm(step.body) != null) {
          throw Exception('Nissan login failed: invalid credentials');
        }
        throw Exception('Nissan login did not return an authorization code');
      }

      if (callback.queryParameters['state'] != state) {
        throw Exception('Invalid Nissan login state');
      }
      final String? code = callback.queryParameters['code'];
      if (code == null || code.isEmpty) {
        throw Exception('Nissan login failed: invalid credentials');
      }

      // Exchange the code for OneID tokens.
      final http.Response tokenResponse = await _authSend(
          client, 'POST', Uri.parse('${eu['auth_base_url']}oauth2/token'),
          form: <String, String>{
            'redirect_uri': eu['redirect_uri'],
            'grant_type': 'authorization_code',
            'client_id': eu['client_id'],
            'code': code,
            'code_verifier': verifier,
            'scope': eu['scope'],
          });
      final Map oneId = _decodeJsonMap(tokenResponse);
      if (tokenResponse.statusCode != 200 || oneId['id_token'] == null) {
        throw Exception('Unable to obtain Nissan OneID token');
      }

      // Exchange the OneID id_token for a Kamereon access token.
      final http.Response kamereonResponse = await _authSend(
          client,
          'POST',
          Uri.parse('${eu['user_base_url']}v1/oauth2/access_token').replace(
              queryParameters: <String, String>{
            'platform': eu['auth_platform']
          }),
          headers: <String, String>{
            'Authorization': oneId['id_token'],
            'Content-Type': 'application/vnd.api+json',
          });
      final Map kamereon = _decodeJsonMap(kamereonResponse);
      if (kamereonResponse.statusCode != 200 ||
          kamereon['access_token'] == null) {
        throw Exception('Unable to obtain Kamereon token');
      }
      this.bearerToken = kamereon['access_token'];
    } finally {
      client.close();
    }

    response = await request(
        endpoint: '${settings['EU']['user_adapter_base_url']}v1/users/current',
        method: 'GET');

    var userId = response.body['userId'];

    response = await request(
        endpoint: '${settings['EU']['user_base_url']}v5/users/$userId/cars',
        method: 'GET');

    vehicles = [];

    for (Map vehicle in response.body['data']) {
      vehicles.add(NissanConnectVehicle(
          this,
          Services(vehicle['services'] ?? []),
          vehicle['vin'],
          vehicle['modelName'],
          vehicle['nickname'] ??
              '${vehicle['modelName']} ${vehicles.length + 1}'));
    }

    return vehicle = vehicles.first;
  }

  final Map<String, Map<String, String>> _cookies =
      <String, Map<String, String>>{};

  static String _randomUrlSafe(int bytes) {
    final Random random = Random.secure();
    return base64Url
        .encode(List<int>.generate(bytes, (_) => random.nextInt(256)))
        .replaceAll('=', '');
  }

  bool _isAuthUri(Uri uri) {
    final Uri expected = Uri.parse(settings['EU']['auth_base_url']);
    return uri.scheme == 'https' &&
        uri.host == expected.host &&
        uri.port == expected.port;
  }

  static bool _isRedirect(http.Response response) =>
      response.statusCode >= 300 &&
      response.statusCode < 400 &&
      response.headers['location'] != null;

  static Map _decodeJsonMap(http.Response response) {
    try {
      final dynamic decoded = json.decode(response.body);
      if (decoded is Map) {
        return decoded;
      }
    } catch (_) {}
    return <String, dynamic>{};
  }

  /// Sends a request without following redirects, keeping cookies per host.
  Future<http.Response> _authSend(http.Client client, String method, Uri uri,
      {Map<String, String>? headers, Map<String, String>? form}) async {
    final http.Request request = http.Request(method, uri)
      ..followRedirects = false;
    request.headers['User-Agent'] =
        'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Mobile Safari/537.36';
    final Map<String, String>? jar = _cookies[uri.host];
    if (jar != null && jar.isNotEmpty) {
      request.headers['Cookie'] =
          jar.entries.map((e) => '${e.key}=${e.value}').join('; ');
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }
    if (form != null) {
      request.bodyFields = form;
    }
    _print('Auth request: $method ${uri.origin}${uri.path}');
    final http.StreamedResponse streamed = await client.send(request);
    final http.Response response = await http.Response.fromStream(streamed);
    final String? setCookie = response.headers['set-cookie'];
    if (setCookie != null) {
      final Map<String, String> hostJar =
          _cookies.putIfAbsent(uri.host, () => <String, String>{});
      for (final String cookie
          in setCookie.split(RegExp(r',(?=\s*[^;,=\s]+=)'))) {
        final String pair = cookie.split(';').first.trim();
        final int eq = pair.indexOf('=');
        if (eq > 0) {
          hostJar[pair.substring(0, eq)] = pair.substring(eq + 1);
        }
      }
    }
    return response;
  }

  static String _unescapeHtml(String value) => value
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&');

  static final RegExp _attributePattern =
      RegExp('([a-zA-Z_:][-a-zA-Z0-9_:.]*)\\s*=\\s*(?:"([^"]*)"|\'([^\']*)\')');

  static Map<String, String> _attributes(String tag) {
    final Map<String, String> attributes = <String, String>{};
    for (final RegExpMatch m in _attributePattern.allMatches(tag)) {
      attributes[m.group(1)!.toLowerCase()] =
          _unescapeHtml(m.group(2) ?? m.group(3) ?? '');
    }
    return attributes;
  }

  /// Returns the inputs (plus `__action__`) of the form holding the login
  /// fields (sessionDataKey and password), or null if there is none.
  static Map<String, String>? _findLoginForm(String html) {
    final RegExp formPattern = RegExp(r'<form\b([^>]*)>(.*?)</form>',
        caseSensitive: false, dotAll: true);
    final RegExp inputPattern =
        RegExp(r'<input\b([^>]*)>', caseSensitive: false);
    for (final RegExpMatch f in formPattern.allMatches(html)) {
      final Map<String, String> inputs = <String, String>{};
      for (final RegExpMatch i in inputPattern.allMatches(f.group(2)!)) {
        final Map<String, String> a = _attributes(i.group(1)!);
        if (a['name'] != null) {
          inputs[a['name']!] = a['value'] ?? '';
        }
      }
      if (inputs.containsKey('sessionDataKey') &&
          inputs.containsKey('password')) {
        inputs['__action__'] = _attributes(f.group(1)!)['action'] ?? '';
        return inputs;
      }
    }
    return null;
  }

  _print(message) {
    if (debug) {
      print('\$ $message');
      debugLog.add('\$ $message');
    }
  }
}
