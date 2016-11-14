//===-- EyeVerify.h - EyeVerify class definition --------===//
//
// EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the EyeVerify class.
///
//===----------------------------------------------------------------------===//

#import <UIKit/UIKit.h>

/// @name Eye Status enum values
/// @{

typedef NS_ENUM(NSInteger, EVEyeStatus) {
    EVEyeStatusOkay,
    EVEyeStatusTooFar,
    EVEyeStatusNoEye,
};

/// @}

/// @name Authentication session delegate callbacks
/// @{

@protocol EVAuthSessionDelegate <NSObject>
@optional
- (void)enrollmentProgressUpdated:(float)completionRatio counter:(int)counterValue;
- (void)eyeStatusChanged:(EVEyeStatus)newEyeStatus;
- (void)enrollmentSessionStarted:(int)totalSteps;
- (void)enrollmentSessionCompleted:(BOOL)isFinished;
@end

/// @}

/// @name Completion Blocks
/// @{

typedef enum : NSInteger {
    EVEnrollmentResultNothing = -1,
    EVEnrollmentResultSuccess = 0,
    EVEnrollmentResultError = 1,
    EVEnrollmentResultBadQuality = 2,
    EVEnrollmentResultAborted = 3,
    EVEnrollmentResultNoop = 4,
    EVEnrollmentResultHTTPError = 5,
    EVEnrollmentResultBadMatch = 6,
    EVEnrollmentResultEyenessFailed = 9,
    EVEnrollmentResultZeroImages = 10,
    EVEnrollmentResultIncomplete = 11,
    EVEnrollmentResultNoEyes = 12,
    EVEnrollmentResultLowLight = 13
} EVEnrollmentResult;

typedef enum : NSInteger {
    EVAbortReasonNone = -1,
    EVAbortReasonSystemTimeout = 0,
    EVAbortReasonUserCancel = 1,
    EVAbortReasonAppBackground = 2,
    EVAbortReasonUnsupportedDevice = 3,
    EVAbortReasonLicenseInvalid = 4,
    EVAbortReasonLicenseExpired = 5,
    EVAbortReasonLicenseLimited = 6,
    EVAbortReasonInternetRequired = 7,
    EVAbortReasonLowLighting = 8,
} EVAbortReason;

typedef void(^EnrollmentDetailCompletion)(EVEnrollmentResult result, NSData *userKey, EVAbortReason abort_reason);

typedef enum : NSInteger {
    EVVerifyResultNothing = -1,
    EVVerifyResultMatch = 0,
    EVVerifyResultNotMatch = 1,
    EVVerifyResultBadQuality = 2,
    EVVerifyResultError = 3,
    EVVerifyResultLivenessFailed = 4,
    EVVerifyResultAborted = 5,
    EVVerifyResultNoop = 6,
    EVVerifyResultHTTPError = 7,
    EVVerifyResultNoServerAuthData = 8,
    EVVerifyResultMatchWithEnroll = 9,
    EVVerifyResultNoEnrollments = 10,
    EVVerifyResultKeyGenFailed = 11,
    EVVerifyResultCannotComputeFeature = 12,
    EVVerifyResultZeroImages = 13,
} EVVerifyResult;

typedef void(^VerificationDetailCompletion)(EVVerifyResult result, NSData *userKey, EVAbortReason abort_reason);

typedef void(^EnrollmentCompletion)(BOOL enrolled, NSData *userKey, NSError *error) DEPRECATED_MSG_ATTRIBUTE("Deprecated in v2.8.3.");
typedef void(^VerificationCompletion)(BOOL verified, NSData *userKey, NSError *error) DEPRECATED_MSG_ATTRIBUTE("Deprecated in v2.8.3.");

/// @}

/// @name Errors
/// @{

FOUNDATION_EXPORT NSString *const EVErrorDomain;

enum {
    EVSystemError = 1,
    EVUnsupportedDeviceError = 2,
    EVUserAbortedError = 3,
    EVInvalidLicenseError = 4
};

/// @}

/// EyeVerify class
@interface EyeVerify : NSObject

@property (nonatomic, readonly) BOOL isBusy;

/// SDK version
@property (nonatomic, readonly) NSString *version;

/// The current user name
@property (nonatomic, copy) NSString *userName;

/// @name Enrollment
/// @{

/**
 Use this method when user authentication utilizes the Local Key Storage
 
 @param userName Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 @param userKey User Key of enrolled user. This parameter used only with Eyeprint Trust Server and Local Key Storage.
 @param completion Completion block
 */
- (BOOL)enrollUser:(NSString *)userName userKey:(NSData *)userKey completion:(EnrollmentDetailCompletion)completion;

/// @}

/// @name Verification
/// @{

/**
 Use this method to implement user authentication with User Key which will be retrieved by EyeVerify SDK from the Local Key Storage
 
 @param userName Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 @param completion Completion block
 */
- (BOOL)verifyUser:(NSString *)userName completion:(VerificationDetailCompletion)completion;

/// @}


/**
 Cancel enrollment or verification session
 */
- (void)cancel;

/**
 Continue enrollment or verification session
 */
- (void)continueAuth;

/// @name Removing Users
/// @{

/**
 This method will remove the specified user and erase enrollment data

 @param user_name Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 */
- (void)removeUser:(NSString *)user_name;

/// Removes all users
- (void)removeAllUsers;

/// @}


/// @name Enrolled Users
/// @{

/**
 Check if a username has enrollment data

 @param user_name Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 @return Boolean indicating enrollment status
 */
- (BOOL)isUserEnrolled:(NSString *)user_name;

/**
 Get list of currently enrolled users

 @return NSArray containing enrolled usernames
 */
- (NSArray *)getEnrolledUsers;

/// @}

/**
 Set authentication session delegate
 
 @param delegate Authentication session delegate
 */
- (void)setEVAuthSessionDelegate:(id<EVAuthSessionDelegate>)delegate;

/**
 Set camera preview capture view
 
 @param captureView Authentication session delegate
 */
- (void)setCaptureView:(UIView *)captureView;

/**
 Compliance

 @param user_name Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 @param error An error object if (TODO: list error conditions)
 @return
 */
- (BOOL)checkCompliance:(NSString *)userName error:(NSError**) error;

@end


@interface EyeVerify (Deprecated)

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE("Deprecated in v2.8.3.");

/// @name Enrollment
/// @{

/**
 Use this method when user authentication utilizes the Local Key Storage
 
 @param user_name Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 @param userKey User Key of enrolled user. This parameter used only with Eyeprint Trust Server and Local Key Storage.
 @param block Completion block
 */
- (BOOL)enrollUser:(NSString *)user_name userKey:(NSData*)userKey localCompletionBlock:(EnrollmentCompletion)block DEPRECATED_MSG_ATTRIBUTE("Deprecated in v2.8.3.");

/// @}

/// @name Verification
/// @{

/**
 Use this method to implement user authentication with User Key which will be retrieved by EyeVerify SDK from the Local Key Storage
 
 @param user_name Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 @param block Completion block
 */
- (BOOL)verifyUser:(NSString *)user_name localCompletionBlock:(VerificationCompletion)block DEPRECATED_MSG_ATTRIBUTE("Deprecated in v2.8.3.");

/// @}

@end
