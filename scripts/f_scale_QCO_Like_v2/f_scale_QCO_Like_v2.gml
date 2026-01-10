function f_scale_QCO_Like_v2(_s_vec_16,_dir,_key)
{
	
	var _pool = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
	var seed = variable_clone(_key); 
	for(var _s=0;_s<16;_s++)
		{ 
			seed=(seed*0x5DEECE66D +11)% 281474976710656;
			random_set_seed(seed);
			array_shuffle_ext(_pool);
		};
	
	
	for(var _pow = 2; _pow < 16; _pow *= 2)
		{
			for(var _i = _pow; _i < _pow*2; _i++)
				{
					var _n = _pool[_i];
					switch(_dir)
						{
							case "fwd":
							_s_vec_16[$ "_"+string(_n)] = power(_s_vec_16[$ "_"+string(_n)],_pow);
								break;
							case "rev":
							_s_vec_16[$ "_"+string(_n)] = power(_s_vec_16[$ "_"+string(_n)],1./_pow);
								break;
						}
				}
		}
	return(_s_vec_16);
}