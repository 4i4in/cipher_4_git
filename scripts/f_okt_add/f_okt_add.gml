function f_okt_add(_okt1,_okt2)
{
    var sum = {};
    for (var i = 0; i < 8; i++) 
		{
	        var key = "_" + string(i);
			var value = _okt1[$ key] + _okt2[$ key];
			struct_set(sum,key,value);
	        //sum[$ key] = _okt1[$ key] + _okt2[$ key];
	    }
    return sum;
}
