json.extract! project_master, :id, :name, :description, :user_id, :created_at, :updated_at, :ptype
json.url project_master_url(project_master, format: :json)
