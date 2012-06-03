# All constants should be represented in lower case.
# All constants should be represented in single form (not plural).

FOURSQUARE_FOOD_PARENT = 'food'

COFFEE_STRINGS = ['coffee', 'cafe', 'bistro', 'espresso', 'latte', 'tea'] 
QUICK_STRINGS = ['sandwich', 'burger', 'sub', 'bbq', 'barbecue', 'taco', 'breakfast'] 
SIT_DOWN_STRINGS = ['restaurant', 'diner']

EXCLUDE_STRINGS = ['pub', 'bar', 'tavern', 'cocktail', 'beer']

COFFEE_COST = 10
QUICK_COST = 15
SIT_DOWN_COST = 25

PREFERENCE_MATCH_WEIGHT = 1.3
CHECKIN_MATCH_WEIGHT = 1.2  # signal_value multiplied with or divided by this to determine ranking.
DISTANCE_MATCH_WEIGHT = 1.1

DISTANCE_MAPPING = {'walk': 1, 'bike': 2, 'drive': 3}
DISTANCE_RATIO = 1.5  # Multiplied with preferred distance to find radius.
