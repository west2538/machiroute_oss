module Entities
  module V1
    class PostEntity < RootEntity
      expose :body, :created_at
    end
  end
end