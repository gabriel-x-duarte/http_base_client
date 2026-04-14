## 1.2.1
* REFACTOR: changed the default error message from Portuguese to English ("No internet connection") for better international support.
* REFACTOR: renamed internal JSON parsing methods to `_parseResponseBody` and `_parseResponseBodyAsync` for improved code clarity.
* REFACTOR: updated `ObjectConverter` methods to return `Uint8List` instead of `List<int>` where applicable, aligning with modern Dart/Flutter data handling standards.
* CHORE: minor code cleanup and internal variable naming improvements in `_processRequest`.

## 1.2.0
* FEAT: implemented a high-performance internet connection check using `Socket.connect` on port 53 (Google/Cloudflare IPs), replacing the old lookup method.
* REFACTOR: centralized request handling logic into a generic `_processRequest` method to ensure DRY (Don't Repeat Yourself) principles.
* REFACTOR: improved resource management by explicitly injecting and closing `http.Client` instances for every request, preventing potential memory leaks.
* PERF: optimized network failure detection with a 2-second socket timeout, providing faster feedback in offline scenarios.
* PLATFORM: added a web compatibility guard (`kIsWeb`). Note: active socket connection check is bypassed on Web platforms due to browser security restrictions.
* Dependency update: updated `http` package to the latest version (1.6.0).

## 1.1.0
* Update: breaking change! The properties of the class [HttpBaseClientResponse] now match the properties of [http.Response] class
* Dependency update

## 1.0.9
* Update: the field data now returns the parsed json synchronously

## 1.0.8
* FEAT: update dependency constraints to sdk: '>=2.19.1 <4.0.0' flutter: '>=3.7.0'
* FEAT: update libraries to be compatible with Flutter 3.10.0
* Dependency update

## 1.0.7
The InternetAddress.lookup now works on Web

## 1.0.6

Including a getter "data" to return the parsed JSON

## 1.0.5

Including a few Object Converter/Parser methods