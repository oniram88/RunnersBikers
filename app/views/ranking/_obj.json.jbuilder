json.(obj, :id, :username, :rank, :total_points, :total_distance, :total_positive_gain, :max_lose_points)
json.challanged obj.open_matches.length>0
json.machable @current_user.machable(obj)