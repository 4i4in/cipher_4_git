function f_conj_okt(_oktonion)
{
    var conj = variable_clone(_oktonion);   // kopia
    conj._0 = _oktonion._0;   // real bez zmian
    for (var i = 1; i < 8; i++) 
		{
	        var key = "_" + string(i);
	        conj[$ key] = -_oktonion[$ key];   // neg imagin e1-e7
	    }
    return conj;
}