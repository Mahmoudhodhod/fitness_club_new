import 'package:googleapis_auth/auth_io.dart';

class AccessTokenFirebase {
  static String firebaseMessagingScope =
      'https://www.googleapis.com/auth/firebase.messaging';

  Future<String> getAccessToken() async {
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "fitness-clubeg",
        "private_key_id": "fc46afdfaba78449df06202e78a3f17f490e7a7f",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCvaKZAF2E4OPKc\nuFsDFi9sQDtG8z9cBh0SornqYiWqFz7uZ11x0wqVFDHXrL86uC4mg4M1ZW4/+ZED\n5CcKKUY251rbIXzTk+USCwUOzi7U8de0aVgSnSrqXGgE2lahWFn4pxKa9a2u7D4V\nX7pViVwADSHomGWNhfsIQ3w888Q+9pK1vaG/1YtTsg++UQL/Me0PaD4RkvXHZAnf\nmbBRjJU6TEd40nxve3CW5azinHfRHvttudhcyK1fRCubbojuqnvVyuJIWcdiIEVM\n6lgrJr8QwXvj3ijXm4oBg8Mdf5yzH7sCreyzvkblLn89w+dOTmgMXjq36WovqLiU\nIe1N78tPAgMBAAECggEAJqHjy8XacamJNZ8c3GcsdqkG5S95yujFym7wh4CqTvXj\ntForqIAUmpTiDWBMlcAu2eipIz99srVijPrY5lIE1t7Jke2kMm0mTH0E1ifvBJNn\nMKLq9N6MryU++6Ki5dIxrqQNYvetExOQ8OAuh9xC2PgLedDmvO6/RSin2jzOAheq\n/FvRiqneJ3Jn5ZWmXTRz5Xhc/vcoc1rhSH3KI8isGv6yInq4Ax5mEiR7J+cSaHgu\na+eNqovsybArDR2BA+uVK64uk47bAk+Df+3rKfECz9x+lUpXkfZ0xNd8CX0W09j9\nYCLkG7uo9tcA9eNq7+ggpZ8k+0YNqC5OyLR/7nUTYQKBgQDb0RZe5KMyMwTfu5AS\nTsVKMSrd1UsffTWg+76UHZK6hOivOw8RVJ5Xs7facfLqD8PpXsxfO639GPD76zlh\n6wylDQ7vneqn0tNLqKptrWX/y5fV57pzGabN3j++Jck2oy/Jw3hMthHv1cxLUGBP\n2PgPm9MNnrfxN3j+OK5GdlJ8lwKBgQDMSD5xmXpXZtRuVbryRS25pHOaokt3Lkbf\nu1P8pARbH1RANwIx2zhPQY9GiFFmmkFfhvbzpats4pjE0xEKL442SYs0gYuPxZlH\nQ4dED1yPuPR34BmxDeiyblHNZspK8feC+wcnDnSZ/Ix0C2Q3KhUsh6zK8MXDfdhF\n2ZEVAC0mCQKBgFfj9injCU2dEKnUePqY/FF570XbbrocekDv53eZi32AfvjxiEjJ\nqLYwaaayQQpNW2wIN3csiZjVTCWuG7eHH/suiXZNkfGgXlO2EM7hshLg+MjSar5y\n1zshTiNdQGLURNtLiOJDOlDHD3RdouTKQAUdrPmZKLsODxa22xfZX4npAoGBAKqe\nOFFHH9B6GTkiL2cD8oHX4ZoorSEYrKdW3XnoP58f1o1fpFyhvTEtD46Ycmxgr/Mq\nVX4AQ+JIi9Hwe43nVD7xQ+wRus/U+QV1WDe3INcFYmHw8WRYup6012vXy2O3HsPu\nB/ZN84NdVK3jicstQcwUcXR6jqKNrCIC6lMA97SJAoGBAIocaDlPeuVwgbXWDCpP\ncQIq82vaJx1C6JovIx+EEcwW6p84dbnlpmMwCcUp4wEvyG+mGOMcK4CrzQXRO/da\nlhedSN2cRxdFY3ExOlAh86gPHEOScOrWUNllUV6qscIcQcbb6xO2ZmkcU/llOqxR\n9lPBufn5r5HMI/JeW6sgBgod\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-2cvbz@fitness-clubeg.iam.gserviceaccount.com",
        "client_id": "105991230603684853913",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-2cvbz%40fitness-clubeg.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      [firebaseMessagingScope],
    );

    final accessToken = client.credentials.accessToken.data;

    return accessToken;
  }
}
