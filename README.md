# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 3.3.0

* Rails 8.0.4

* PostgreSQL 12.22

* System dependencies

* Configuration
Follow these steps to set up the project locally:
1. **Clone the repository**
```bash
git clone https://github.com/mfurqan-01/cancercare-emr.git
cd cancercare-emr
```
2. Install required gems
```bash
bundle install
```
3. Setup the database
```bash
rails db:create         #For creating web application database
rails db:migrate        #For Migrating the changes into your actual databse table schemas
```
4. Run the server
Any command
```bash
bin/dev                  # Starts Rails + Esbuild + Tailwind + Turbo
rails s 
rails server
```
* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
