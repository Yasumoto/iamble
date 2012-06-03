CLIENT_ID = '4eed71589ff0a822458e50db4b9ebb42'
CLIENT_SECRET = 'd13bc8daa661cd7ea6bb3917ba687d29'

CALLBACK_URI = 'https://ambleapp.appspot.com/oauth_callback'

LOGIN_URL = '/login'

DEV_CALLBACK_URI = 'http://localhost:8080/oauth_callback'
#CALLBACK_URI = 'http://localhost:8080/oauth_callback'

SINGLY_OAUTH_BASE_URL = 'https://api.singly.com/oauth/authorize'

SINGLY_OAUTH_URL_TEMPLATE = '%s?client_id=%s&redirect_uri=%s&service=' % (
    SINGLY_OAUTH_BASE_URL, CLIENT_ID, CALLBACK_URI)

SINGLY_API_ACCESS_TOKEN_URL = 'https://api.singly.com/oauth/access_token'

DEFAULT_POST_HEADERS = {'Content-Type': 'application/x-www-form-urlencoded'}

SINGLY_API_PROFILES = 'https://api.singly.com/v0/profiles'

SINGLY_API_MY_CHECKINS = 'https://api.singly.com/v0/types/checkins'

SINGLY_API_CHECKIN_FEED = 'https://api.singly.com/v0/types/checkins_feed'

GOOGLE_API_KEY = 'AIzaSyAITJKrjGM6TPINct8KLa7dty3x2xErNJw'
GOOGLE_PLACES_API = 'https://maps.googleapis.com/maps/api/place/search/json'
