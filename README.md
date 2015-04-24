# CampusExchange
Campus Exchange

The Campus Exchange system is an object oriented device that utilizes the interface builder / storyboard capabilities provided by Xcode. In order to best observe the source for this project, it's recommended that the grader have access to a computer with Xcode. This project was written using Xcode v.6.3 following Swift 1.2 programming language principles. Once the project files are unarchived, to root CampusExchange folder contains the CampusExchange.xcodeproj that can be opened to view the project source code. While there is code to provide logic for the application within the various ViewControllers, much of the User Interface is designed and most of the navigation between ViewControllers in Xcode within the Main.storyboard file. This application can be launched on the iOS Simulator included with Xcode by pressing the Build and Run button in the top left corner of Xcode.

Flow of logic:
The project initially starts by opening the LogInViewController. 
    *If the user is logged in, they will be taken straight into the TabBarController that the entire app is housed in.
    *If the user needs to sign up, they can tap a Sign Up button at the bottom of the LoginViewController to take them to the SignUpViewController to sign up for the application.

*Note, once the user is signed in, all View Controllers from this point on are housed in the TabBarController. However, the logic for this controller is native to interface builder, so the only logic that we have inside of the TabBarController allows users to perform swipe gestures to navigate between different tabs.

Once the user signs in or signs up, they are taken to the SearchListingsViewController. This is simply the first tab in the TabBarController that they can navigate between. The 3 tabs contained in this controller are:

	1) SearchListingsViewController:
	This houses the code that handles the searching for listings that users have uploaded to the application servers. 

	Important Methods:
	    a)searchBooks - This button action reads in the input from the text fields in the application view and uses them to build a query to send to the parse servers. The matching listings are then returned from the server,sorted in order of creation and then set to a searchResultsArray that's used to populate the table view once the search has completed.
	    b)cellForRowAtIndexPath - This method populates the cells of the table with the search result titles and prices.
	    c)prepareForSegue - This method is called when the user taps on a listing in the table view. This prepares an object from the row that was selected and sets that object in the listingController before moving the user to the ListingViewController.

	2) ListingsViewController:

	Important Methods:
		a)viewDidAppear - This method queries and stores all of the conversations that the current user is a part of in the currentUserConversations array.
		b)cellForRowAtIndexPath - This method populates the cells of the table with listings (containing the titles and prices) that were originally created by the current user.
		c)prepareForSegue - This method is called when the user taps on a listing in the table view. This prepares a listingObject from the row that was selected and sets that object in the editController before moving the user to the EditListingViewController.

	3) MessagesViewController:

	Important Methods:
		a)viewDidAppear - This method queries and stores all of the listings created by the current user in the currentUserListings array.
		b)cellForRowAtIndexPath - This method populates the cells of the table with conversations (containing the listingTitle) that the current user is a part of.
		c)prepareForSegue - This method is called when the user taps on a conversation in the table view. This prepares a conversationObject from the row that was selected and sets that object in the conversationController before moving the user to the ConversationViewController.

Other View Controllers that aren't their own tabs, but can be accessed from the 3 main tabs:

1) ConversationViewController
Important Methods:
	a)viewDidAppear - This method contains the logic that either displays a conversation between the seller and the current user when one has already been started, or invokes the creation of a new conversation if one does not exist.
	b)cellForRowAtIndexPath - This method populates the cells of the table with messages (containing the message sender, message time, and the message itself) that make up the conversation.
	c)getMessages - This method queries and stores all of the messages pertaining to a conversation in the messagesArray array.
	d)createNewConversation - This method is called to create a new conversationObject when one has not yet been created between a buyer and a seller.
	e)sendPressed - This button action associates and stores the typed message to an existing conversation.

2) EditListingViewController
Important Methods:
	a)viewDidLoad - This method populates the fields with the current information from a listingObject that can be edited.
	b)saveListing - This button action updates and stores the updates of a listingObject with any modified information.
	c)deleteListing - This button action removes and deletes a listingObject from the database as well as the user's ListingsViewController. 

3) PostViewController
Important Methods:
	a)addListing - This button action creates and stores a listingObject with all of the information specified in the associated text fields.

4) ListingViewController
Important Methods:
	a)viewDidLoad - This method populates the fields with the current information from a listingObject that is for sale.
	a)prepareForSegue - This method is called when the user taps on a listing in the table view. This prepares an listingObject from the row that was selected and sets that object in the conversationController before moving the user to the ConversationViewController.

5) SettingsViewController
Important Methods:
	a)update - This button action allows a user to update their email address or password and verifies if these are new values. If they are, these updates are stored in the database. 
	b)logOut - This button action logs out the current user and moves the user to the SignUpViewController.

6) LoginViewController
Important Methods:
	a)viewDidAppear - This method checks if a user is still logged in from their previous session. If they are, they are moved to the SearchListingsViewController.
	b)forgotPassword - This button action displays a modal that will allow a user to enter their email address to have a password-rest link sent to them.
	c)logIn - This button action allows a user to enter their login username and password to sign in. If these credentials are wrong, an error message is shown.

7) SignUpViewController
Important Methods:
	a)signUp - This button action allows a new user to sign up for application by specifying a username, email address, and password. If any of these fields are invalid, an error message is shown.
