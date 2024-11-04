# MyWallet

The application we'll discuss is designed to be a powerful yet user-friendly mobile tool for tracking user transactions. This app allows users to record and view their income and expenses, categorize transactions, and review historical data to better understand spending habits. Using Firebase as the backend platform allows us to manage user data securely and efficiently while leveraging features like real-time data sync, authentication, and cloud storage.

## Key Features of the Application
Here are some of the core features our app will offer:

  * User Authentication: Secure login and sign-up options using Firebase Authentication, with support for email-based authentication.
  * Transaction Entry: Users can add new transactions, specifying details like amount, category and date.
  * Real-Time Sync: Firebase’s real-time database keeps transaction data up to date across all of the user’s devices.
  * Categorization and Filtering: Users can filter transactions by type (income/expense) and category (e.g., Food, Rent, Transportation), allowing them to get insights into specific spending areas.
  * Data Storage and Security: All data is stored securely on Firebase Cloud Firestore, providing both offline capabilities and robust data storage.
  * Data Analytics and Insights: Users can view basic analytics (e.g., monthly spending, income versus expenses) to gain insights into their financial habits.

## Basic Workflow of the Application
Here’s a high-level view of the workflow for this app:

  * User Registration/Login: When users first open the app, they’ll be prompted to register or log in using Firebase Authentication.
  * Add Transaction: After authentication, users can add transaction details such as amount, category, date, and description.
  * Data Storage: Transaction data is saved to Firebase Cloud Firestore, making it available on all synced devices in real time.
  * View and Manage Transactions: Users can browse their past transactions, filter by category, and view monthly or weekly spending summaries.
  * Insights and Analytics: The app provides insights, allowing users to track spending habits, identify major spending categories, and better understand their financial situation.


## Key Technologies and Tools
To develop this application, we’ll use the following technologies:

  * Frontend Framework: Flutter.
  * Backend as a Service (BaaS): Firebase, which provides database, authentication, analytics, and storage services.
  * Cloud Firestore: Firebase’s NoSQL database to store transaction records.
  * Firebase Authentication: For managing user registration and login.


## Application Screenshots
