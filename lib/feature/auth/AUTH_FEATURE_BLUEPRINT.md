# Authentication Feature Blueprint - Mshwar Customer App

This document provides a comprehensive overview of the Authentication feature in the Mshwar Customer App. It details the API interactions, data models, UI flow, and security implementation for future replication or maintenance.

---

## 1. Project Context

- **Base URL:** `https://mshwar-app.com/api/v1/`
- **Region:** Kuwait (Default Country Code: `965`).
- **API Key:** `base64:Npu3FfBZFo1sxlY/LBzHY/VwL59xbfNoCJUZzCkYtKY=` (Mandatory in all headers as `apikey`).
- **User Category:** `customer`.

---

## 2. Authentication Flow (The Cycle)

### A. Email & Password Login

1. **User Input:** Email and Password (`mdp`).
2. **API Endpoint:** `POST /user-login`
3. **Payload:**
   ```json
   {
     "email": "user@example.com",
     "mdp": "password123",
     "user_cat": "customer"
   }
   ```
4. **Success Logic:** Checks if `response.statusCode == 200` and `success == "Success"`.

### B. Mobile Number Login (OTP Flow)

1. **Step 1: Send OTP**
   - **Endpoint:** `POST /send-otp`
   - **Payload:** `{"mobile": "965XXXXXXXX"}`
2. **Step 2: Verify OTP**
   - **Endpoint:** `POST /verify-otp`
   - **Payload:** `{"mobile": "965XXXXXXXX", "otp": "123456"}`
3. **Internal Check:** If verified, the app checks if the user exists via `/existing-user`.
   - If **Exists:** Fetches profile and logs in.
   - If **New:** Navigates to **Registration**.

### C. Social Login (Google/Apple)

1. **Provider Auth:** Uses Firebase/Native SDK to get user ID and email.
2. **Existing Check:** `POST /existing-user`
   - Payload: `{"email": "...", "login_type": "google/apple", "user_cat": "customer"}`
3. **Action:**
   - If **Exists:** Fetch profile via `POST /profilebyphone`.
   - If **New:** Navigate to **Registration** with social details pre-filled.

---

## 3. Registration (Sign Up)

- **Endpoint:** `POST /user`
- **Payload Keys:**
  ```json
  {
    "firstname": "John", // API expects 'firstname'
    "lastname": "Doe", // API expects 'lastname'
    "phone": "96512345678",
    "email": "john@example.com",
    "password": "...", // Literal key 'password'
    "login_type": "phoneNumber/google/apple",
    "tonotify": "yes",
    "account_type": "customer"
  }
  ```

---

## 4. Data Model (UserModel)

The app uses a consistent JSON structure for the user object. Note the French keys in the response DTO.

### API Response Structure

```json
{
  "success": "Success",
  "data": {
    "id": "123",
    "nom": "Doe", // Last Name (from API response)
    "prenom": "John", // First Name (from API response)
    "email": "user@example.com",
    "phone": "965...",
    "login_type": "...",
    "photo_path": "...",
    "accesstoken": "JWT_TOKEN_HERE",
    "admin_commission": "10",
    "user_cat": "customer"
  },
  "message": "...",
  "error": null
}
```

### Response Mapping (UserModel.dart)

- `id` -> `json["id"]`
- `nom` -> `json["nom"]` (Last Name)
- `prenom` -> `json["prenom"]` (First Name)
- `accesstoken` -> `json["accesstoken"]`
- `admin_commission` -> `json["admin_commission"]`

---

## 5. Session & Persistence

After a successful login or registration, the following data **MUST** be stored locally:

1. **Access Token:** `Preferences.accesstoken`
2. **User ID:** `Preferences.userId` (Stored as `int`).
3. **Full User JSON:** `Preferences.user` (The whole `UserModel` stringified).
4. **Login State:** `Preferences.isLogin = true`.

**Header Update:** Immediately update the global memory header:

```dart
API.header['accesstoken'] = token;
```

---

## 6. Implementation Cycle (Step-by-Step for New Feature)

### 1. The Controller Side (`login_controller.dart`)

- **Show Loader:** Use `ShowToastDialog.showLoader`.
- **API Call:** Use `http.post` with `jsonEncode`.
- **Headers:** Use `API.authheader` (without token) or `API.header` (with token).
- **Handle Response:**
  - Parse `json.decode(response.body)`.
  - Check `success` key.
  - Store token and user data on success.
- **Navigation:** Use `Get.offAll(BottomNavBar())`.

### 2. The UI Side (`login_screen.dart`)

- **Layout:** Wrap in `AuthScreenLayout` for consistent background and branding.
- **Validation:** Check empty fields and email format before calling API.
- **Pre-loading:** Always call `HomeController.setInitData()` after login but BEFORE navigation to ensure the home page has data ready.

---

## 7. Post-Auth Navigation

Successful authentication always redirects to:

- **`BottomNavBar`**: The main navigation entry point of the app.
- **Arguments:** None required (fetch via `Preferences`).

---

## 8. Summary of API Endpoints used in Auth

| Action             | Method | URL Endpoint          |
| :----------------- | :----- | :-------------------- |
| Login              | POST   | `/user-login`         |
| Registration       | POST   | `/user`               |
| Send OTP           | POST   | `/send-otp`           |
| Verify OTP         | POST   | `/verify-otp`         |
| Check Existence    | POST   | `/existing-user`      |
| Get Profile        | POST   | `/profilebyphone`     |
| Reset Password OTP | POST   | `/reset-password-otp` |
| Reset Final        | POST   | `/resert-password`    |
