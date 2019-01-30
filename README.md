# LocalAuthentication


# Features
This feature for security considerations.
Works with Apple Touch ID having devices.
Predefined error handling when recognition fails.
Automatic authentication with device Requirements

# Requirements

iOS 9.0+

Xcode 9 with Swift 4

# Error Handling

There are various cases when biometric authentication can be failed.

- fallback
- Called when user clicks on provided fallback button.

- biometryNotEnrolled
- Called when no fingerprints or face is registered with the device.
You can show message to register a new face or fingerprint here.
Default message will be shown if not provided.
- canceledByUser
Called when authentication canceled by user.
- canceledBySystem
Called when authentication canceled by system when app goes into background or any other reason.
- passcodeNotSet
Called when device passcode is not set and trying to use biometry authentication.
We can ask user to set device passcode here by opening Settings Application.
- failed
Called when multiple failed attempts made by user.
You can show error message to user here.
Default message can be shown if not provided.
- biometryLockedout
Called when more than 5 failed attempts made using biometric authentication. This will locked your biometry system.
You'll restrict user when this error is occured.
Aleternatively you can ask user to enter device passcode to unlock biometry.
- biometryNotAvailable
Called when device does not support Face ID or Touch ID authentication.
