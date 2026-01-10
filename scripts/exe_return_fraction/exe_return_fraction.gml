function exe_return_fraction(_key,_r,fraction,_rounds)
{
	var _hash = sha1_string_unicode(string(_key)+ string(_r));
	var _a = string_ord_at(_hash, 1);
	var _b = string_ord_at(_hash, 17);
	var _c = string_ord_at(_hash, 13);
	var _small = ((_a ^ _b) % 211. - 101.) / 1009.;     // -0.1 .. +0.099
	var _tiny  = ((_c ^ _b) % 53.  - 29.)  / 1279.0;     // -0.025 .. +0.024
	var _typ = floor((_c ^ _a) + _rounds) % 4;
	switch (_typ) 
		{   // cykle 4 różne phi
		    case 0: fraction = fraction + _r *(.1+_small-_tiny); 
				break;                        
		    case 1: 
			fraction = clamp(fraction*_small*_tiny*_tiny,-1+abs(_tiny),1.-abs(_tiny));
			fraction = arcsin(fraction); 
				break;               
		    case 2: fraction = power(fraction-_tiny, _r*(0.4+_small*0.2)); 	
				break;
		    case 3: fraction = logn(_rounds-_tiny, fraction * (_r+7. +_small*2.));
				break;
		}
	return(fraction);
}