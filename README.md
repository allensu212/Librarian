# Librarian

### 1. Model Classes

- NetworkManager: a Singleton class that handles all networking related tasks.
- Book: represent book data with NSString poperties, including book title, author, publisher, and categories

### 2. View Classes

- BookTableViewCell: 

gluing data with UI in -(void)configureCellWithDict:(NSDictionary *)dict

- UIAlertView + Blocks:

3rd Party API for presenting UIAlertView without implementing delegate method in every controller

- SVDProgressHUD:

3rd Party API for presenting Hud view with better user experience

- NavigationBarLabel:

Customize title text on UINavigationBar

### 3. Controller Classes

- MasterViewController: 

(1) Serve as data source and delegate of UITableView

(2) Fetch Book data from server in viewDidLoad and viewWillAppear

(3) Delete one particular book with finger swipe on cell / all booksat once with UIButton

(4) Pass book data to BookDetailViewController in prepareForSegue method

- BookDetailViewController:

(1) Update UI with book information

(2) Update Checkout information with NetworkManager singleton object

(3) Enable Social Media Sharing by presenting UIActivityViewController

- AddBookViewController:

(1) Serve as delegate of UITextField for saving information into Book object, and verifying text content in delegate methods

(2) Use enum for identifying four text fields to increase code readibility

