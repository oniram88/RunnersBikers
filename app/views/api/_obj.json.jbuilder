json.set! :destroyable, policy(obj).destroy?
json.(obj, *obj.attribute_names)