function f_split_okt_to_2h(_vec8)
{
	var _ret = 
		{
			_a : {},	
			_b : {}
		}
		
	for(var _i = 0; _i < 4; _i++)
		{
			var _new_name = "_"+string(_i);
			var _value = _vec8[$ "_"+string(_i)]
			struct_set(_ret._a,_new_name,_value);
		}
	for(var _i = 4; _i < 8; _i++)
		{
			var _new_name = "_"+string(_i-4);
			var _value = _vec8[$ "_"+string(_i)]
			struct_set(_ret._b,_new_name,_value);
		}
		
	return(_ret);
}