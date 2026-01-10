function truncate_to_single(_v) 
{
    var s = string_format(_v, 0, truncate);
    return real(s);
}