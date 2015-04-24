# CampusExchange
Campus Exchange

The Campus Exchange system is an object oriented device that utilizes the interface builder / storyboard capabilities provided by Xcode. While there is code to provide logic for the application, much of the User Interface is designed in Xcode. In order to best observe the source for this project, it's recommended that the grader have access to a computer with Xcode.

Flow of logic:
The project initially starts by opening the LogInViewController. 
    *If the user is logged in, they will be taken straight into the tabBarController that the entire app is housed in.
    *If the user needs to sign up, they can tap a Sign Up button at the bottom of the LoginViewController to take them to the SignUpViewController to sign up for the application.

*Note, once the user is signed in, all View Controllers from this point on are housed in the TabBarController. However, the logic for this controller is native to interface builder, so the only logic that we have inside of the TabBarController allows users to perform swipe gestures to navigate between different tabs.

Once the user signs in or signs up, they are taken to the SearchListingsViewController. This is simply the first tab in the TabBarController that they can navigate between. The 3 tabs contained in this controller are:

1) SearchListingsViewController:
This houses the code that handles the searching for listings that users have uploaded to the application servers. 

Important Methods:
    a)searchBooks - This button action reads in the input from the text fields in the application view and uses them to build a query to send to the parse servers. The matching listings are then returned from the server,sorted in order of creation and then set to a searchResultsArray that's used to populate the table view once the search has completed.
    b)cellForRowAtIndexPath - This method populates the cells of the table with the search result titles and prices
    c)prepareForSegue - This method is called when the user taps on a listing in the table view. This prepares an object from the row that was selected and sets that object in the listingController before moving the user to the ListingViewController.

2) ListingsViewController:
    

3) MessagesViewController:


Other View Controllers that aren't their own tabs, but can be accessed from the 3 main tabs:

1) ConversationViewController
Important Methods:

2) EditListingViewController
Important Methods:

3) PostViewController
Important Methods:

4) ListingViewController
Important Methods:

5) SettingsViewController
Important Methods:

6) LoginViewController
Important Methods:

7) SignUpViewController
Important Methods: