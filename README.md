# Todos API

Fully-fledged API for managing tasks in form of to-do list.
Fully tested with RSpec testing framework (as well as other libraries
such as FactoryBot or Faker)

#Installation

Download project and run

```shell
bundle install
rake db:migrate
rails s
```

#Features

Todos API provides endpoints to performing CRUD actions on todo items.
It also provides extended requests authorization using Json Web Token.

#Testing

To run RSpec tests just type

```ruby
rspec
```

in the main project folder.

---

Project based on Rails API tutorial by Austin Kabiru presented on
https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

## Add Request Throttler/Blocker

### Track incoming requests

Allow a maximum of 3 requests per second, per user
Allow a maximum of ** write requests per minute, per user
Allow a maximum of ** read requests per minute, per user

Start at 5:50

UserRequest

- belongs_to user
- action - integer / enum
- requested_on - DateTime
- ip_address - string -> could be potentially useful in the future (maybe another PBI/task)

=== if time get to below

ApiTier

For now, hard code the ApiTier to initial specs,
but add as model if time.

- name/label
- has_many ThrottleRules

ThrottleRule

- applies_to: int/enum (read / write / all)
- belongs_to ApiTier
- max_number_of_requests
- seconds_per_session (better name than session would be great)

ApiRequestThrottler - PORO which handles the inteaction
