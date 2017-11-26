json.data @obj, partial: 'obj', as: :obj
json.success @operation_result
json.errors @obj.errors.as_json