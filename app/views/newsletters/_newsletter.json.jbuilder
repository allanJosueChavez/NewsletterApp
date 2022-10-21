json.extract! newsletter, :id, :topic, :name, :description, :created_at, :updated_at
json.url newsletter_url(newsletter, format: :json)
