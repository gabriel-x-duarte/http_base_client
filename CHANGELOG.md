## 1.4.0
* FEAT: added `PersistentHttpBaseClient` for reusing the same underlying HTTP client across multiple requests.
* FEAT: added persistent client lifecycle management with `isClosed` and `close()`.
* DOCS: improved README with HTTP client type explanations.
* DOCS: updated usage examples to demonstrate persistent client usage and lifecycle management.
* DOCS: added documentation for auto-disposing and persistent client behaviors.
* REFACTOR: improved internal request processing organization and shared response handling.
* CHORE: minor cleanup and documentation consistency improvements.

## 1.3.2
* DOCS: improved README feature list organization and overall clarity.
* DOCS: added missing public API documentation comments required by pub.dev analysis.
* DOCS: improved inline API documentation consistency and readability.
* CHORE: minor documentation and formatting improvements.

## 1.3.1
* REFACTOR: improved inline documentation formatting and overall readability.
* REFACTOR: added comprehensive documentation comments to `DataCodec`.
* REFACTOR: explicitly typed `_toMap()` map literal with `<String, dynamic>`.
* CHORE: minor internal cleanup and code style improvements.

## 1.3.0
* BREAKING: renamed `ObjectConverter` to `DataCodec` for improved semantic clarity and API consistency.
* REFACTOR: standardized internal parameter naming from `source` to `data` across all codec utility methods.
* REFACTOR: improved public API naming and semantics for encoding and decoding helpers.
* REFACTOR: improved inline documentation comments and overall code readability.
* CHORE: minor internal cleanup and codebase organization improvements.

## 1.2.3
* FEAT: added proper Web compatibility support using conditional exports for platform-specific internet connectivity checks.
* REFACTOR: removed the direct `dart:io` dependency from the main library entrypoint.
* REFACTOR: extracted internet connectivity logic into dedicated platform-specific implementations (`IO` and `Web`).
* REFACTOR: removed the Flutter SDK dependency, making the package a pure Dart package.
* REFACTOR: replaced Flutter-specific imports with Dart core library imports where applicable.
* REFACTOR: improved package portability and platform compatibility.
* REFACTOR: updated the example application to a pure Dart console example.
* CHORE: general internal cleanup and architecture improvements.

## 1.2.2
* FEAT: introduced the `HttpBaseClient` interface contract, enabling easy mocking and dependency abstraction in tests.
* REFACTOR: converted the HTTP client implementation from static-only methods to an instance-based architecture.
* REFACTOR: added a private internal implementation (`_HttpBaseClient`) while keeping a clean public factory constructor API.
* REFACTOR: improved overall package encapsulation by hiding implementation details from consumers.
* REFACTOR: standardized and improved inline documentation comments across the package.
* CHORE: internal code cleanup and semantic naming improvements.

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