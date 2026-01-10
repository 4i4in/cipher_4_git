function sedenion_multiply(_vec16_R,_vec16_Q)
{
	var _ret_R_2o8 = f_split_sed_to_2o(_vec16_R);
	var _Ro_a = _ret_R_2o8._a;	var _Ro_b = _ret_R_2o8._b;
	
	var _ret_Q_2o8 = f_split_sed_to_2o(_vec16_Q);
	var _Qo_c = _ret_Q_2o8._a;	var _Qo_d = _ret_Q_2o8._b;

	var conj_Qo_c = f_conj_okt(_Qo_c);
    var conj_Qo_d = f_conj_okt(_Qo_d);
	
	var term1 = f_okt_mul(_Ro_a, _Qo_c);
    var term2 = f_okt_mul(conj_Qo_d, _Ro_b);

    var result_real = f_okt_sub(term1, term2);
	
	var term3 = f_okt_mul(_Qo_d, _Ro_a);
    var term4 = f_okt_mul(_Ro_b, conj_Qo_c);
    var result_imag = f_okt_add(term3, term4);
	
	var result = variable_clone(_simple_f_vec16);
    for (var i = 0; i < 8; i++) 
		{
	        var key = "_" + string(i);
	        result[$ key] = result_real[$ key];
	        var key_imag = "_" + string(i + 8);
	        result[$ key_imag] = result_imag[$ key];
	    }
    
    return result;
}