function f_quat_sub(_q1, _q2)
{
    return 
	{
        _0: _q1._0 - _q2._0,
        _1: _q1._1 - _q2._1,
        _2: _q1._2 - _q2._2,
        _3: _q1._3 - _q2._3
    };
}