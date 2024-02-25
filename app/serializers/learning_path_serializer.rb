class LearningPathSerializer
  include JSONAPI::Serializer
  attributes :title, :status
end
