function compare_ori_deciph(_open_text,_decipher)
{
	var _diff_ciph_deciph = variable_clone(_simple_f_vec16);
	for(var _i = 0; _i < 16; _i++)
		{
			_diff_ciph_deciph[$ "_"+string(_i)] = _open_text[$ "_"+string(_i)] - _decipher[$ "_"+string(_i)];
		}
	return(_diff_ciph_deciph);
}