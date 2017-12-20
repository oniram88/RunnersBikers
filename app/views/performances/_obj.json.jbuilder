json.set! :destroyable, policy(obj).destroy?
json.set! :editable, policy(obj).update?
json.(obj, *obj.attribute_names)