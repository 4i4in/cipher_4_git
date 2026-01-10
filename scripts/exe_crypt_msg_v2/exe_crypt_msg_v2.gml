function exe_crypt_msg_v2(_s_vec_16,_key_max,_key,_rounds)
{
	//invert under 1;
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] /=num_32_max;
		}
	_s_vec_16 =  f_scale_QCO_Like_v2(_s_vec_16,"fwd",_key);
	
	//scaling to |norm|^2=1
	var _scale = return_scale_of_simple_16(_s_vec_16);
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] *= _scale;
		}
	
	//var base_fraction =  (_key_max + power(_key,1/5) + power(_key,1/11) + power(_key,1/17))/(sqrt(_key_max) + sqrt(_key) + power(_key,1/3) + power(_key,1/7) + power(_key,1/13));
	var base_fraction = exe_return_base_fraction(_key_max,_key,_rounds);
	for (var _r = 0; _r < _rounds; _r++)
		{
			var fraction = variable_clone(base_fraction);
			fraction = exe_return_fraction(_key,_r,fraction,_rounds);
			
			var _phi = variable_clone(phi_input)*fraction;
			var _cos_phi = cos(_phi);
			var _sin_phi = sin(_phi);
			
			_s_vec_16 = single_euclid_rot_16(_s_vec_16,_cos_phi,_sin_phi,"cipher");
		}
	
	var _msg =
		{
			scale : _scale,
			msg : _s_vec_16 
		}
	return(_msg);
}