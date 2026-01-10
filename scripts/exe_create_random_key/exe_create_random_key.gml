function exe_create_random_key(_key_length)
{
	var _key_max = power(2,_key_length)-1;
	if _key_length > 32
		{
			return(irandom(_key_max));
		}
	return(_key_max + irandom(_key_max));
}