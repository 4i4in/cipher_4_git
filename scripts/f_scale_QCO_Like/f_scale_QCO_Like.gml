function f_scale_QCO_Like(_s_vec_16,_dir)
{
	for(var _pow = 2; _pow < 16; _pow *= 2)
		{
			for(var _i = _pow; _i < _pow*2; _i++)
				{
					switch(_dir)
						{
							case "fwd":
							_s_vec_16[$ "_"+string(_i)] = power(_s_vec_16[$ "_"+string(_i)],_pow);
								break;
							case "rev":
							_s_vec_16[$ "_"+string(_i)] = power(_s_vec_16[$ "_"+string(_i)],1./_pow);
								break;
						}
				}
		}
	return(_s_vec_16);
}