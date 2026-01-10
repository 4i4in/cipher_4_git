function f_quat_conj(_quat)
{
	var conj = variable_clone(_quat);
    conj._0 = _quat._0;
    conj._1 = -_quat._1;
    conj._2 = -_quat._2;
    conj._3 = -_quat._3;
    return conj;
}