function exe_return_vote_holder(_iter)
{
	var _holder = {};
	for(var i = 0; i < _iter; i++)
		{
			var _name = "try_" +string(i);
			struct_set(_holder,_name,0);
		}
	return(_holder);
}