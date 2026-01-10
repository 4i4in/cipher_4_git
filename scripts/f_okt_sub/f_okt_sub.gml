function f_okt_sub(_okt1, _okt2)
{
    var diff = {};
    for (var i = 0; i < 8; i++) 
		{
	        var key = "_" + string(i);
			var value = _okt1[$ key] - _okt2[$ key];
			struct_set(diff,key,value);
	        //diff[$ key] = _okt1[$ key] - _okt2[$ key];
	    }
    return diff;
}