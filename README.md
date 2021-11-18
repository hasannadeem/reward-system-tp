# README

Reward calculation project reads the txt file for commands and parses the file to extract relevant data and provide the points/rewards each user gets.


Dependencies:
* Ruby version `3.0.2`
* Rails version `7.0.0.alpha2`

<!-- * Deployment instructions -->

# Configuration

Clone the repo:

`git clone https://github.com/hasannadeem/reward-system-tp.git`

Change the directory

- `cd reward-system-tp`

Install dependencies
- `bundle install`

Run rails server
- `rails s`

Hit `http://localhost:3000/` on the browser.

For sample input:

Choose the input file given in the project's root `input.txt` and click the `Generate Reward` button to see the output.

# How to run the test suite

Command to run all test cases using command

`rspec` or `bundle exec rspec`

Command to run specific test cases in reward-calculation/app/spec folder these are three commands to run individual test cases.

`rspec ./spec/requests/rewards_spec.rb`

`rspec ./spec/services/reward_service_spec.rb`

`rspec ./spec/services/lib/user_spec.rb`

# Brief Description

## Why do we create rails app without a database?
  We created rails app without database because we get a .txt file as input and process that file and generate output based on that file so we didn't need to persist anything for later use. That's why we create the rails app without a database for this project.

## These edge cases are handled
- If use `Generate Reward` without input file then output will be `No data available`
- If input row length after parsing is not `4` or `5` then we will ignore that input line because the given format length after parsing is `4` or `5`
- If the `4rth` word is not `Recommend or Accept` we will not process that line also due to edge case and backlog wrong input
- If Multiple users invite a single user and the user accepts the invitation according to requirement points will be calculated with the first user invitation and other users will not get any points.
- During processing if the system receives the wrong input line then it will backlog the message
- If a user doesn't exist then we will create that user and then proceed
- To recommend a user if the user doesn't exist, then first we create a user then recommend. If the user exists then we simply recommend the user.
- If `A Recommend B` and `A` doesn't exist then we will create user `A` first, then we will create B so that invitation sends to `B`.
- If the first command in the file is `A Accept` we will create `A` and no points will be calculated because we have no information who Recommend `A`.
- To recommend someone a user must exist if that user doesn't exist then first we will create that user and then the user recommend someone.
- If `A Recommend B` and `B` doesn't accept. Then `B` can't recommend someone.
- A user can't recommend itself.
