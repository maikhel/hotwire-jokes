# README

A simple application to experiment with Turbo. Mainly used for learning/inspiration purposes.

## Tags

Use tags to jump around different stages of the app development:

|Stage |Tag name | Link | Local command |
| :---: | :---: | :--: | :---: |
|Scaffold of app | base-app | [link](https://github.com/maikhel/hotwire-jokes/tree/base-app) | `git checkout base-app`
|Broadcast jokes from model | broadcast-with-pagination |[link](https://github.com/maikhel/hotwire-jokes/tree/broadcast-with-pagination) | `git checkout broadcast-with-pagination`
|Broadcast jokes from job | broadcast-from-job | [link](https://github.com/maikhel/hotwire-jokes/tree/broadcast-from-job) | `git checkout broadcast-from-job`

## Setup

This application uses:
- ruby 3.1.2
- sqlite 3
- sidekiq 7.2.1

Have them installed, clone repo and run:

```
$ bundle
$ rails db:setup
$ bin/dev
```

## Testing

Run `$ bundle exec rails test` for tests.
