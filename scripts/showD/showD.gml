function show_D(_showme,_name)
{
	if is_real(_showme)
		{
			show_debug_message(_name + " : " + string_format(_showme,1,50));
		}
	if is_struct(_showme)
		{
			var _sgn = struct_get_names(_showme);
			for(var i = 0; i < array_length(_sgn); i++)
				{
					var _sn = string(_sgn[i]);
					show_debug_message( _name + "." + _sn + " : " + string_format(_showme[$ _sn],1,50));
				}
		}
	if is_string(_showme)
		{
			show_debug_message(_name + " : " + string(_showme));
		}
}