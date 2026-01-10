function exe_decrypt_msg_voter(_cipher,_key_max,_key,_gamma_iter)
{
	var _scale = _cipher.scale;
	var _s_vec_16 = _cipher.msg;
	
	var gamma_base = power(10, -truncate-1.);   // 1e-8 dla length=8
    var gamma_min = power(10, -14);   // mantysa limit
	
	var _phi = variable_clone(phi_input);
	_phi *= (_key/(2*_key_max));
	var _cos_phi = cos(_phi);
	var _sin_phi = sin(_phi);
	
	var _vote_holder = exe_return_vote_holder(_gamma_iter);
		
	for (var iter = 0; iter < _gamma_iter; iter++)
		{
			var temp_vec = variable_clone(_s_vec_16);   // kopia na iterację
			var gamma = gamma_base + iter * (gamma_min - gamma_base) / (_gamma_iter-1);
			for (var i = 0; i < 16; i++) 
				{
		            var structkey = "_" + string(i);
		            var val = temp_vec[$ structkey];
		            if (is_nan(val) || abs(val) < gamma_base) val = gamma * (random(2) - 1);   // szum ±gamma
		            temp_vec[$ structkey] = val + (random(2*gamma)-gamma);   // iterowany szum gamma
				}
				
			temp_vec = single_euclid_rot_16(temp_vec,_cos_phi,_sin_phi,"decipher");
			
			var _name = "try_" +string(iter);
			struct_set(_vote_holder,_name,temp_vec);
		}
//debug
	for (var j = 0; j < _gamma_iter; j++) 
		{
			var _voter_name = "try_" +string(j);
show_debug_message("_voter_name : " + _voter_name);
show_D(_vote_holder[$ _voter_name],"_voter_name");
		}
	//voting
	for(var _i = 0; _i < 16; _i++)
		{
			var structkey = "_" + string(i);
			var sum_val = 0.;
			var count_valid = 0;
			for (var j = 0; j < _gamma_iter; j++) 
				{
					var _voter_name = "try_" +string(j);
		            var val = _vote_holder[$ _voter_name][$ structkey];
		            if (!is_nan(val)) 
						{
			                sum_val += val;
			                count_valid++;
						 }
				}
			if (count_valid > 0) 
				{
					 _s_vec_16[$ structkey] = sum_val / count_valid;
		        } 
			else 
				{
		            _s_vec_16[$ structkey] = 0.;   // fallback jeśli wszystkie NaN
		        }
		}
		
		
		
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