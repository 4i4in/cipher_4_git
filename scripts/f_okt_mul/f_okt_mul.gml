function f_okt_mul(_vec8_R,_vec8_Q)
{
	var _ret_R_2h4 = f_split_okt_to_2h(_vec8_R);
	var _Ro_a = _ret_R_2h4._a;	var _Ro_b = _ret_R_2h4._b;
	
	var _retQ_2h4 = f_split_okt_to_2h(_vec8_Q);
	var _Qo_c = _retQ_2h4._a;	var _Qo_d = _retQ_2h4._b;
	
	var conj_Qc = f_quat_conj(_Qo_c);
    var conj_Qd = f_quat_conj(_Qo_d);	

	var term1 = f_quat_mul(_Ro_a, _Qo_c);
    var term2 = f_quat_mul(conj_Qd, _Ro_b); 
    var real_part = f_quat_sub(term1, term2);	
	
	var term3 = f_quat_mul(_Qo_d, _Ro_a);
    var term4 = f_quat_mul(_Ro_b, conj_Qc);
    var imag_part = f_quat_add(term3, term4);
	var result = variable_clone(_simple_f_vec8);
	  	
	for (var i = 0; i < 4; i++)
	    {
	       var key = "_" + string(i);
		   var value = real_part[$ key];		   
		   struct_set(result,key,value);
	       //result[$ key] = real_part[$ key];
	    }
	
	for (var i = 0; i < 4; i++)
	    {
	       var key = "_" + string(i + 4);
		   var subkey = "_" + string(i);
		   var value = imag_part[$ subkey];
		   struct_set(result,key,value);
	       //result[$ key] = imag_part[$ key];
	    }
		
    return result;	
}