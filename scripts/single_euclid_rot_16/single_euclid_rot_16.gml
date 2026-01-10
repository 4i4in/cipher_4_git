function single_euclid_rot_16(_s_vec_16,_cos_phi,_sin_phi,_reason)
{
	if _reason == "cipher"		{ _sin_phi /= sqrt(15); };
	if _reason == "decipher"	{ _sin_phi = -_sin_phi / sqrt(15);};
	
    var _R = variable_clone(_simple_f_vec16);
	_R._0 = _cos_phi;
	
	// wszystkie imaginaria e1–e15 dostają tę samą wartość sin(φ)
	for(var _i = 1; _i < 16; _i++)
		{
			_R[$ "_"+string(_i)] = _sin_phi;
		}
	_s_vec_16 = sedenion_multiply(_R, _s_vec_16);		

	
	return(_s_vec_16)
}