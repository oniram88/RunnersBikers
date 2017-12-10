json.user_id current_user.id
json.roles current_user.roles.collect(&:name)