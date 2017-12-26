json.user_id current_user.id
json.roles current_user.roles.collect(&:name)
json.username current_user.username
json.program_version RunnersBikers::VERSION