# We Got Tickets webstie scraper

This is a script written in Ruby that scrapes the We Got Tickets website for the lastest concerts.

The script is run using a Rake task and prints a list of events to the terminal.

## Usage

**Install the gems:**
```
$ bundle install
```
**Run tests:**
```
$ rspec
```
**Running the Rake task:**
Each page on the site lists 10 events and you can decide how many list pages you want to scrape by passing in an argument to the task:
```
$ rake scrape_for_tickets[3]
```
