# Transparent assets

Gem that allows you to store your project's static in any remote storage. To start using it, do:

# install gem
# run `rails generate transparent_assets:install`
# configure gem in config/transparent_assets.yml
# mark fields(in models) which contains some assets. An example of marking you may see in https://github.com/l0ckdock/transparent_assets_sample_app/blob/master/app/models/article.rb:3. Example app doesn't work for now, so you can just see an idea.

The idea of solution: urls to assets does not store in DB. In DB store uids of assets. When asset is required(that is, when getter of field with url is called), uid replaced with urls on the fly.

Implementation of idea can be seen in lib/transparent_assets.rb:94.

Now it's just a prototype of gem, but I think that idea is interesting.
