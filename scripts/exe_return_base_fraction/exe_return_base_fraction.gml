function exe_return_base_fraction(_key_max,_key,_rounds)
{
	var _left_side = _key;//To jest bardzo wane w kontekście phy!!! patrz notatka!
	var _right_side = sqrt(_key);
	for(var i = 0; i < _rounds; i+=2 )
		{
			_left_side += power(_key,1./prime_list[i]);
			_right_side += power(_key,1./prime_list[i+1]);
		}
	var base_fraction = _left_side/_right_side;
	return(base_fraction);
}