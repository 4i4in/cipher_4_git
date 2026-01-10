function compute_projection_v_i_j_quad(_ny_vec, i)
{
    var vi = _ny_vec[$ "_" + string(i)];
    if (abs(vi) < EPSILON) return undefined;

    var s_i = quadfloat_inverse(quadfloat_from_real(vi));

    var proj = { };
    for (var j = 0; j < 16; j++) {
        var qj = quadfloat_from_real(_ny_vec[$ "_" + string(j)]);
        proj[$ "_" + string(j)] = quadfloat_mul(qj, s_i);
    }

    var sum_im_sq = quadfloat_from_real(0.0);
    for (var j = 0; j < 16; j++) {
        if (j != i) sum_im_sq = quadfloat_add(sum_im_sq, quadfloat_sqr(proj[$ "_" + string(j)]));
    }

    var gamma_i = quadfloat_div(proj._0, quadfloat_sqrt(quadfloat_from_real(1.0) - sum_im_sq));
    var delta_sq = sum_im_sq;

    return { proj: proj, gamma: gamma_i, delta_sq: delta_sq };
}