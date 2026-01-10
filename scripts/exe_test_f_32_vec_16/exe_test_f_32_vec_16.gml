function exe_test_f_32_vec_16(_s_vec_16)
{

	//var key = "_" + string(_i);
	//random num fill
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] = irandom(num_32_max);
		}
	var _original_random_copy = variable_clone(_s_vec_16);
	show_debug_message("starting_numbers : " + string(_s_vec_16));
	
	//invert under 1;
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] /=num_32_max;
		}
	//scaling QCOlike for cipher
	_s_vec_16 =  f_scale_QCO_Like(_s_vec_16,"fwd");
	
	
	//scaling to |norm|^2=1
	var _scale = return_scale_of_simple_16(_s_vec_16);
	show_debug_message("scale : " + string_format(_scale,1,50));
	for(var _i = 0; _i < 16; _i++)
		{
			_s_vec_16[$ "_"+string(_i)] *= _scale;
		}
	show_D(_s_vec_16,"scaled_numbers");
	
	var _key_length = 4; var _key_max = power(2,_key_length)-1;
show_debug_message("_key_max : " + string(_key_max));
	randomize();
	var _current_key = _key_max + irandom(_key_max);
show_debug_message("_current_key : " + string(_current_key));

	
	var _phi = 2.* pi;
	//cipher only:
	_phi *= (_current_key/(2*_key_max));
show_debug_message(" _phi : " + string_format(_phi,1,20));
//	_phi = power(_phi,-6);
//show_debug_message(" _phi : " + string_format(_phi,1,20));

	var _cos_phi = cos(_phi);
	var _sin_phi = sin(_phi);

show_debug_message("encrypt");	
	_s_vec_16 = single_euclid_rot_16(_s_vec_16,_cos_phi,_sin_phi,"cipher");
show_debug_message("decrypt");	
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
	
	show_debug_message("end_numbers : " + string(_s_vec_16));
	show_debug_message("ori_numbers : " + string(_original_random_copy));
	var _diff_ciph_deciph = variable_clone(_simple_f_vec16);
	for(var _i = 0; _i < 16; _i++)
		{
			_diff_ciph_deciph[$ "_"+string(_i)] = _original_random_copy[$ "_"+string(_i)] - _s_vec_16[$ "_"+string(_i)];
		}
	show_debug_message("_diff_ciph_deciph : " + string(_diff_ciph_deciph));
}