# Sleep Tracker
This is sleep tracker application, where you can track when you begin to sleep and when you begin to wake up

## Requirements

- **Ruby**: Latest version. You can download and install it from [ruby-lang.org](https://www.ruby-lang.org/en/downloads/).
- **Rails**: Latest version. You can install it using the command `gem install rails`.

## Installation

1. Install Ruby and Rails:
  ```sh
  gem install rails
  ```

## Configuration

1. Install dependencies:
  ```sh
  bundle install
  ```

## Database Setup

1. Create and migrate the database:
  ```sh
  rails db:create
  rails db:migrate
  rails db:seed
  ```

## How to Run

1. Start the Rails server:
  ```sh
  rails server
  ```
  The application will be available at `http://localhost:3000`.

## How to Run the Test Suite

1. Run RSpec tests:
  ```sh
  bundle exec rspec
  ```
  or to run a specific test file:
  ```sh
  bundle exec rspec <file_location_spec>
  ```

## References

- **RSpec**: RSpec is a testing tool for Ruby, commonly used for testing Rails applications. It is designed to help you write and execute test cases in a readable and maintainable way. For more information, visit the [RSpec documentation](https://rspec.info/documentation/).
