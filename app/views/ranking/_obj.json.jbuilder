json.(obj, :id, :username, :rank, :total_points, :total_distance, :total_positive_gain)
json.challanged obj.open_matches.length>0
json.machable @current_user.machable(obj)
json.max_lose_points obj.max_lose_points(@current_user)