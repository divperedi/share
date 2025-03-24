# Share - App for Sharing Lists, Posts, and Ideas

This is a Ruby on Rails application designed to manage users, posts, shared posts, and comments. It includes user authentication and health checks.

## Table of Contents
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Step 1: Install Ruby](#step-1-install-ruby)
  - [Step 2: Clone the Repository](#step-2-clone-the-repository)
  - [Step 3: Install Dependencies](#step-3-install-dependencies)
  - [Step 4: Set Up the Database](#step-4-set-up-the-database)
  - [Step 5: Run the Application](#step-5-run-the-application)
- [Routes and Endpoints](#routes-and-endpoints)
  - [Home Route](#home-route)
  - [User Authentication](#user-authentication)
  - [Post Routes](#post-routes)
  - [Comment Routes](#comment-routes)
  - [Health Check Route](#health-check-route)
  - [Root Route](#root-route)
- [Figma Design](#figma-design)
- [Project Planning](#project-planning)

## Installation

Follow these steps to set up the project on your local machine.

### Prerequisites
Ensure you have the following installed:
- Ruby (version 3.3.6)
- Rails (installed automatically with the `bundle install` command)
- Bundler (for managing gem dependencies; preinstalled by default with Ruby)
- SQLite3 (installed with the `bundle install` command)

### Step 1: Install Ruby

**[Resource for installing ruby on different OS](https://www.ruby-lang.org/en/documentation/installation/)**

We will use `chruby` to manage Ruby versions and `ruby-install` to install ruby 3.3.6.

Install `chruby` and `ruby-install`:
```bash
brew install chruby ruby-install
```

Install Ruby 3.3.6 :
```bash
ruby-install ruby 3.3.6
```

After installation, check that Ruby is correctly installed:
```bash
chruby 3.3.6
ruby -v
```

### Step 2: Clone the Repository
Clone the repository to your local machine:
```bash
git clone <repository_url>
cd <project_directory>
```

### Step 3: Install Dependencies
Install the required gems:
```bash
bundle install
```

### Step 4: Set Up the Database
Create and set up the database:
```bash
rails db:create
rails db:migrate
```

### Step 5: Run the Application
Start the Rails server:
```bash
rails server
```

You can now visit the application in your browser at [http://localhost:3000](http://localhost:3000).

## Routes and Endpoints

### Home Route
- `/home` - Display the home page with logo

### User Authentication
- `/signup` - Display the signup form/ create a new user
- `/login` - Display the login form/ log in as user
- `Navbar > Logout` - Log out the current user

### Post Routes
- `/posts` - Display all posts
- `Plus icon in the right bottom corner` - Create a new post
- `/posts/:id` - Show a specific post
- `/posts/:id > Edit this post` - Edit a post
- `/posts/:id > Destroy this post` - Delete a post

### Comment Routes
- `/posts/:post_id > Your comment` - Create a new comment on a post

### Health Check Route
- `/up` - Check if the application is running (returns a 200 status in console > Network > Status if live, 500 if there are issues)

### Root Route
- `/` - Display the posts index

## Figma Design
You can view the design for the app here: **[View Figma Design](https://www.figma.com/design/QBGPS4l1HFaM55oolUqg30/Untitled?node-id=0-1&t=2A3LpsPMLL7JfVYT-1)**

## Project Planning
For the project planning and task tracking, check out the **[Trello Board](https://trello.com/invite/b/67d80393738d706fae6d5e4c/ATTI313de7e4872fcd20eda76c50cf4cf72a0B60B061/share)**
