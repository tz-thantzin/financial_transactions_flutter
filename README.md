# Transaction Flow with Risk Interceptor

This is a secure Flutter app designed to handle payment
transactions safely, even when the internet connection is bad or
security checks (OTP) are required. It ensures you never get charged
twice for the same payment.

------------------------------------------------------------------------
## 🚀 Key Features
### 1. 🛡 Preventing Double Charges (Idempotency)

To make sure money isn't taken twice, we create a unique **Receipt ID
(UUID)** before sending any data to the internet.

**Step 1:** Save this ID and the payment details securely on the device
using **FlutterSecureStorage**.\
**Step 2:** Send the payment request to the server with this ID.

**Recovery:** If the app crashes or the internet disconnects during Step
2, the app remembers the pending transaction. When reopened, it retries
safely using the same Receipt ID, and the server ensures the transaction
is not processed twice.

------------------------------------------------------------------------

### 2. Security Checks (OTP)

Some transactions require extra verification using **One-Time Password
(OTP)** via a **Risk Interceptor**.

**Flow:** - **Pause:** If the server responds with `403 (OTP Required)`,
the transaction is paused. - **Show Screen:** The app navigates to the
OTP screen. - **Resume:** After correct OTP entry, the app resumes the
exact same transaction. - **Smart Check:** The verified state is
remembered to avoid repeated OTP prompts for the same transaction.

------------------------------------------------------------------------

### 3. Handling Bad Internet

The app is built to gracefully handle connectivity issues:

- **Connection Lost:** Detects network loss immediately.
- **Alert:** Displays a "Connection Lost" popup.
- **Safe Retry:** Retrying reuses the same Receipt ID to prevent
  double spending.
- **Timeout Handling:** Long server delays mark transactions as
  `pending` for later reconciliation.

------------------------------------------------------------------------

### 4. Money Math

All monetary values are stored as **int (cents)** instead of `double` to
ensure precision and avoid floating-point rounding errors, following
financial best practices.

------------------------------------------------------------------------

## Code Structure

Clean Architecture with **MVVM**:

- **Presentation (UI):** Screens and user interactions (Riverpod).
- **Domain (Business Rules):** Core transaction logic.
- **Data (Infrastructure):** API communication and local storage.

------------------------------------------------------------------------

## 🧪 Fake Server Behavior (Simulation)

Since no real banking API is used, a **Mock API** simulates real-world
scenarios:

- **Success:** Completes in exactly **5 seconds**  (giving enough delay to allow you to manually disconnect the network for testing).
- **Timeout:** Delays more than **10 seconds**.
- **Risk (OTP):** Randomly requests OTP verification.
- **Network Check:** Verifies connectivity before and after the delay.

**How to Test:** 1. Click **Pay Now**. 2. Wait 2--3 seconds. 3. Turn off
WiFi / Internet. 4. The app detects the issue and offers a **Retry**
option without duplicating the transaction.

------------------------------------------------------------------------
## How to Test:

You can use the pre-built APK located at assets/apk/app-release.apk to test these scenarios.

1. Click Pay Now.
2. Wait 2–3 seconds.
3. Turn off WiFi / Internet. 
4. The app detects the issue and offers a Retry option without duplicating the transaction.

------------------------------------------------------------------------

## 🛠 Tools Used

- **flutter_riverpod** -- State management
- **dio** -- HTTP networking
- **flutter_secure_storage** -- Secure local storage
- **go_router** -- Navigation
- **connectivity_plus** -- Network detection
- **freezed** -- Immutable models and safer state handling

------------------------------------------------------------------------

# 📦 FVM Setup & Usage (Recommended)

This project uses FVM (Flutter Version Management) to ensure everyone uses the exact same Flutter version (3.38.5) 
and avoids breaking changes.

## 🔧 Install FVM

### macOS / Linux

``` bash
brew tap leoafarias/fvm
brew install fvm
```

### Windows (using Chocolatey)

``` bash
choco install fvm
```

Or via Dart:

``` bash
dart pub global activate fvm
```

Ensure Dart global binaries are in your PATH.

------------------------------------------------------------------------
## 📌 Configure Flutter Version

The project includes an .fvmrc file that specifies version 3.38.5. To install this version locally for this project, run:

``` bash
fvm install
```

This will download Flutter 3.38.5 into the .fvm/ folder within your project.

------------------------------------------------------------------------
## 🏃‍♂️ How to Run

### 1️⃣ Clone the Repository

``` bash
git clone https://github.com/tz-thantzin/financial_transactions_flutter
cd financial_transactions_flutter
```

### 2️⃣ Install Dependencies

``` bash
fvm flutter pub get
```

### 3️⃣ Generate Code

``` bash
fvm dart run build_runner build --delete-conflicting-outputs
```

### 4️⃣ Run the App

``` bash
fvm flutter run
```
------------------------------------------------------------------------
## 📄 License

This project is for educational and demonstration purposes only.