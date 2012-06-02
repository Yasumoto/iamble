CLIENT_ID = "4eed71589ff0a822458e50db4b9ebb42"
CLIENT_SECRET = "d13bc8daa661cd7ea6bb3917ba687d29"

#CALLBACK_URI = "https://www.iamble.com/oauth_callback"

CALLBACK_URI = "http://localhost:8080/oauth_callback"

SINGLY_OAUTH_BASE_URL = "https://api.singly.com/oauth/authorize"

SINGLY_OAUTH_URL_TEMPLATE = "%s?client_id=%s&redirect_uri=%s&service=" % (
    SINGLY_OAUTH_BASE_URL, CLIENT_ID, CALLBACK_URI)
