function exe_decrypt_msg(_cipher,_key_max,_key)
{
	var _scale = _cipher.scale;
	var _s_vec_16 = _cipher.msg;
	
	var _phi = variable_clone(phi_input);
	_phi *= (_key/(2*_key_max));
	var _cos_phi = cos(_phi);
	var _sin_phi = sin(_phi);
	
	_s_vec_16 = single_euclid_rot_16(_s_vec_16,_cos_phi,_sin_phi,"decipher");	
		
	//retrive scale
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] /= _scale;
		}
	_s_vec_16 =  f_scale_QCO_Like(_s_vec_16,"rev");
	//retrive integers
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] = floor(_s_vec_16[$ "_"+string(_i)]*num_32_max);
		}
	return(_s_vec_16);
}