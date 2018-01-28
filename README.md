# Voting

[![Build Status](https://travis-ci.org/wbotelhos/voting.svg)](https://travis-ci.org/wbotelhos/voting)
[![Gem Version](https://badge.fury.io/rb/voting.svg)](https://badge.fury.io/rb/voting)
[![Maintainability](https://api.codeclimate.com/v1/badges/dcdf51e3093148c5ac6a/maintainability)](https://codeclimate.com/github/wbotelhos/voting/maintainability)
[![Support](https://img.shields.io/badge/donate-%3C3-brightgreen.svg)](https://liberapay.com/wbotelhos)

A Binomial proportion confidence interval voting system with scope and cache enabled.

## Description

Voting uses **Binomial proportion confidence interval** to calculate the voting. Inspired on [Evan Miller Article](https://www.evanmiller.org/how-not-to-sort-by-average-rating.html) and used by [Reddit](https://redditblog.com/2009/10/15/reddits-new-comment-sorting-system), [Yelp](https://www.yelpblog.com/2011/02/the-most-romantic-city-on-yelp-is), [Digg](web.archive.org/web/20110415020820/http://about.digg.com/blog/algorithm-experiments-better-comments) and probably other, Voting gives you cache and option to work with scopes over a **binary** voting system.

If you are looking for **5 stars** voting system, check [Rating](https://github.com/wbotelhos/rating) :star2:

## Install

Add the following code on your `Gemfile` and run `bundle install`:

```ruby
gem 'voting'
```

Run the following task to create a Voting migration:

```bash
rails g voting:install
```

Then execute the migrations to create the tables `voting_votes` and `voting_votings`:

```bash
rake db:migrate
```

## Usage

Just add the callback `voting` to your model:

```ruby
class Author < ApplicationRecord
  voting
end
```

Now this model can vote or receive votes.

### vote

You can vote on some resource:

```ruby
author_1 = Author.first
author_2 = Author.last
resource = Comment.last

author_1.vote(resource, 1)  # +1 vote
author_2.vote(resource, -1) # -1 vote
```

### voting

A voted resource exposes a cached data about it state:

```ruby
resource = Comment.last

resource.voting
```

It will return a `Voting::Voting` object that keeps:

`author`: the author of this vote;

`estimate`: the Binomial proportion confidence interval value;

`negative`: the sum of negative votes for this resource;

`positive`: the sum of positive votes for this resource;

`resource`: the self object that received this vote;

`scopeable`: the object used as scope;

### vote_for

You can retrieve the vote an author gave to a specific resource:

```ruby
author   = Author.last
resource = Comment.last

author.vote_for resource
```

It will return a `Voting::Vote` object that keeps:

`author`: the author of vote;

`resource`: the resource that received the vote;

`negative`: the -1 value when vote was negative;

`positive`: the 1 value when vote was positive;

`scopeable`: the object used as scope;

### voted?

Maybe you want just to know if some author already voted some resource and receive `true` or `false`:

```ruby
author   = Author.last
resource = Comment.last

author.voted? resource
```

### votes

You can retrieve all votes received by some resource:

```ruby
resource = Article.last

resource.votes
```

It will return a collection of `Voting::Vote` object.

### voted

In the same way you can retrieve all votes that some author made:

```ruby
author = Author.last

author.voted
```

It will return a collection of `Voting::Vote` object.

### order_by_voting

You can list resource ordered by voting data:

```ruby
Comment.order_by_voting
```

It will return a collection of resource ordered by `estimate desc` as default.
The order column and direction can be changed:

```ruby
Comment.order_by_voting :negative, :asc
```

It will return a collection of resource ordered by `Voting::Voting` table data.

### Records

Maybe you want to recover all records, so you can add the suffix `_records` on relations:

```ruby
author   = Author.last
resource = Comment.last

author.vote resource, 1

author.voting_records

author.voted_records

comment.voting_records
```

### As

If you have a model that will only be able to vote but not to receive a vote, configure it as `author`.
An author model still can be voted, but won't generate a Voting record with all values as zero to warm up the cache.

```ruby
voting as: :author
```

### Scoping

If you need to warm up a record with scope, you need to setup the `scoping` relation.

```ruby
class Resource < ApplicationRecord
  voting scoping: :categories
end
```

Now, when a resource is created, the cache will be generated for each related `category` as `scopeable`.

### Toggle

The toggle functions works out of box, so if you vote up twice or vote twice down, the vote will be canceled.
When you do that, the vote record is **not destroyed** instead, it receives zero on `negative` and `positive` column.

### Alias

You can to use alias to directly call `vote` with positive or negative data.

```ruby
author   = Author.last
resource = Comment.last

author.up   resource # +1
author.down resource # -1
```

#### Options

`down`: makes a negative vote;

`up`: makes a positive vote;

### References

- [Evan Miller](https://www.evanmiller.org/how-not-to-sort-by-average-rating.html)
- [Jonathan Landy](http://efavdb.com/ranking-revisited)
- [Wilson Score Interval](https://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval#Wilson_score_interval)
- [How to Count Thumb-Ups and Thumb-Downs](http://www.dcs.bbk.ac.uk/~dell/publications/dellzhang_ictir2011.pdf)

## Love it!

Via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=X8HEP2878NDEG&item_name=voting) or [Support](https://liberapay.com/wbotelhos). Thanks! (:
