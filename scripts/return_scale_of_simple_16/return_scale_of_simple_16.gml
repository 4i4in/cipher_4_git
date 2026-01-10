function return_scale_of_simple_16(_ny_vec)
{
	var sum_16_sq =	0.;	
	for(var _i = 0; _i < 16; _i++)
		{
			sum_16_sq += sqr(_ny_vec[$ "_"+string(_i)]);
		}
		
	if (	abs(1.-sum_16_sq) > EPSILON	)
		{
			return(1./sqrt(sum_16_sq))
		}
	else{return(1.);}
}