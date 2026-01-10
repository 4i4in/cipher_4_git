function exe_spawn_random_message(_s_vec_16)
{
	randomize();
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] = irandom(num_32_max);
		}
	return(_s_vec_16);
}