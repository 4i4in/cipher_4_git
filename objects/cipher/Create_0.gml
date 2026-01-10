randomize();
math_set_epsilon(	1. * power(10, -14)	);//on -15 GMS2 blow up float; 
EPSILON = math_get_epsilon();

empty_quadfloat = 
{
    h1 : 0.0,  // high-high
    h2 : 0.0,  // high-low
    l1 : 0.0,  // low-high
    l2 : 0.0   // low-low
};

num_32_max = 4294967295;
truncate = 10;
phi_input = 2.* pi;
trunc_eps = power(10, -truncate);
prime_list = [	3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,
				179,181,191,193,197,199,211,223,227,229,233,239,241,251,257,263,269,271,277,281,283,293,307,311,313,317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,
				419,421,431,433,439,443,449,457,461,463,467,479,487,491,499,503,509,521,523,541,547,557,563,569,571,577,587,593,599,601,607,613,617,619,631,641,643,647,653,659];				
				
_quad_f_vec16 = {
				_0 : variable_clone(empty_quadfloat),	_1 : variable_clone(empty_quadfloat),			//masa efektywna / E_rest, β = v/c (kinematyka)
				_2 : variable_clone(empty_quadfloat),	_3 : variable_clone(empty_quadfloat),			//chirality left, charge projection see notes
				_4 : variable_clone(empty_quadfloat),	_5 : variable_clone(empty_quadfloat), _6 : variable_clone(empty_quadfloat), _7 : variable_clone(empty_quadfloat),	//
				_8 : variable_clone(empty_quadfloat),	_9 : variable_clone(empty_quadfloat),_10 : variable_clone(empty_quadfloat),_11 : variable_clone(empty_quadfloat),
				_12 : variable_clone(empty_quadfloat),_13 : variable_clone(empty_quadfloat),_14 : variable_clone(empty_quadfloat),_15 : variable_clone(empty_quadfloat)
				};

_simple_f_vec16 = 
	{
		_0 : 0.,_1 : 0.,_2 : 0.,_3 : 0.,_4 : 0.,_5 : 0.,_6 : 0.,_7 : 0.,
		_8 : 0.,_9 : 0.,_10 : 0.,_11 : 0.,_12 : 0.,_13 : 0.,_14 : 0.,_15 : 0.
	}
_simple_f_vec8 = 
	{
		_0 : 0.,_1 : 0.,_2 : 0.,_3 : 0.,_4 : 0.,_5 : 0.,_6 : 0.,_7 : 0.,
	}
	
//exe_test_f_32_vec_16(variable_clone(_simple_f_vec16));


var _key_length = 51;
var _key_max = power(2,_key_length)-1;
var _key = exe_create_random_key(_key_length);
//_key = 5674703573754352 //here we can set key manualy;
show_debug_message("_key_length : " + string(_key_length) + " | _key_max : " + string(_key_max) + " | _key : " + string(_key)	);
var _open_text = exe_spawn_random_message(variable_clone(_simple_f_vec16));
var _copy_open_text = variable_clone(_open_text);
show_debug_message("_open_text : " + string(_open_text));
var _cipher = exe_crypt_msg_v2(_open_text,_key_max,_key,_key_length);
show_D(_cipher.scale,"_cipher scale");
show_D(_cipher.msg,"_cipher");


var _t1 = variable_clone(current_time);
/*
show_debug_message("key ok : ");
var _decipher = exe_decrypt_msg_v2(_cipher,_key_max,_key,_key_length);
show_debug_message("_open_text : " + string(_copy_open_text));
show_debug_message("_deci_text : " + string(_decipher));
var _comp_text = compare_ori_deciph(_copy_open_text,_decipher);
show_debug_message("_comp_text : " + string(_comp_text));
*/

/*
for(var _dt = 0; _dt < _key_max+1; _dt++)
	{
		//var _decipher = exe_decrypt_msg(_cipher,_key_max,_key);
		show_debug_message("try key : " + string(_key_max+_dt));
		var _decipher = exe_decrypt_msg(_cipher,_key_max,_key_max+_dt);
		show_debug_message("_open_text : " + string(_copy_open_text));
		show_debug_message("_deci_text : " + string(_decipher));
		var _comp_text = compare_ori_deciph(_copy_open_text,_decipher);
		show_debug_message("_comp_text : " + string(_comp_text));
	}
*/
//for(var _dt = _key_max; _dt < _key_max+_key_max+1; _dt+=1)
for(var _dt = _key - 30; _dt < _key+31; _dt+=1)
	{
		//var _decipher = exe_decrypt_msg(_cipher,_key_max,_key);
		show_debug_message("try key : " + string(_dt));
		var _decipher = exe_decrypt_msg_v2(_cipher,_key_max,_dt,_key_length);
		show_debug_message("_open_text : " + string(_copy_open_text));
		show_debug_message("_deci_text : " + string(_decipher));
		var _comp_text = compare_ori_deciph(_copy_open_text,_decipher);
		show_debug_message("_comp_text : " + string(_comp_text));
	}

show_debug_message("elapsed time : " + string(current_time-_t1));


