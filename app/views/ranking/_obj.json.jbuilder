json.(obj, :id, :email, :rank, :total_points, :total_distance, :total_positive_gain, :max_lose_points)
json.machable @current_user.machable(obj)