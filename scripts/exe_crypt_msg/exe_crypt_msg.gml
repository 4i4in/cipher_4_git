function exe_crypt_msg(_s_vec_16,_key_max,_key)
{
	//invert under 1;
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] /=num_32_max;
		}
	_s_vec_16 =  f_scale_QCO_Like(_s_vec_16,"fwd");
	
	//scaling to |norm|^2=1
	var _scale = return_scale_of_simple_16(_s_vec_16);
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] *= _scale;
		}
	var _phi = variable_clone(phi_input);
	_phi *= (_key/(2*_key_max));
	var _cos_phi = cos(_phi);
	var _sin_phi = sin(_phi);
	_s_vec_16 = single_euclid_rot_16(_s_vec_16,_cos_phi,_sin_phi,"cipher");
	
	var _msg =
		{
			scale : _scale,
			msg : _s_vec_16 
		}
	return(_msg);
}