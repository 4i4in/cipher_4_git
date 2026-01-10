function exe_decrypt_msg_v2(_cipher,_key_max,_key,_rounds)
{
	var _scale = _cipher.scale;
	var _s_vec_16 = _cipher.msg;
	
	//var base_fraction =    (_key_max + power(_key,1/5) + power(_key,1/11) + power(_key,1/17))/(sqrt(_key_max) + sqrt(_key) + power(_key,1/3) + power(_key,1/7) + power(_key,1/13));
	var base_fraction = exe_return_base_fraction(_key_max,_key,_rounds);
	var _fract_list = {};
	for (var _r = 0; _r < _rounds; _r++)
		{
			var fraction = variable_clone(base_fraction);
			fraction = exe_return_fraction(_key,_r,fraction,_rounds);
			
			var _sname = "_"+string(_r);
			struct_set(_fract_list,_sname,variable_clone(fraction));
		}
	for (var r = _rounds - 1; r >= 0; r--) 
		{
			var _sname = "_"+string(r);
	        var _phi = variable_clone(phi_input)*_fract_list[$ _sname];   // koniugacja: -phi
	        var _cos_phi = cos(_phi);      // cos(-phi) = cos(phi)
	        var _sin_phi = sin(_phi);      // sin(-phi) = -sin(phi)
			
			_s_vec_16 = single_euclid_rot_16(_s_vec_16,_cos_phi,_sin_phi,"decipher");
		}
	//retrive scale
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] /= _scale;
		}
	_s_vec_16 =  f_scale_QCO_Like_v2(_s_vec_16,"rev",_key);
	//retrive integers
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] = floor(_s_vec_16[$ "_"+string(_i)]*num_32_max);
		}
	return(_s_vec_16);
}