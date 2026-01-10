function f_split_sed_to_2o(_vec16)
{
	var _ret = 
		{
			_a : {},	
			_b : {}
		}
		
	for(var _i = 0; _i < 8; _i++)
		{
			var _new_name = "_"+string(_i);
			var _value = _vec16[$ "_"+string(_i)]
			struct_set(_ret._a,_new_name,_value);
		}
	for(var _i = 8; _i < 16; _i++)
		{
			var _new_name = "_"+string(_i-8);
			var _value = _vec16[$ "_"+string(_i)]
			struct_set(_ret._b,_new_name,_value);
		}
		
	return(_ret);
}