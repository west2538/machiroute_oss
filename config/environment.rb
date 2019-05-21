# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActsAsTaggableOn.remove_unused_tags = true